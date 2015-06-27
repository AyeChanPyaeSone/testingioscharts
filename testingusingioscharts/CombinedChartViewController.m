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

@property (nonatomic, strong) IBOutlet CombinedChartView *chartView;
@property (nonatomic, strong) WebSocketRailsDispatcher *dispatcher;

@end

@implementation CombinedChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Combined Chart";
    
    _chartView.delegate = self;
    
    _chartView.descriptionText = @"";
    _chartView.noDataTextDescription = @"You need to provide data for the chart.";
    
    
    _chartView.highlightEnabled = YES;
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:NO];
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
    
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    [leftAxis removeAllLimitLines];
    leftAxis.customAxisMax = 5;
    leftAxis.customAxisMin = 0;
    leftAxis.labelCount = 5;
    leftAxis.labelTextColor = UIColor.whiteColor;
    leftAxis.gridColor = UIColor.whiteColor;
    leftAxis.startAtZeroEnabled = NO;
    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    leftAxis.drawLimitLinesBehindDataEnabled = NO;
    leftAxis.spaceTop = 3.4;
    
    _chartView.rightAxis.enabled = NO;
    [_chartView setVisibleXRangeMaximum:20.0];
    
    _chartView.legend.form = ChartLegendFormLine;
    
    
    _dispatcher = [WebSocketRailsDispatcher.alloc initWithUrl:[NSURL URLWithString:@"ws://52.10.212.95:3333/websocket"]];
    [_dispatcher bind:@"connection_opened" callback:^(id data) {
        NSLog(@"Connected");
    }];
    [_dispatcher connect];
   
}

