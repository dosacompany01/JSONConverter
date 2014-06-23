//
//  JSONFactoryTest.m
//  JSONLibraryTest
//
//  Created by LeeChooHyoung on 2014. 6. 6..
//  Copyright (c) 2014년 privateCompany. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "House.h"
#import "Person.h"
#import "JSONFactory.h"
#import "RuntimeClassOperator.h"
#import "PersonHasArray.h"

@interface JSONFactoryTest : XCTestCase
@property (nonatomic, retain) House             *house;
@property (nonatomic, retain) Person            *person;
@property (nonatomic, retain) PersonHasArray    *personHasArray;
@end

@implementation JSONFactoryTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    House *newHouse = [[House alloc] initWithCountry:@"U.S.A"
                                                city:@"NewYork"];
    self.house = newHouse;
    [newHouse release];
    
    Person *newPerson = [[Person alloc] initWithFirstName:@"John"
                                                 lastName:@"Doe"
                                                   height:[NSNumber numberWithInt:200]
                                                   weight:[NSNumber numberWithInt:80]
                                                  address:@"U.S.A NewYork"
                                                    house:self.house];
    self.person = newPerson;
    [newPerson release];
    
    NSMutableArray *houses = [[NSMutableArray alloc] init];
    for(int i = 0 ; i < 10 ; i++)
    {
        NSString *newCountry = [NSString stringWithFormat:@"%d country", i];
        NSString *newCity = [NSString stringWithFormat:@"%d city", i];
        House *newHouse = [[House alloc] initWithCountry:newCountry
                                                    city:newCity];
        [houses addObject:newHouse];
    }
    
    PersonHasArray *newPersonHasArray = [[PersonHasArray alloc] initWithFirstName:@"ChooHyoung"
                                                                         lastName:@"Lee"
                                                                           height:[NSNumber numberWithInt:100]
                                                                           weight:[NSNumber numberWithInt:50]
                                                                          address:@"noWhere"
                                                                            house:nil
                                                                        oldHouses:[NSArray arrayWithArray:houses]];
    [houses release];
    self.personHasArray = newPersonHasArray;
    [newPersonHasArray release];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [_house release];
    [_person release];
    [super tearDown];
}

//- (void)testExample
//{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}

/*!
 you can create JSON representable object.
 */
- (void)testCreateJSONWithObject
{
    NSDictionary *personJSONObject = [JSONFactory createJSONObjectWithCustomObject:self.person];
    XCTAssertNotNil(personJSONObject, @"personJSONObject is nil.");
    
    BOOL jsonRepresentable = [NSJSONSerialization isValidJSONObject:personJSONObject];
    XCTAssertEqual(jsonRepresentable, YES, @"personJSONObject is not JSON representable.");
}

/*!
 you can serialize using JSONFactory, JSONConverter and NSJSONSerialization.
 */
- (void)testSerialization
{
    NSDictionary *personJSONObject = [JSONFactory createJSONObjectWithCustomObject:self.person];
    XCTAssertNotNil(personJSONObject, @"personJSONObject is nil.");
    
    BOOL jsonRepresentable = [NSJSONSerialization isValidJSONObject:personJSONObject];
    XCTAssertEqual(jsonRepresentable, YES, @"personJSONObject is not JSON representable.");
    
    NSError *serializationError = nil;
    NSData *serializedData = [NSJSONSerialization dataWithJSONObject:personJSONObject
                                                          options:NSJSONWritingPrettyPrinted
                                                            error:&serializationError];
    
    XCTAssertNotNil(serializedData, @"serializedData is nil.");
    XCTAssertNil(serializationError, @"serializationError is not nil.");
}

/*!
 you can de-serialize using JSONFactory, JSONConverter and NSJSONSerialization.
 */
