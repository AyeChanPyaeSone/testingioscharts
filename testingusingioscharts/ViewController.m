//
//  ViewController.m
//  testingusingioscharts
//
//  Created by AyeChan PyaeSone on 20/6/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "ViewController.h"
#import "WebSocketRailsDispatcher.h"
#import "WebSocketRailsChannel.h"

@interface ViewController ()
@property (nonatomic, strong) WebSocketRailsDispatcher *dispatcher;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dispatcher = [WebSocketRailsDispatcher.alloc initWithUrl:[NSURL URLWithString:@"ws://52.10.212.95:3333/websocket"]];
    [_dispatcher bind:@"connection_opened" callback:^(id data) {
        NSLog(@"Connected");
    }];
    [_dispatcher connect];
    
    [self loadlineChart1];
    
}

-(void) loadlineChart1{
    
    _linechart.delegate = self;
    
    _linechart.descriptionText = @"";
    _linechart.noDataTextDescription = @"You need to provide data for the chart.";

    
    _linechart.highlightEnabled = YES;
    _linechart.dragEnabled = YES;
    [_linechart setScaleEnabled:YES];
    _linechart.drawGridBackgroundEnabled = NO;
    _linechart.pinchZoomEnabled = NO;
    [_linechart setScaleYEnabled:NO];
    
    _linechart.legend.form = ChartLegendFormLine;
    _linechart.legend.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
    _linechart.legend.textColor = UIColor.whiteColor;
    _linechart.legend.position = ChartLegendPositionBelowChartLeft;
    

    ChartXAxis *xAxis = _linechart.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:10.f];
    xAxis.labelTextColor = UIColor.whiteColor;
    xAxis.drawGridLinesEnabled = NO;
    xAxis.spaceBetweenLabels = 8.0;
    
    
    ChartYAxis *leftAxis = _linechart.leftAxis;
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
    
    _linechart.rightAxis.enabled = NO;
    
    BalloonMarker *marker = [[BalloonMarker alloc] initWithColor:[UIColor colorWithWhite:180/255. alpha:1.0] font:[UIFont systemFontOfSize:12.0] insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
    marker.minimumSize = CGSizeMake(80.f, 40.f);
    _linechart.marker = marker;
    
    _linechart.legend.form = ChartLegendFormLine;
    
    [_linechart animateWithXAxisDuration:2.5 easingOption:ChartEasingOptionEaseInOutQuart];

    [self setDataCountlinechart:(7) range:5];
    
}


- (void)setDataCountlinechart:(int)count range:(double)range
{
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    
    for (int i = 0; i < count; i++)
    {
       NSString *abc = [NSString stringWithFormat:@"%d", i];

       [xVals addObject: abc];
    
     }
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        double val =i;
        if(i == 1){
            val = 2.3;
        }
        else if(i == 2){
            val = 2.8;
        }
        else if(i == 3){
            val = 3.1;
        }
        else if(i == 4 || i ==6){
            val = 0.8;
        }
        else if(i==5 || i ==0){
            val=0;
        }
        [yVals addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
    }
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@"Abdominal Pressure"];
    set1.axisDependency = AxisDependencyLeft;
    [set1 setColor:UIColor.whiteColor];
    [set1 setCircleColor:UIColor.orangeColor];
    set1.lineWidth = 2.0;
    set1.circleRadius = 3.0;
    set1.fillAlpha = 65/255.0;
    set1.fillColor = UIColor.whiteColor;
    set1.highlightColor = UIColor.orangeColor;
    set1.drawCircleHoleEnabled = NO;
    set1.drawFilledEnabled = YES;
    
    NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        double val =i;
        if(i == 1){
            val = 3.3;
        }
        else if(i == 2){
            val = 4.8;
        }
        else if(i == 3){
            val = 5;
        }
        else if(i == 4 || i ==6){
            val = 3.8;
        }
        else if(i==5){
            val=3;
        }
        else if(i==0){
            val=0;
        }
        [yVals2 addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
    }
    
    LineChartDataSet *set2 = [[LineChartDataSet alloc] initWithYVals:yVals2 label:@"Body Pressure"];
    set2.axisDependency = AxisDependencyLeft;
    [set2 setColor:UIColor.orangeColor];
    [set2 setCircleColor:UIColor.whiteColor];
    set2.lineWidth = 2.0;
    set2.circleRadius = 3.0;
    set2.fillAlpha = 65/255.0;
    set2.fillColor = UIColor.redColor;
    set2.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
    set2.drawCircleHoleEnabled = NO;
    set2.drawFilledEnabled = YES;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set2];
    [dataSets addObject:set1];
    
    LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
    [data setValueTextColor:UIColor.whiteColor];
    [data setValueFont:[UIFont systemFontOfSize:9.f]];
    
    _linechart.data = data;
}


