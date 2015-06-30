//
//  CombinedChartViewController.m
//  testingusingioscharts
//
//  Created by AyeChan PyaeSone on 26/6/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "CombinedChartViewController.h"
#import "testingusingioscharts-swift.h"
#import "WebSocketRailsDispatcher.h"
#import "WebSocketRailsChannel.h"

#define ITEM_COUNT 30

@interface CombinedChartViewController () <ChartViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label_todayDate;
@property (weak, nonatomic) IBOutlet UILabel *label_maxPressure;
@property (weak, nonatomic) IBOutlet UILabel *label_avgPressure;

@property (weak, nonatomic) IBOutlet UIView *gradientview;

@property (nonatomic, strong) IBOutlet CombinedChartView *chartView;
@property (nonatomic, strong) WebSocketRailsDispatcher *dispatcher;

@end

@implementation CombinedChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    self.title = @"Combined Chart";
    
    _chartView.descriptionText = @"";
    
    _chartView.delegate = self;
    
    _chartView.highlightEnabled = YES;
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.drawGridBackgroundEnabled = NO;
    _chartView.pinchZoomEnabled = NO;
    [_chartView setScaleYEnabled:NO];
    
    _chartView.drawOrder = @[
                             @(CombinedChartDrawOrderBar),
                             @(CombinedChartDrawOrderLine)
                             ];

    
    _chartView.legend.form = ChartLegendFormLine;
    _chartView.legend.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
    _chartView.legend.textColor = UIColor.whiteColor;
    _chartView.legend.position = ChartLegendPositionBelowChartLeft;
    
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:10.f];
    xAxis.labelTextColor = UIColor.whiteColor;
    xAxis.drawGridLinesEnabled = NO;
    xAxis.spaceBetweenLabels = 8.0;
    xAxis.drawLimitLinesBehindDataEnabled = YES;
    
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    [leftAxis removeAllLimitLines];
    leftAxis.customAxisMax = 5;
    leftAxis.customAxisMin = 0;
    leftAxis.labelCount = 5;
    leftAxis.labelTextColor = UIColor.whiteColor;
    leftAxis.gridColor = UIColor.whiteColor;
    leftAxis.startAtZeroEnabled = NO;
    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    
    
    _chartView.rightAxis.enabled = NO;
//    [_chartView setVisibleXRangeMaximum:20.0];
    
    _chartView.legend.form = ChartLegendFormLine;
    
    
    _dispatcher = [WebSocketRailsDispatcher.alloc initWithUrl:[NSURL URLWithString:@"ws://52.10.212.95:3333/websocket"]];
    [_dispatcher bind:@"connection_opened" callback:^(id data) {
        NSLog(@"Connected");
    }];
    [_dispatcher connect];
    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_chartView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0 constant:self.view.bounds.size.width]];
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gradientview attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0 constant:self.view.bounds.size.width]];

    
    [self.view setNeedsDisplay];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.gradientview.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:244/250. green:133/255. blue:48/255. alpha:1.f] CGColor], (id)[[UIColor colorWithRed:255/255. green:36/255. blue:0/255. alpha:0.8f] CGColor],nil];
    gradient.startPoint = CGPointMake(0, 0.5);
    gradient.endPoint = CGPointMake(0, 1);
    [self.gradientview.layer insertSublayer:gradient atIndex:0];
    
    _chartView.backgroundColor = UIColor.clearColor;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateStyle=kCFDateFormatterMediumStyle;
    
    self.label_todayDate.text = [format stringFromDate:[NSDate new]];
   
}