-(void) LoadChartView:(NSArray *)sessions{
    
    NSLog(@"Load Chart View Sessions %@",sessions);
    NSMutableArray *months =[[NSMutableArray alloc] init];
    
    for (int index = 0; index <= 30; index++)
    {
        [months addObject:[NSString stringWithFormat:@"%d",index]];
    }
    
    CombinedChartData *data = [[CombinedChartData alloc] initWithXVals:months];
    data.lineData = [self generateLineData:sessions];
    data.barData = [self generateBarData:sessions];
    
    _chartView.data = data;
    [_chartView setVisibleXRangeMaximum:20.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (LineChartData *)generateLineData:(NSArray *)sessions
{
    LineChartData *d = [[LineChartData alloc] init];
    
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    
    NSMutableArray *yvalues2= [[NSMutableArray alloc] init];
    NSMutableArray *minutes2= [[NSMutableArray alloc] init];
    NSInteger min = 0;
    
    for (int i = 0; i <[sessions count]; i++)
    {
//        Session *session = [sessions objectAtIndex:i];
//        NSInteger val = [session.channel_2 intValue];
//        
//        NSInteger seconds = [session.sec intValue];
//        if(seconds>1800){
//            seconds = 1700;
//        }
//        min = seconds/60;
//        [yvalues2 addObject:[NSString stringWithFormat:@"%ld",val]];
//        [minutes2 addObject:[NSString stringWithFormat:@"%ld",min]];
    }
    
    for (int i = 0; i <= 30; i++)
    {
        for (int j=0;j<10; j++){
            
            if(i == [minutes2[j] intValue]){
                NSLog(@"I %d Minutes %d",i,[minutes2[j] intValue]);
                [entries addObject:[[ChartDataEntry alloc] initWithValue:[yvalues2[j] intValue] xIndex:i]];
            }
            else{
                NSLog(@"Not %d",i);
            }
            
        }
    }
    
    NSLog(@"Line");
    
    LineChartDataSet *set = [[LineChartDataSet alloc] initWithYVals:entries label:@"Line DataSet"];
    [set setColor:[UIColor colorWithRed:240/255.f green:238/255.f blue:70/255.f alpha:1.f]];
    set.lineWidth = 2.5;
    [set setCircleColor:[UIColor colorWithRed:240/255.f green:238/255.f blue:70/255.f alpha:1.f]];
    set.fillColor = [UIColor colorWithRed:240/255.f green:238/255.f blue:70/255.f alpha:1.f];
    set.drawCubicEnabled = NO;
    set.drawValuesEnabled = NO;
    set.valueFont = [UIFont systemFontOfSize:10.f];
    set.circleRadius = 3.0;
    set.valueTextColor = [UIColor colorWithRed:240/255.f green:238/255.f blue:70/255.f alpha:1.f];
    
    set.axisDependency = AxisDependencyLeft;
    
    [d addDataSet:set];
    
    return d;
}

- (BarChartData *)generateBarData:(NSArray *)sessions
{
    BarChartData *d = [[BarChartData alloc] init];
    
    NSMutableArray *entries = [[NSMutableArray alloc] init];
//    for (int index = 0; index < ITEM_COUNT; index++)
//    {
//        [entries addObject:[[BarChartDataEntry alloc] initWithValue:3 xIndex:index]];
//    }
    
    
    NSMutableArray *yvalues2= [[NSMutableArray alloc] init];
    NSMutableArray *minutes2= [[NSMutableArray alloc] init];
    NSInteger min = 0;
    
    for (int i = 0; i <[sessions count]; i++)
    {
//        Session *session = [sessions objectAtIndex:i];
//        NSInteger val = [session.channel_1 intValue];
//        
//        NSInteger seconds = [session.sec intValue];
//        if(seconds>1800){
//            seconds = 1700;
//        }
//        min = seconds/60;
//        [yvalues2 addObject:[NSString stringWithFormat:@"%ld",val]];
//        [minutes2 addObject:[NSString stringWithFormat:@"%ld",min]];
    }

    for (int i = 0; i < ITEM_COUNT; i++)
    {
        for (int j=0;j<10; j++){
            
            if(i == [minutes2[j] intValue]){
                NSLog(@"I %d Minutes %d",i,[minutes2[j] intValue]);
                [entries addObject:[[BarChartDataEntry alloc] initWithValue:[yvalues2[j] intValue] xIndex:i]];
            }
            else{
                NSLog(@"Not %d",i);
            }
            
        }
    }

    
    NSLog(@"Entries");
    BarChartDataSet *set = [[BarChartDataSet alloc] initWithYVals:entries label:@"Bar DataSet"];
    [set setColor:UIColor.orangeColor];
    set.drawValuesEnabled  = NO;
    set.barSpace = 0.5;
    set.barShadowColor = UIColor.clearColor;
    
    set.axisDependency = AxisDependencyLeft;
    
    NSLog(@"Char");
    
    [d addDataSet:set];
    
    return d;
}

-(void) loadSessions {
    
    NSMutableDictionary *sessionParam = [[NSMutableDictionary alloc]init];
    [sessionParam setObject:@"E727B27E-F7D8-4135-A93A-CDE6AE09286E-821-000002895A92A69F" forKey:@"session_id"];
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
    
//    [_dispatcher trigger:@"send_session" data:[self eventDataWithString:jsonString] success:^(id data) {
//        NSLog(@"Success event: %@", data);
//    } failure:^(id data) {
//        NSLog(@"Fail event: %@", data);
//    }];
//   
//    [_dispatcher bind:@"send_session" callback:^(id data) {
//        NSLog(@"send_session %@", data);
//        
//        NSData* jsondata = [data dataUsingEncoding:NSUTF8StringEncoding];
//        NSArray *values = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"Arrays %@",values);
    
       // NSArray* sessions =[RMMapper arrayOfClass:[Session class] fromArrayOfDictionary:values];
        
      //  NSLog(@"sessions %@", sessions);
        //[self LoadChartView:(NSArray *)sessions];
    
    
    [_dispatcher trigger:@"send_session" data:[self eventDataWithString:jsonString] success:^(id data) {
                NSLog(@"Success event: %@", data);
            } failure:^(id data) {
                NSLog(@"Fail event: %@", data);
            }];
        
    [_dispatcher bind:@"send_session" callback:^(id data) {
        
         NSLog(@"send_session %@", data);
                NSData* jsondata = [data dataUsingEncoding:NSUTF8StringEncoding];
                NSArray *values = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:nil];
        
         NSLog(@"send_session Values %@", values);
        
        Session *session =[RMMapper objectWithClass:[Session class] fromDictionary:values];
        
        
        NSLog(@"Session %@",session.pressure_sets);
        NSLog(@"Session %@",session.motions);
        
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