- (void)setDataCountlinechart:(int)count range:(double)range sessions:(NSArray*)sessions
{
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    NSInteger min = 0;
    for (int i = 0; i <= 30; i++)
    {
//        Session *session = [sessions objectAtIndex:i];
//        NSInteger seconds = [session.sec intValue];
//        if(seconds>1800){
//            seconds = 1700;
//        }
//        NSLog(@"Minutes %ld",seconds/60);
        NSString *abc = [NSString stringWithFormat:@"%d", i];
        
        [xVals addObject: abc];
    }
    
    NSLog(@"xVals %@",xVals);
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    NSMutableArray *yvalues= [[NSMutableArray alloc] init];
    NSMutableArray *minutes= [[NSMutableArray alloc] init];
    
    for (int i = 0; i <count; i++)
    {
        Session *session = [sessions objectAtIndex:i];
        NSInteger val = [session.channel_1 intValue];
        
        NSInteger seconds = [session.sec intValue];
        if(seconds>1800){
            seconds = 1700;
        }
        min = seconds/60;
        [yvalues addObject:[NSString stringWithFormat:@"%ld",val]];
        [minutes addObject:[NSString stringWithFormat:@"%ld",min]];
    }

    for (int i = 0; i <= 30; i++)
    {
        for (int j=0;j<10; j++){

            if(i == [minutes[j] intValue]){
                NSLog(@"I %d Minutes %d",i,[minutes[j] intValue]);
                [yVals addObject:[[ChartDataEntry alloc] initWithValue:[yvalues[j] intValue] xIndex:i]];
            }
            else{
                 NSLog(@"Not %d",i);
    
            }
            
        }
    }

    NSLog(@"YVALUES %@",yVals);
    
    NSLog(@"Channel 2");
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@"Abdominal Pressure"];
    set1.axisDependency = AxisDependencyLeft;
    [set1 setColor:UIColor.whiteColor];
    [set1 setCircleColor:UIColor.orangeColor];
    set1.lineWidth = 2.0;
    set1.circleRadius = 3.0;
    set1.fillAlpha = 65/255.0;
    set1.fillColor = UIColor.whiteColor;
    set1.highlightColor = UIColor.orangeColor;
    set1.drawCircleHoleEnabled = NO;
    set1.drawFilledEnabled = YES;
    
    NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
    
    NSMutableArray *yvalues2= [[NSMutableArray alloc] init];
    NSMutableArray *minutes2= [[NSMutableArray alloc] init];
    
    for (int i = 0; i <count; i++)
    {
        Session *session = [sessions objectAtIndex:i];
        NSInteger val = [session.channel_2 intValue];
        
        NSInteger seconds = [session.sec intValue];
        if(seconds>1800){
            seconds = 1700;
        }
        min = seconds/60;
        [yvalues2 addObject:[NSString stringWithFormat:@"%ld",val]];
        [minutes2 addObject:[NSString stringWithFormat:@"%ld",min]];
    }
    
    for (int i = 0; i <= 30; i++)
    {
        for (int j=0;j<10; j++){
            
            if(i == [minutes2[j] intValue]){
                NSLog(@"I %d Minutes %d",i,[minutes2[j] intValue]);
                [yVals2 addObject:[[ChartDataEntry alloc] initWithValue:[yvalues2[j] intValue] xIndex:i]];
            }
            else{
                NSLog(@"Not %d",i);
            }
            
        }
    }
    
    
    
    LineChartDataSet *set2 = [[LineChartDataSet alloc] initWithYVals:yVals2 label:@"Body Pressure"];
    set2.axisDependency = AxisDependencyLeft;
    [set2 setColor:UIColor.orangeColor];
    [set2 setCircleColor:UIColor.whiteColor];
    set2.lineWidth = 2.0;
    set2.circleRadius = 3.0;
    set2.fillAlpha = 65/255.0;
    set2.fillColor = UIColor.redColor;
    set2.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
    set2.drawCircleHoleEnabled = NO;
    set2.drawFilledEnabled = YES;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set2];
    [dataSets addObject:set1];
    
    LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
    [data setValueTextColor:UIColor.whiteColor];
    [data setValueFont:[UIFont systemFontOfSize:9.f]];
    
    _linechart.data = data;
}



- (IBAction)changevalue:(id)sender {
    
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
  
    [_dispatcher trigger:@"send_session" data:[self eventDataWithString:jsonString] success:^(id data) {
        NSLog(@"Success event: %@", data);
    } failure:^(id data) {
        NSLog(@"Fail event: %@", data);
    }];
    
    [_dispatcher bind:@"send_session" callback:^(id data) {
        NSLog(@"send_session %@", data);
        
        NSData* jsondata = [data dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *values = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"Arrays %@",values);
        
        NSArray* sessions =[RMMapper arrayOfClass:[Session class] fromArrayOfDictionary:values];
        
        NSLog(@"sessions %@", sessions);
        
        [self setDataCountlinechart:(int)[sessions count] range:5 sessions:sessions];
        [_linechart setNeedsDisplay];
        [_linechart zoomOut];
        [_linechart setVisibleXRangeMaximum:20.0];
        [_linechart notifyDataSetChanged];
        
    }];
}

- (id)eventDataWithString:(NSString *)string
{
    return @{@"data": string};
}

@end
