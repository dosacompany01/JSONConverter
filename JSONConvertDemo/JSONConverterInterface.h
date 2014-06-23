//
//  JSONRepresentableInterface.h
//  JSONLibraryTest
//
//  Created by LeeChooHyoung on 2014. 6. 6..
//  Copyright (c) 2014년 privateCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 All Class(has responsibility for creating JSON representable object) should implements this protocol.
 
 @sa NSJSONSerialization class
 @sa Objective-C Runtime Reference
 @sa RuntimeClassOperator class
 */
@protocol JSONConverterInterface <NSObject>

@required
/*!
 Create NSDictionary(JSON representable object).
 
 @return NSDictionary object
 */
- (NSDictionary *)createJSONObject;

/*!
 Create instance of object implements JSONConverterInterface protocol.
 
 @param NSDictionary(JSON representable object)
 @return instance of object implements JSONConverterInterface protocol
 */
- (NSObject<JSONConverterInterface> *)createInstanceWithJSONObject:(NSDictionary *)jsonObject;

/*!
 Return Class object of property.
 
 @return Class objet
 */
- (Class)getSubClassObjectWithPropertyName:(NSString *)propertyName;

@end
