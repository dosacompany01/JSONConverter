//
//  Person.h
//  JSONLibraryTest
//
//  Created by LeeChooHyoung on 2014. 6. 4..
//  Copyright (c) 2014년 privateCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONConverter.h"

@class House;

@interface Person : JSONConverter <NSCopying>
{
    
}
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSNumber *height;
@property (nonatomic, retain) NSNumber *weight;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) House *house;

- (id)initWithFirstName:(NSString *)firstName
               lastName:(NSString *)lastName
                 height:(NSNumber *)height
                 weight:(NSNumber *)weight
                address:(NSString *)address
                  house:(House *)house;
@end
