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
    
    self.title = @"Combined Chart";
    
    _chartView.descriptionText = @"";
    
    _chartView.delegate = self;
    
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
    
    _chartView.rightAxis.enabled = NO;
    [_chartView setVisibleXRangeMaximum:20.0];
    
    _chartView.legend.form = ChartLegendFormLine;
    
    
    _dispatcher = [WebSocketRailsDispatcher.alloc initWithUrl:[NSURL URLWithString:@"ws://52.10.212.95:3333/websocket"]];
    [_dispatcher bind:@"connection_opened" callback:^(id data) {
        NSLog(@"Connected");
    }];
    [_dispatcher connect];
    
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
    
    for (int index = 0; index <= 30; index++)
    {
        [months addObject:[NSString stringWithFormat:@"%d",index]];
    }
    
    CombinedChartData *data = [[CombinedChartData alloc] initWithXVals:months];
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:[self generateLineData:pressures]];
    [dataSets addObject:[self generateBarData:motions]];
    
   // CombinedChartData *data = [[CombinedChartData alloc] initWithXVals:months dataSets:dataSets];
    
    data.lineData = [self generateLineData:pressures];
    data.barData = [self generateBarData:motions];
    
    _chartView.data = data;
    [_chartView setBorderColor:[UIColor blackColor]];
    //_chartView.borderColor = [UIColor orangeColor];
    _chartView.borderLineWidth=1.0f;
    [_chartView setVisibleXRangeMaximum:20.0];
    self.label_maxPressure.text=@"5";
    self.label_avgPressure.text=@"3";
    
    [_chartView notifyDataSetChanged];
    
    
   
    
    //[_chartView animateWithXAxisDuration:3 easingOption:ChartEasingOptionEaseInCubic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (LineChartData *)generateLineData:(NSArray *)pressures
{
    LineChartData *d = [[LineChartData alloc] init];
    
    NSInteger min = 0;
    
    // Start Line 1
    
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    NSMutableArray *yvalues2= [[NSMutableArray alloc] init];
    NSMutableArray *minutes2= [[NSMutableArray alloc] init];
    
   
    for (int i = 0; i <[pressures count]; i++)
    {
        Pressure *pressure = [pressures objectAtIndex:i];
        NSInteger val = [pressure.channel_2 intValue];
        
        //NSInteger seconds = [pressure.sec intValue];
        min = [pressure.min intValue];
        [yvalues2 addObject:[NSString stringWithFormat:@"%ld",val]];
        [minutes2 addObject:[NSString stringWithFormat:@"%ld",min]];
    }
    
    
    for (int i = 0; i <= 30; i++)
    {
        for (int j=0;j<[pressures count]; j++){
            
            if(i == [minutes2[j] intValue]){
                [entries addObject:[[ChartDataEntry alloc] initWithValue:[yvalues2[j] intValue] xIndex:i]];
            }
        }
    }
    
    LineChartDataSet *set = [[LineChartDataSet alloc] initWithYVals:entries label:@"Abdominal Pressure"];
    [set setColor:UIColor.whiteColor];
    set.lineWidth = 1.5;
    [set setCircleColor:UIColor.whiteColor];
    set.drawValuesEnabled = NO;
    set.valueFont = [UIFont systemFontOfSize:10.f];
    set.circleRadius = 3.0;
    set.highlightColor = UIColor.whiteColor;
    set.drawCircleHoleEnabled = YES;
    set.valueTextColor = [UIColor colorWithRed:240/255.f green:238/255.f blue:70/255.f alpha:1.f];
    
    set.axisDependency = AxisDependencyLeft;
    
    //Start Line 2
    
    NSMutableArray *secondentries = [[NSMutableArray alloc] init];
    NSMutableArray *secondyvalues2= [[NSMutableArray alloc] init];
    NSMutableArray *secondminutes2= [[NSMutableArray alloc] init];
    
    for (int i = 0; i <[pressures count]; i++)
    {
        Pressure *pressure = [pressures objectAtIndex:i];
        NSInteger val = [pressure.channel_2 intValue];
        
       // NSInteger seconds = [pressure.sec intValue];
        min = [pressure.min intValue];
        [secondyvalues2 addObject:[NSString stringWithFormat:@"%ld",val]];
        [secondminutes2 addObject:[NSString stringWithFormat:@"%ld",min]];
    }
    
    for (int i = 0; i <= 30; i++)
    {
        for (int j=0;j<[pressures count]; j++){
            
            if(i == [secondminutes2[j] intValue]){
                [secondentries addObject:[[ChartDataEntry alloc] initWithValue:[secondyvalues2[j] intValue] xIndex:i]];
                
            }
        }
    }
    
    LineChartDataSet *set2 = [[LineChartDataSet alloc] initWithYVals:secondentries label:@"Body Pressure"];
    [set2 setColor:[UIColor colorWithRed:51/255.f green:90/255.f blue:150/255.f alpha:0.5f]];
    set2.lineWidth = 1.5;
    [set2 setCircleColor:[UIColor colorWithRed:51/255.f green:90/255.f blue:150/255.f alpha:0.5f]];
    set2.fillColor = UIColor.whiteColor;
    set2.drawCircleHoleEnabled =YES;
    set2.drawCubicEnabled = NO;
    set2.drawValuesEnabled = NO;
    set2.valueFont = [UIFont systemFontOfSize:10.f];
    set2.circleRadius = 2.0;
    set2.valueTextColor = [UIColor colorWithRed:240/255.f green:238/255.f blue:70/255.f alpha:1.f];
    
    set2.axisDependency = AxisDependencyLeft;
    
    
    [d addDataSet:set];
    //[d addDataSet:set2];
    
    return d;
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
    [set setColor:UIColor.orangeColor];
    set.drawValuesEnabled  = NO;
    set.barSpace = 0.5;
    set.barShadowColor = UIColor.clearColor;
    
    set.axisDependency = AxisDependencyLeft;
    
    [d addDataSet:set];
    
    return d;
}

-(void) loadSessions {
    
    NSMutableDictionary *sessionParam = [[NSMutableDictionary alloc]init];
    [sessionParam setObject:@"E727B27E-F7D8-4135-A93A-CDE6AE09286E-821-000002895A92A69F" forKey:@"session_id"];
    
    //[sessionParam setObject:@"303DFA39-0715-43F1-B557-52BEE7A9F1F5-3637-0000088BCC3FFE58" forKey:@"session_id"];
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
