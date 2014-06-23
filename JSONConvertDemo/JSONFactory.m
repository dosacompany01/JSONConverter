//
//  JSONObjectCreator.m
//  JSONLibraryTest
//
//  Created by LeeChooHyoung on 2014. 6. 5..
//  Copyright (c) 2014년 privateCompany. All rights reserved.
//

#import "JSONFactory.h"
#import "RuntimeClassOperator.h"

@implementation JSONFactory

+ (NSDictionary *)createJSONObjectWithCustomObject:(NSObject<JSONConverterInterface> *)sourceObj
{
    NSDictionary *jsonObject = nil;
    
    if([sourceObj conformsToProtocol:@protocol(JSONConverterInterface)] == YES)
    {
        jsonObject = [sourceObj createJSONObject];
    }
    
    return jsonObject;
}

+ (NSDictionary *)createJSONObjectWithDictionary:(NSDictionary *)dictionary
{
    NSDictionary *jsonObject = nil;
    NSMutableDictionary *tmpJSONObject = [[NSMutableDictionary alloc] init];
    NSArray *keys = [dictionary allKeys];
    for(NSString *key in keys)
    {
        id value = [dictionary valueForKey:key];
        if([value conformsToProtocol:@protocol(JSONConverterInterface)] == YES)
        {
            [tmpJSONObject setValue:[value createJSONObject] forKey:key];
        }
        else
        {
            [tmpJSONObject setValue:value forKeyPath:key];
        }
    }
    
    jsonObject = [NSDictionary dictionaryWithDictionary:tmpJSONObject];
    [tmpJSONObject release];
    
    return jsonObject;
}

+ (NSArray *)createJSONObjectWithArray:(NSArray *)array
{
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    
    for (NSObject *obj in array)
    {
        if([obj conformsToProtocol:@protocol(JSONConverterInterface)] == YES)
        {
            [tmpArray addObject:[(NSObject<JSONConverterInterface> *)obj createJSONObject]];
        }
    }
    
    NSArray *jsonObject = [NSArray arrayWithArray:tmpArray];
    [tmpArray release];
    return jsonObject;
}

+ (id)createCustomObjectWithJSONDictionary:(NSDictionary *)jsonObject customClass:(Class)customClass
{
    id instanceOfClassObject = [RuntimeClassOperator createObjectWithClass:customClass];
    id resultValue = nil;
    
    if([instanceOfClassObject conformsToProtocol:@protocol(JSONConverterInterface)] == YES)
    {
        resultValue = [instanceOfClassObject createInstanceWithJSONObject:jsonObject];
    }
    
    return resultValue;
}

+ (NSDictionary *)createNSDictionaryWithJSONObject:(NSDictionary *)jsonObject customClass:(Class)customClass
{
    NSMutableDictionary *instancesDic = [[NSMutableDictionary alloc] init];
    
    if([jsonObject isKindOfClass:[NSDictionary class]] == YES)
    {
        NSArray *keys = [jsonObject allKeys];
        for(NSString *key in keys)
        {
            id value = [jsonObject valueForKey:key];
            //if jsonObject has sub dictionary
            if([value isKindOfClass:[NSDictionary class]])
            {
                NSArray *subProperties = [RuntimeClassOperator getAllPropertiesWithClass:customClass];
                NSArray *subKeys = [value allKeys];
                BOOL subPropertiesContainsAllSubKey = NO;
                
                //check sub directory has all property of customClass
                for(NSString *subKey in subKeys)
                {
                    subPropertiesContainsAllSubKey = [subProperties containsObject:subKey];
                }
                
                if(subPropertiesContainsAllSubKey == YES)
                {
                    id newInstance = class_createInstance(customClass, class_getInstanceSize(customClass));
                    if([newInstance conformsToProtocol:@protocol(JSONConverterInterface)] == YES)
                    {
                        value = [newInstance createInstanceWithJSONObject:value];
                    }
                }
            }
            [instancesDic setValue:value forKey:key];
        }
    }
    
    NSDictionary *result = [NSDictionary dictionaryWithDictionary:instancesDic];
    [instancesDic release];
    
    return result;
}

+ (NSArray *)createNSArrayWithJSONObject:(NSArray *)jsonObject customClass:(Class)customClass
{
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    
    for(id subJSONObject in jsonObject)
    {
        id instanceOfClassObject = [RuntimeClassOperator createObjectWithClass:customClass];
        if([instanceOfClassObject conformsToProtocol:@protocol(JSONConverterInterface)] == YES &&
           [subJSONObject isKindOfClass:[NSDictionary class]] == YES)
        {
            [tmpArr addObject:[instanceOfClassObject createInstanceWithJSONObject:subJSONObject]];
        }
    }
    
    NSArray *resultValue = [NSArray arrayWithArray:tmpArr];
    [tmpArr release];
    
    return resultValue;
}
@end