-(void) LoadChartView:(NSArray *)pressures motion:(NSArray *)motions {
    
    NSMutableArray *months =[[NSMutableArray alloc] init];
    
    for (int index = 0; index <= ITEM_COUNT; index++)
    {
        [months addObject:[NSString stringWithFormat:@"%d",index]];
    }
    
    CombinedChartData *data = [[CombinedChartData alloc] initWithXVals:months];
    
    
    data.lineData = [self generateLineData:pressures];
    data.barData = [self generateBarData:motions];
    
    _chartView.data = data;
    
    [_chartView setVisibleXRangeMaximum:20.0];
    self.label_maxPressure.text=@"5";
    self.label_avgPressure.text=@"3";
    
    [_chartView notifyDataSetChanged];
    [_chartView setNeedsDisplay];
    
   
    
    //[_chartView animateWithXAxisDuration:3 easingOption:ChartEasingOptionEaseInCubic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (LineChartData *)generateLineData:(NSArray *)pressures
{
    LineChartData *lineChatData = [[LineChartData alloc] init];
    
    NSInteger min = 0;
    
    // Start Line 1
    
    NSMutableArray *yValues= [[NSMutableArray alloc] init];
    NSMutableArray *minutes= [[NSMutableArray alloc] init];
    NSMutableArray *entries = [[NSMutableArray alloc] init];

    
   
    for (int i = 0; i <[pressures count]; i++)
    {
        Pressure *pressure = [pressures objectAtIndex:i];
        NSInteger val = [pressure.channel_2 intValue];
        
        //NSInteger seconds = [pressure.sec intValue];
        min = [pressure.min intValue];
        [yValues addObject:[NSString stringWithFormat:@"%ld",val]];
        [minutes addObject:[NSString stringWithFormat:@"%ld",min]];
    }
    
    
    for (int i = 0; i <= ITEM_COUNT; i++)
    {
        for (int j=0;j<[pressures count]; j++){
            if(i == [minutes[j] intValue]){
                [entries addObject:[[ChartDataEntry alloc] initWithValue:[yValues[j] intValue] xIndex:i]];
                break;
            }
        }
    }
    

    
    LineChartDataSet *channelOneLineChatDataSet = [[LineChartDataSet alloc] initWithYVals:entries label:@"Abdominal Pressure"];
    [channelOneLineChatDataSet setColor:UIColor.whiteColor];
    channelOneLineChatDataSet.lineWidth = 4
    ;
    [channelOneLineChatDataSet setCircleColor:UIColor.whiteColor];
    channelOneLineChatDataSet.drawValuesEnabled = NO;
    channelOneLineChatDataSet.valueFont = [UIFont systemFontOfSize:10.f];
    channelOneLineChatDataSet.circleRadius = 2.0;
    channelOneLineChatDataSet.drawCubicEnabled = YES;
    channelOneLineChatDataSet.highlightColor = UIColor.whiteColor;
    channelOneLineChatDataSet.drawCircleHoleEnabled = YES;
    channelOneLineChatDataSet.valueTextColor = [UIColor colorWithRed:240/255.f green:238/255.f blue:70/255.f alpha:0.8f];
    
    channelOneLineChatDataSet.axisDependency = AxisDependencyLeft;
    
//    //Start Line 2
//    
        NSMutableArray *secondEntries = [[NSMutableArray alloc] init];
        NSMutableArray *secondyValues= [[NSMutableArray alloc] init];
        NSMutableArray *secondMinutes= [[NSMutableArray alloc] init];
//    
    for (int i = 0; i <[pressures count]; i++)
    {
        Pressure *pressure = [pressures objectAtIndex:i];
        NSInteger val = [pressure.channel_2 intValue];
        
       // NSInteger seconds = [pressure.sec intValue];
        min = [pressure.min intValue];
        [secondyValues addObject:[NSString stringWithFormat:@"%ld",val]];
        [secondMinutes addObject:[NSString stringWithFormat:@"%ld",min]];
    }
    

    for (int index = 0; index <= ITEM_COUNT; index++)
    {
        for (int j=0;j<[pressures count]; j++){
            if(index == [secondMinutes[j] intValue]){
                [secondEntries addObject:[[ChartDataEntry alloc] initWithValue:[secondyValues[j] intValue] xIndex:index]];
            }
        }
    }
//
    LineChartDataSet *channelTwoLineChatDataSet = [[LineChartDataSet alloc] initWithYVals:secondEntries label:@"Body Pressure"];
    [channelTwoLineChatDataSet setColor:[UIColor colorWithRed:74/255.f green:249/255.f blue:229/255.f alpha:0.8f]];
    channelTwoLineChatDataSet.lineWidth = 2;
    [channelTwoLineChatDataSet setCircleColor:[UIColor colorWithRed:51/255.f green:90/255.f blue:150/255.f alpha:0.5f]];
    channelTwoLineChatDataSet.fillColor = UIColor.whiteColor;
    channelTwoLineChatDataSet.drawCircleHoleEnabled =YES;
    channelTwoLineChatDataSet.drawCubicEnabled = NO;
    channelTwoLineChatDataSet.drawValuesEnabled = NO;
    channelTwoLineChatDataSet.valueFont = [UIFont systemFontOfSize:10.f];
    channelTwoLineChatDataSet.circleRadius = 2.0;
    channelTwoLineChatDataSet.valueTextColor = [UIColor colorWithRed:240/255.f green:238/255.f blue:70/255.f alpha:1.f];
    
    channelTwoLineChatDataSet.axisDependency = AxisDependencyLeft;
    
    
    [lineChatData addDataSet:channelOneLineChatDataSet];
   [lineChatData addDataSet:channelTwoLineChatDataSet];
    
    return lineChatData;
}

- (BarChartData *)generateBarData:(NSArray *)motions
{
    BarChartData *d = [[BarChartData alloc] init];
    
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    NSMutableArray *yvalues2= [[NSMutableArray alloc] init];
    NSMutableArray *minutes2= [[NSMutableArray alloc] init];
    NSInteger min = 0;
    
    for (int i = 0; i <[motions count]; i++)
    {
        Motion *motion = [motions objectAtIndex:i];
        NSInteger val = [motion.avg_motion intValue];
        
        NSInteger seconds = [motion.min intValue];
        min = seconds/60000;
        [yvalues2 addObject:[NSString stringWithFormat:@"%ld",val]];
        [minutes2 addObject:[NSString stringWithFormat:@"%ld",min]];
    }

    for (int i = 0; i < ITEM_COUNT; i++)
    {
        for (int j=0;j<[motions count]; j++){
            
            
            if(i == [minutes2[j] intValue]){
                NSLog(@"I %d Bar Minutes %d",i,[minutes2[j] intValue]);
                [entries addObject:[[BarChartDataEntry alloc] initWithValue:[yvalues2[j] intValue] xIndex:i]];
                
                //[entries addObject:[[BarChartDataEntry alloc] initWithValue:4 xIndex:i]];
            }
        }
    }

    BarChartDataSet *set = [[BarChartDataSet alloc] initWithYVals:entries label:@"Motion"];
    [set setColor:[UIColor colorWithRed:229/255.f green:221/255.f blue:9/255.f alpha:1.f]];
    set.drawValuesEnabled  = NO;
    set.barSpace = 0.5;
    set.barShadowColor = UIColor.clearColor;
    
    set.axisDependency = AxisDependencyLeft;
    
    [d addDataSet:set];
    
    return d;
}

-(void) loadSessions {
    
    NSMutableDictionary *sessionParam = [[NSMutableDictionary alloc]init];
    //[sessionParam setObject:@"E727B27E-F7D8-4135-A93A-CDE6AE09286E-821-000002895A92A69F" forKey:@"session_id"];
    
    [sessionParam setObject:@"CE1B25CF-FA5C-4962-84DC-DC5A5D8A3D0B-3637-000008991FA1B7DD" forKey:@"session_id"];
    [sessionParam setObject:@"kyawmyintthein2020@gmail.com" forKey:@"user_id"];
    
    NSError *error;
    NSString *jsonString ;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:sessionParam
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"JSON DATA %@",jsonString);
    }
    
    [_dispatcher trigger:@"send_session" data:[self eventDataWithString:jsonString] success:^(id data) {
        
        NSLog(@"Success event: %@", data);
    } failure:^(id data) {
        NSLog(@"Fail event: %@", data);
    }];
        
    [_dispatcher bind:@"send_session" callback:^(id data) {
        
        NSData* jsondata = [data dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *values = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:nil];
        
        Session *session =[RMMapper objectWithClass:[Session class] fromDictionary:values];
        NSLog(@"Success event: %@", values);
        
        // Pressure Sets
        NSArray *pressurearray = [[NSArray alloc] init];
        NSArray *rmMapperpressurearray = [[NSArray alloc] init];
        
        pressurearray = [session.pressure_sets objectForKey:@"pressure_set"];
        rmMapperpressurearray = [RMMapper arrayOfClass:[Pressure class] fromArrayOfDictionary:pressurearray];
        
        
        // Motions Sets
        NSArray *motionsarray = [[NSArray alloc] init];
        NSArray *rmMappermotionsarray = [[NSArray alloc] init];
        
        motionsarray = [session.motions objectForKey:@"motion"];
        rmMappermotionsarray = [RMMapper arrayOfClass:[Motion class] fromArrayOfDictionary:motionsarray];
        
        [self LoadChartView:rmMapperpressurearray motion:rmMappermotionsarray];
        
        
    }];
    
   
}

- (id)eventDataWithString:(NSString *)string
{
    return @{@"data": string};
}

- (IBAction)pressedLoadChartView:(id)sender {
    [self loadSessions];

}
@end
