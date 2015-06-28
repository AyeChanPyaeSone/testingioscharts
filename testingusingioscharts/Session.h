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
#import "RMMapper.h"
               
@interface Session : NSObject<RMMapping>

@property (nonatomic, strong) NSDictionary *motions;
@property (nonatomic, strong) NSDictionary *pressure_sets;

@end
