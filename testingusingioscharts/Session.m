//
//  Session.m
//  testingusingioscharts
//
//  Created by AyeChan PyaeSone on 24/6/15.
//  Copyright (c) 2015 test. All rights reserved.
//


#import "Session.h"

@implementation Session

-(Class)rm_itemClassForArrayProperty:(NSString *)property {
    if ([property isEqualToString:@"motions"]) {
        return [Motion class];
    }
    else if([property isEqualToString:@"pressure_sets"]) {
        return [Pressure class];
    }
    return nil;
}

@end