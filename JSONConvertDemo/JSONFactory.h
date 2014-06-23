//
//  JSONObjectCreator.h
//  JSONLibraryTest
//
//  Created by LeeChooHyoung on 2014. 6. 5..
//  Copyright (c) 2014년 privateCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONConverterInterface.h"

/*!
 Factory Class for convinience.
 
 */
@interface JSONFactory : NSObject
/*!
 Create JSON representable NSDictionary.
 
 Created NSDictionary will be consisted of NSString key, NSString value.
 
 NSString key and NSString value will be extracted from sourceObj implements JSONConverterInterface.
 
 @param sourceObj object that implements JSONConverterInterface
 @return NSDictionary object contains NSString key, NSString value
 */
+ (NSDictionary *)createJSONObjectWithCustomObject:(NSObject<JSONConverterInterface> *)sourceObj;

/*!
 Create JSON representable NSDictionary.
 
 All object in dictionary parameter will be converted as NSString key, NSString value. 
 
 And if object in dictionary parameter has other child object, child object converted in same way.
 
 @param dictionary NSDictionary object contains real object
 @return NSDictionary object contains NSString key, NSString value
 */
+ (NSDictionary *)createJSONObjectWithDictionary:(NSDictionary *)dictionary;

/*!
 Create JSON representable NSArray.
 
 All object in array parameter will be converted as NSDictionary first.
 
 @param array NSArray object contains real object
 @return NSArray object contains dictionary(has NSString key, NSString value)
 */
+ (NSArray *)createJSONObjectWithArray:(NSArray *)array;

/*!
 Create object(instantiated from User define Class) implements JSONConverterInterface.
 
 NOTE: jsonObject parameter should has exactly same key(property name of User define Class).
 
 @param jsonObject NSDictionary object contains NSString key, NSString value
 @param customClass User Define Class object
 @return object (instantiated from User define Class) implements JSONConverterInterface
 */
+ (id)createCustomObjectWithJSONDictionary:(NSDictionary *)jsonObject customClass:(Class)customClass;

/*!
 Create NSDictionary contains object(instantiated from User Define Class).
 
 NOTE: jsonObject should has sub dictionary(JSON representable) and sub dictionary should has exactly same key(property name of User define Class).
 
 @param jsonObject NSDictionary object contains NSString based key, value
 @param customClass User Define Class object
 @return NSDictionary object contains object
 */
+ (NSDictionary *)createNSDictionaryWithJSONObject:(NSDictionary *)jsonObject customClass:(Class)customClass;

/*!
 Create NSArray contains object(instantiated from User Define Class).
 
 NOTE: jsonObject should has sub dictionary(JSON representable) and sub dictionary should has exactly same key(property name of User define Class).
 
 @param jsonObject NSArray object contains sub dictionary
 @param customClass User Define Class object
 @return NSArray object contains object
 */
+ (NSArray *)createNSArrayWithJSONObject:(NSArray *)jsonObject customClass:(Class)customClass;

@end
