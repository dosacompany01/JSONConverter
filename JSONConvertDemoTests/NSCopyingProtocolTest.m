//
//  NSCopyingTest.m
//  JSONLibraryTest
//
//  Created by LeeChooHyoung on 2014. 6. 6..
//  Copyright (c) 2014년 privateCompany. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Person.h"
#import "House.h"

@interface NSCopyingProtocolTest : XCTestCase
@property (nonatomic, retain) House *oldHouse;
@property (nonatomic, retain) Person *oldPerson;
@end

@implementation NSCopyingProtocolTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    House *oldHouse = [[House alloc] initWithCountry:@"대한민국" city:@"서울특별시"];
    self.oldHouse = oldHouse;
    [oldHouse release];
    
    Person *oldPerson = [[Person alloc] initWithFirstName:@"주형"
                                                 lastName:@"이"
                                                   height:[NSNumber numberWithInt:172]
                                                   weight:[NSNumber numberWithInt:82]
                                                  address:@"서울시 성북구 정릉4동"
                                                    house:self.oldHouse];
    self.oldPerson = oldPerson;
    [oldPerson release];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [_oldPerson release];
    [_oldHouse release];
    [super tearDown];
}

//- (void)testExample
//{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}

- (void)testHouseImplementsNSCopyingProtocol
{
    House *newHouse = [self.oldHouse copy];
    XCTAssertNotEqualObjects(newHouse, self.oldHouse, @"two object is not supposed to be same.");
}

- (void)testPersonImplementsNSCopyingProtocol
{
    Person *newPerson = [self.oldPerson copy];
    XCTAssertNotEqualObjects(self.oldPerson, newPerson, @"Person Class should implements NSCopying protocol.");
}

- (void)testComplexImplementsNSCopyingProtocol
{
    Person *newPerson = [self.oldPerson copy];
    XCTAssertNotEqualObjects(self.oldPerson, newPerson, @"Person Class should implements NSCopying protocol properly.");
    
    newPerson.house = [self.oldHouse copy];
    XCTAssertNotEqualObjects(self.oldPerson.house, newPerson.house, @"House Class should implements NSCopying protocol properly.");
}
@end
