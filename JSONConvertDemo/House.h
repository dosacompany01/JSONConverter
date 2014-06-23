//
//  House.h
//  JSONLibraryTest
//
//  Created by LeeChooHyoung on 2014. 6. 5..
//  Copyright (c) 2014년 privateCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONConverter.h"

@interface House : JSONConverter <NSCopying>
{
    
}

@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSString *city;

- (id)initWithCountry:(NSString *)country city:(NSString *)city;
@end
