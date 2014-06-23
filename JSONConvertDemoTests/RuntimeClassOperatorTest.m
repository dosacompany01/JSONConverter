//
//  RuntimeClassOperatorTest.m
//  JSONLibraryTest
//
//  Created by LeeChooHyoung on 2014. 6. 6..
//  Copyright (c) 2014년 privateCompany. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Person.h"
#import "House.h"
#import "RuntimeClassOperator.h"

@interface RuntimeClassOperatorTest : XCTestCase
@property (nonatomic, retain) House *oldHouse;
@property (nonatomic, retain) Person *oldPerson;
@end

@implementation RuntimeClassOperatorTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    House *oldHouse = [[House alloc] initWithCountry:@"South Korea" city:@"Seoul"];
    Person *oldPerson = [[Person alloc] initWithFirstName:@"John"
                                                 lastName:@"Doe"
                                                   height:[NSNumber numberWithInteger:172]
                                                   weight:[NSNumber numberWithInteger:82]
                                                  address:@"Seoul, South Korea"
                                                    house:oldHouse];
    
    self.oldHouse = oldHouse;
    self.oldPerson = oldPerson;
    
    [oldHouse release];
    [oldPerson release];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [_oldHouse release];
    [_oldPerson release];
    [super tearDown];
}

//- (void)testExample
//{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}

- (void)testCreateInstance
{
    id newInstance = [RuntimeClassOperator createObjectWithClass:[House class]];
    XCTAssertNotNil(newInstance, @"newInstance must not be a nil.");
}

- (void)testGetAllProperty
{
    NSArray *properties = [RuntimeClassOperator getAllPropertiesWithClass:self.oldHouse.class];
    XCTAssertNotNil(properties, @"properties must not be a nil.");
    XCTAssertNotEqual(properties.count, 0, @"properties.count must not be a 0.");
}

- (void)testGetAllPropertyWithType
{
    NSDictionary *housePropertiesAndType = [RuntimeClassOperator getAllPropertiesAndTypeWithClass:self.oldHouse.class];
    XCTAssertNotNil(housePropertiesAndType, @"housePropertiesAndType must not be a nil.");
    XCTAssertNotEqual(housePropertiesAndType.count, 0, @"housePropertiesAndType.count must not be a 0.");
    
    NSDictionary *personPropertiesAndType = [RuntimeClassOperator getAllPropertiesAndTypeWithClass:self.oldPerson.class];
    XCTAssertNotNil(personPropertiesAndType, @"personPropertiesAndType must not be a nil.");
    XCTAssertNotEqual(personPropertiesAndType.count, 0, @"personPropertiesAndType.count must not be a 0.");
}

@end
