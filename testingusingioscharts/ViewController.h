//
//  ViewController.h
//  testingusingioscharts
//
//  Created by AyeChan PyaeSone on 20/6/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Charts/Charts.h>
#import "testingusingioscharts-swift.h"

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet LineChartView *linechart2;

@property (weak, nonatomic) IBOutlet LineChartView *linechart;
- (IBAction)changevalue:(id)sender;

@end

