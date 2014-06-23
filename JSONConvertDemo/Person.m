//
//  Person.m
//  JSONLibraryTest
//
//  Created by LeeChooHyoung on 2014. 6. 4..
//  Copyright (c) 2014년 privateCompany. All rights reserved.
//

#import <objc/runtime.h>
#import "Person.h"
#import "House.h"
#import "JSONConverter.h"

@implementation Person

- (id)initWithFirstName:(NSString *)firstName
               lastName:(NSString *)lastName
                 height:(NSNumber *)height
                 weight:(NSNumber *)weight
                address:(NSString *)address
                  house:(House *)house
{
    self = [super init];
    if(self)
    {
        _firstName = [firstName copy];
        _lastName = [lastName copy];
        _height = [height copy];
        _weight = [weight copy];
        _address = [address copy];
        _house = [house copy];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    Person *newPerson = [[Person alloc] initWithFirstName:self.firstName
                                                 lastName:self.lastName
                                                   height:self.height
                                                   weight:self.weight
                                                  address:self.address
                                                    house:self.house];
    return newPerson;
}

- (void)dealloc
{
    [_firstName release];
    [_lastName release];
    [_height release];
    [_weight release];
    [_address release];
    [_house release];
    [super dealloc];
}

@end
