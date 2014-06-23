//
//  PersonHasArray.m
//  JSONConvertDemo
//
//  Created by LeeChooHyoung on 2014. 6. 10..
//  Copyright (c) 2014년 privateCompany. All rights reserved.
//

#import "PersonHasArray.h"
#import "House.h"

@implementation PersonHasArray

- (id)initWithFirstName:(NSString *)a_firstName
               lastName:(NSString *)a_lastName
                 height:(NSNumber *)a_height
                 weight:(NSNumber *)a_weight
                address:(NSString *)a_address
                  house:(House *)a_house
              oldHouses:(NSArray *)a_oldHouses
{
    self = [super initWithFirstName:a_firstName
                           lastName:a_lastName
                             height:a_height
                             weight:a_weight
                            address:a_address
                              house:a_house];
    if(self)
    {
        _oldHouses = [a_oldHouses copy];
    }
    return self;
}

- (void)dealloc
{
    [_oldHouses release];
    [super dealloc];
}

- (Class)getSubClassObjectWithPropertyName:(NSString *)propertyName
{
    Class subClass = nil;
    if([propertyName isEqualToString:@"oldHouses"])
    {
        subClass = [House class];
    }
    
    return subClass;
}

@end
