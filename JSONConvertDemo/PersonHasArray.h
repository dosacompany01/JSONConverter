//
//  PersonHasArray.h
//  JSONConvertDemo
//
//  Created by LeeChooHyoung on 2014. 6. 10..
//  Copyright (c) 2014년 privateCompany. All rights reserved.
//

#import "Person.h"

@interface PersonHasArray : Person
{
    
}

@property (nonatomic, retain) NSArray *oldHouses;

- (id)initWithFirstName:(NSString *)firstName
               lastName:(NSString *)lastName
                 height:(NSNumber *)height
                 weight:(NSNumber *)weight
                address:(NSString *)address
                  house:(House *)house
              oldHouses:(NSArray *)oldHouses;

@end
