//
//  Session.h
//  testingusingioscharts
//
//  Created by AyeChan PyaeSone on 24/6/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <Foundation/Foundation.h>
               
@interface Session : NSObject

@property (nonatomic, assign) int *id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, assign) int *session_id;
@property (nonatomic, assign) int *channel_1;
@property (nonatomic, assign) int *channel_2;
@property (nonatomic, assign) int *sec;
@end
