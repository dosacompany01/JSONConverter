//
//  JSONRepresentable.m
//  JSONLibraryTest
//
//  Created by LeeChooHyoung on 2014. 6. 6..
//  Copyright (c) 2014년 privateCompany. All rights reserved.
//

#import "JSONConverter.h"
#import "RuntimeClassOperator.h"

@implementation JSONConverter

- (id)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - JSONRepresentableInterface protocol
- (NSDictionary *)createJSONObject
{
    /*
     check object this Class is derived or not.
     if this is derived get all properties and type of super.
     TODO: What if RuntimeClassOperator return all properties and type Dictionary of super class?
     */
    NSDictionary *superPropertiesAndType = nil;
    if([self.superclass conformsToProtocol:@protocol(JSONConverterInterface)] == YES)
    {
        superPropertiesAndType = [RuntimeClassOperator getAllPropertiesAndTypeWithClass:self.superclass];
    }
    
    NSMutableDictionary *tmpJSONObject = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *mutablePropertiesAndTypeDic =
    [[RuntimeClassOperator getAllPropertiesAndTypeWithClass:self.class] mutableCopy];
    
    //merge superProperties and properties
    if(superPropertiesAndType != nil)
    {
        NSArray *keys = [superPropertiesAndType allKeys];
        for(NSString *key in keys)
        {
            [mutablePropertiesAndTypeDic setValue:[superPropertiesAndType valueForKey:key] forKey:key];
        }
    }
    
    NSArray *propertyNames = [mutablePropertiesAndTypeDic allKeys];
    
    //check type of all attributes(using property name) of this object
    for (NSString *propertyName in propertyNames)
    {
        NSString *attributeType = [mutablePropertiesAndTypeDic valueForKey:propertyName];
        Class classObj = objc_getClass([attributeType UTF8String]);
        
        //if property of this class comform JSONConverterInterface, create JSON object recursively
        if([classObj conformsToProtocol:@protocol(JSONConverterInterface)] == YES)
        {
            id subJSONObject = [[self valueForKey:propertyName] createJSONObject];
            [tmpJSONObject setValue:(subJSONObject == nil ? [NSNull null] : subJSONObject)
                             forKey:propertyName];
        }
        //if property of this class is sub class of NSArray check the element
        else if([classObj isSubclassOfClass:[NSArray class]] == YES)
        {
            NSMutableArray *newSubArray = [[NSMutableArray alloc] init];
            NSArray *subArray = [self valueForKey:propertyName];
            for(id subObject in subArray)
            {
                if([subObject conformsToProtocol:@protocol(JSONConverterInterface)] == YES)
                {
                    id subObjectJSONObject = [subObject createJSONObject];
                    [newSubArray addObject:(subObjectJSONObject == nil ? [NSNull null] : subObjectJSONObject)];
                }
            }
            [tmpJSONObject setValue:newSubArray forKey:propertyName];
            [newSubArray release];
        }
        else
        {
            id val = [self valueForKey:propertyName];
            [tmpJSONObject setValue:(val == nil ? [NSNull null] : val)
                             forKey:propertyName];
        }
    }
    
    NSDictionary *jsonObject = [NSDictionary dictionaryWithDictionary:tmpJSONObject];
    [tmpJSONObject release];
    [mutablePropertiesAndTypeDic release];
    
    return jsonObject;
}

- (NSObject<JSONConverterInterface> *)createInstanceWithJSONObject:(NSDictionary *)jsonObject
{
    //TODO: Can not find super class`s property!
    NSDictionary *propertiesAndType = [RuntimeClassOperator getAllPropertiesAndTypeWithClass:self.class];
    
    if([jsonObject isKindOfClass:[NSDictionary class]] == YES)
    {
        NSDictionary *jsonDic = (NSDictionary *)jsonObject;
        NSArray *propertyNames = [jsonDic allKeys];
        
        //set value to instance variable of this class from jonsDic using key(property name)
        for(NSString *propertyName in propertyNames)
        {
            /*
             check whether current object has a same property of propertyName or not.
             if current object does not has a same property, just skip, and check next property.
             */
            if([propertiesAndType valueForKey:propertyName] == nil)
            {
                continue;
            }
            
            id val = [jsonDic valueForKey:propertyName];
            if([val isKindOfClass:[NSDictionary class]] == YES)
            {
                /*
                 NOTE:
                 jsonObject should has exactly same name of property.
                 If not, deserializing will fail.
                 */
                NSString *subClassObjectName = [propertiesAndType valueForKey:propertyName];
                Class subClassObject = objc_getClass([subClassObjectName UTF8String]);
                id subObjectInstance = [RuntimeClassOperator createObjectWithClass:subClassObject];
                
                //create instance and set value recursively
                if([subObjectInstance conformsToProtocol:@protocol(JSONConverterInterface)] == YES)
                {
                    val = [subObjectInstance createInstanceWithJSONObject:val];
                }
            }
            else if([val isKindOfClass:[NSArray class]] == YES)
            {
                NSMutableArray *subObjectArr = [[NSMutableArray alloc] init];
                Class subClassObject = [self getSubClassObjectWithPropertyName:propertyName];
                
                if(subClassObject == nil)
                {
                    [subObjectArr release];
                    break;
                }
                
                for(int i = 0 ; i < [(NSArray *)val count] ; i++)
                {
                    NSDictionary *subJsonDic = (NSDictionary *)[(NSArray *)val objectAtIndex:i];
                    id subObjectInstance = [RuntimeClassOperator createObjectWithClass:subClassObject];
                    if([subObjectInstance conformsToProtocol:@protocol(JSONConverterInterface)] == YES)
                    {
                        id subVal = [subObjectInstance createInstanceWithJSONObject:subJsonDic];
                        [subObjectArr addObject:subVal];
                    }
                }
                
                val = [NSArray arrayWithArray:subObjectArr];
                [subObjectArr release];
            }
            
            [self setValue:val
                    forKey:propertyName];
        }
    }
    
    return self;
}

- (Class)getSubClassObjectWithPropertyName:(NSString *)propertyName
{
    return nil;
}

@end
