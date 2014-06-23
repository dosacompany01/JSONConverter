//
//  House.m
//  JSONLibraryTest
//
//  Created by LeeChooHyoung on 2014. 6. 5..
//  Copyright (c) 2014년 privateCompany. All rights reserved.
//

#import "House.h"
#import "JSONConverter.h"

@implementation House

- (id)initWithCountry:(NSString *)country city:(NSString *)city
{
    self = [super init];
    if(self)
    {
        _country = [country copy];
        _city = [city copy];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    House *newHouse = [[House alloc] initWithCountry:self.country
                                                city:self.city];
    return newHouse;
}

- (void)dealloc
{
    [_country release];
    [_city release];
    [super dealloc];
}

@end
