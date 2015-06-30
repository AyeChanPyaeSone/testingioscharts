//
//  CombinedChartViewController.h
//  testingusingioscharts
//
//  Created by AyeChan PyaeSone on 26/6/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Charts/Charts.h>
#import "RMMapper.h"
#import "Session.h"
#import "Pressure.h"
#import "Motion.h"

@interface CombinedChartViewController : UIViewController
- (IBAction)pressedLoadChartView:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *userIdTextField;
@property (strong, nonatomic) IBOutlet UIPickerView *sessionIdPicker;
- (IBAction)loadSession:(id)sender;

@end
