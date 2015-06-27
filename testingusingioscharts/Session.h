//
//  Session.h
//  testingusingioscharts
//
//  Created by AyeChan PyaeSone on 24/6/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Motion.h"
#import "Pressure.h"
               
@interface Session : NSObject

@property (nonatomic, strong) NSArray *motions;
@property (nonatomic, strong) NSArray *pressure_sets;

@end
