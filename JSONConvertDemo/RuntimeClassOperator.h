//
//  RuntimeClassInfo.h
//  JSONLibraryTest
//
//  Created by LeeChooHyoung on 2014. 6. 4..
//  Copyright (c) 2014년 privateCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

/*!
 Class for handling Class object in runtime.
 
 @sa Objective-C Runtime Reference
 */
@interface RuntimeClassOperator : NSObject

/*!
 print all IVars of object.
 
 @param object some object to be analyzed
 @return void
 */
+ (void)printAllIVarsWithObject:(NSObject *)object;

/*!
 print all property and attributes of object.
 
 @param object some object to be analyzed
 @return void
 */
+ (void)printAllPropertiesWithObject:(NSObject *)object;

/*!
 create NSArray object contains property of Class.
 
 @param classObject Class object
 @return NSArray object
 */
+ (NSArray *)getAllPropertiesWithClass:(Class)classObject;

/*!
 create NSDictionary object contains property and attributes type of Class.
 
 property and attributes type would be NSString type.
 
 @param object some object to be analyzed.
 @return NSDictionary object
 */
+ (NSDictionary *)getAllPropertiesAndTypeWithClass:(Class)classObject;


/*!
 create object of Class.
 
 @param classObject
 @return object of Class
 */
+ (id)createObjectWithClass:(Class)classObject;
@end
