//
//  RuntimeClassInfo.m
//  JSONLibraryTest
//
//  Created by LeeChooHyoung on 2014. 6. 4..
//  Copyright (c) 2014년 privateCompany. All rights reserved.
//

#import "RuntimeClassOperator.h"

@implementation RuntimeClassOperator

+ (void)printAllIVarsWithObject:(NSObject *)object
{
    Class classObj = object.class;
    unsigned int iVarListCount = 0;
    Ivar *iVarListPtr = class_copyIvarList(classObj, &iVarListCount);
    
    for(int i = 0 ; i < iVarListCount ; i++)
    {
        const char *iVarNamePtr = ivar_getName(iVarListPtr[i]);
        
        Ivar iVar = class_getInstanceVariable(classObj, iVarNamePtr);
        if(iVar != NULL)
        {
            id valueOfIvar = object_getIvar(object, iVar);
            
            if(valueOfIvar != nil)
            {
                DLog(@"%@ iVar [name : %s, value : %@]", classObj, iVarNamePtr, valueOfIvar);
            }
        }
    }
}

+ (void)printAllPropertiesWithObject:(NSObject *)object
{
    Class classObj = object.class;
    unsigned int propertyListCount = 0;
    objc_property_t *propertyListPtr = class_copyPropertyList(classObj, &propertyListCount);
    
    for(int i = 0 ; i < propertyListCount ; i++)
    {
        const char *propertyNamePtr = property_getName(propertyListPtr[i]);
        
        objc_property_t property = class_getProperty(classObj, propertyNamePtr);
        const char *attrNamePtr = property_getAttributes(property);
        
        DLog(@"%@ property [name : %s, attr :%s", classObj, propertyNamePtr, attrNamePtr);
    }
    
    if(propertyListCount > 0)
    {
        free(propertyListPtr);
    }
}

+ (NSArray *)getAllPropertiesWithObject:(NSObject *)object
{
    NSArray *result = nil;
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    Class classObj = object.class;
    unsigned int propertyListCount = 0;
    objc_property_t *propertyListPtr = class_copyPropertyList(classObj, &propertyListCount);
    
    for(int i = 0 ; i < propertyListCount ; i++)
    {
        const char *propertyNamePtr = property_getName(propertyListPtr[i]);
        NSString *propertyName = [NSString stringWithUTF8String:propertyNamePtr];
        [tmpArr addObject:propertyName];
    }
    
    if(propertyListCount > 0)
    {
        free(propertyListPtr);
    }
    
    result = [NSArray arrayWithArray:tmpArr];
    [tmpArr release];
    
    return result;
}

+ (NSArray *)getAllPropertiesWithClass:(Class)classObject
{
    NSArray *result = nil;
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    unsigned int propertyListCount = 0;
    objc_property_t *propertyListPtr = class_copyPropertyList(classObject, &propertyListCount);
    
    for(int i = 0 ; i < propertyListCount ; i++)
    {
        const char *propertyNamePtr = property_getName(propertyListPtr[i]);
        NSString *propertyName = [NSString stringWithUTF8String:propertyNamePtr];
        [tmpArr addObject:propertyName];
    }
    
    if(propertyListCount > 0)
    {
        free(propertyListPtr);
    }
    
    result = [NSArray arrayWithArray:tmpArr];
    [tmpArr release];
    
    return result;
}

+ (NSDictionary *)getAllPropertiesAndTypeWithClass:(Class)classObject;
{
    NSDictionary *result = nil;
    NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
    unsigned int propertyListCount = 0;
    objc_property_t *propertyListPtr = class_copyPropertyList(classObject, &propertyListCount);
    
    for(int i = 0 ; i < propertyListCount ; i++)
    {
        const char *propertyNamePtr = property_getName(propertyListPtr[i]);
        objc_property_t property = class_getProperty(classObject, propertyNamePtr);
        const char *attrNamePtr = property_getAttributes(property);
        NSString *attrStr = [NSString stringWithUTF8String:attrNamePtr];
        NSArray *attrArr = [attrStr componentsSeparatedByString:@","];
        NSString *typeStr = nil;
        
        for(NSString *splitedAttr in attrArr)
        {
            NSRange findRange = [splitedAttr rangeOfString:@"T@"];
            if(findRange.location != NSNotFound && findRange.length != 0)
            {
                typeStr = splitedAttr;
                break;
            }
        }
        
        NSArray *trashStrArr = [typeStr componentsSeparatedByString:@"\""];
        typeStr = [trashStrArr objectAtIndex:1];
        
        [tmpDic setValue:typeStr
                  forKey:[NSString stringWithUTF8String:propertyNamePtr]];
    }
    
    if(propertyListCount > 0)
    {
        free(propertyListPtr);
    }
    
    result = [NSDictionary dictionaryWithDictionary:tmpDic];
    [tmpDic release];
    
    return result;
}

+ (id)createObjectWithClass:(Class)classObject
{
    id createdInstance = class_createInstance(classObject, class_getInstanceSize(classObject));
    return createdInstance;
}

@end