- (void)testDeSerialization
{
    NSDictionary *personJSONObject = [JSONFactory createJSONObjectWithCustomObject:self.person];
    NSError *serializationError = nil;
    NSData *jsonRawData = [NSJSONSerialization dataWithJSONObject:personJSONObject
                                                          options:NSJSONWritingPrettyPrinted
                                                            error:&serializationError];
    XCTAssertNotNil(jsonRawData, @"serializedData is nil.");
    XCTAssertNil(serializationError, @"serializationError is not nil.");
    
    NSError *deSerializationError = nil;
    id deSerializedObject = [NSJSONSerialization JSONObjectWithData:jsonRawData
                                                    options:NSJSONReadingMutableContainers
                                                      error:&deSerializationError];
    XCTAssertNotNil(deSerializedObject, @"jsonObject is nil.");
    XCTAssertNil(deSerializationError, @"deSerializationError is not nil.");
    
    Person *newPerson = [JSONFactory createCustomObjectWithJSONDictionary:deSerializedObject
                                                              customClass:[Person class]];
    XCTAssertNotNil(newPerson, @"newPerson is nil.");
    
    NSArray *properties = [RuntimeClassOperator getAllPropertiesWithClass:[Person class]];
    for(NSString *property in properties)
    {
        id value = [newPerson valueForKey:property];
        XCTAssertNotNil(value, @"newPerson.%@ is nil.", property);
    }
}

/*!
 you can serialize and de-serialize with NSDictionary contains object.
 */
- (void)testSerializationAndDeserializationWithDictionary
{
    Person *p1, *p2, *p3;
    p1 = [self.person copy];
    [p1 setLastName:@"p1"];
    
    p2 = [self.person copy];
    [p2 setLastName:@"p2"];
    
    p3 = [self.person copy];
    [p3 setLastName:@"p3"];
    
    NSDictionary *personObjectDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     p1, @"p1", p2, @"p2", p3, @"p3",
                                     @"This is test NSString value", @"NSString key",
                                     [NSNumber numberWithInt:100000], @"NSNumber key", nil];
    
    NSDictionary *personDicJSONObject = [JSONFactory createJSONObjectWithDictionary:personObjectDic];
    XCTAssertNotNil(personDicJSONObject, @"personDicJSONObject is nil.");
    
    BOOL jsonRepresentable = [NSJSONSerialization isValidJSONObject:personDicJSONObject];
    XCTAssertEqual(jsonRepresentable, YES, @"personDicJSONObject is not JSON representable.");
    
    [p1 release];
    [p2 release];
    [p3 release];
    
    NSDictionary *objectDic = [JSONFactory createNSDictionaryWithJSONObject:personDicJSONObject
                                                             customClass:[Person class]];
    XCTAssertNotNil(objectDic, @"objectDic is nil.");
}

/*!
 you can create JSON representable from NSArray.
 */
- (void)testSerializationAndDeserializationWithNSArray
{
    NSMutableArray *personArray = [[NSMutableArray alloc] init];
    for(int i = 0 ; i < 10 ; i++)
    {
        Person *newPerson = [self.person copy];
        [personArray addObject:newPerson];
    }
    
    NSArray *personArrayJSONObject = [JSONFactory createJSONObjectWithArray:personArray];
    XCTAssertNotNil(personArrayJSONObject, @"jsonObject is nil.");
    XCTAssertNotEqual(personArrayJSONObject.count, 0, @"jsonObject.count is 0");
    
    BOOL jsonRepresentable = [NSJSONSerialization isValidJSONObject:personArrayJSONObject];
    XCTAssertEqual(jsonRepresentable, YES, @"jsonObject is not JSON representable.");
    
    NSArray *objectArr = [JSONFactory createNSArrayWithJSONObject:personArrayJSONObject
                                                      customClass:[Person class]];
    XCTAssertNotNil(objectArr, @"objectArr is nil!");
    XCTAssertNotEqual(objectArr.count, 0, @"objectArr.count is 0");
}

/*!
 you can create JSON representable from derived Class.
 */
- (void)testSerializationWithDerivedClass
{
    NSDictionary *newPersonJSONObject = [JSONFactory createJSONObjectWithCustomObject:self.personHasArray];
    XCTAssertNotNil(newPersonJSONObject, @"newPersonJSONObject is nil.");
}

/*!
 you can get instance of object from JSON representable.
 */
- (void)testDeSerializationWithDerivedClass
{
    NSDictionary *newPersonJSONObject = [JSONFactory createJSONObjectWithCustomObject:self.personHasArray];
    PersonHasArray *newPersonHasArray = [JSONFactory createCustomObjectWithJSONDictionary:newPersonJSONObject
                                                                          customClass:[PersonHasArray class]];
    XCTAssertNotNil(newPersonHasArray, @"newPersonHasArray is nil.");
}

@end
