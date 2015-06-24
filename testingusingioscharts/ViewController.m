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
    [self loadlineChart2];
    
}
-(void) loadlineChart2{

    _linechart2.delegate = self;
    
    _linechart2.descriptionText = @"";
    _linechart2.noDataTextDescription = @"You need to provide data for the chart.";
    
    _linechart2.highlightEnabled = NO;
    _linechart2.scaleXEnabled = YES;
    _linechart2.scaleYEnabled = NO;
    _linechart2.drawGridBackgroundEnabled = NO;
    
    
    
    ChartXAxis *xAxis = _linechart2.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:8.f];
    xAxis.drawGridLinesEnabled = YES;
    xAxis.spaceBetweenLabels = 1.0;
    
    
    ChartYAxis *leftAxis = _linechart2.leftAxis;
    [leftAxis removeAllLimitLines];
    leftAxis.customAxisMax = 5;
    leftAxis.customAxisMin = 0;
    leftAxis.labelCount = 5;
    leftAxis.startAtZeroEnabled = NO;
    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    leftAxis.spaceTop = 3.25;
    
    _linechart2.rightAxis.enabled = NO;
    
    BalloonMarker *marker = [[BalloonMarker alloc] initWithColor:[UIColor colorWithWhite:180/255. alpha:1.0] font:[UIFont systemFontOfSize:12.0] insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
    marker.minimumSize = CGSizeMake(80.f, 40.f);
    _linechart2.marker = marker;
    
    _linechart2.legend.form = ChartLegendFormLine;
    
    
    [_linechart2 animateWithXAxisDuration:2.5 easingOption:ChartEasingOptionEaseInOutQuart];
    
    [self setDataCountlinechart2:(7) range:5];
}

-(void) loadlineChart1{
    _linechart.delegate = self;
    
    _linechart.descriptionText = @"";
    _linechart.noDataTextDescription = @"You need to provide data for the chart.";
    
    _linechart.highlightEnabled = NO;
    _linechart.scaleXEnabled = YES;
    _linechart.scaleYEnabled = NO;
    _linechart.drawGridBackgroundEnabled = NO;
   

    ChartXAxis *xAxis = _linechart.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:8.f];
    xAxis.drawGridLinesEnabled = YES;
    xAxis.spaceBetweenLabels = 1.0;
    
    
    ChartYAxis *leftAxis = _linechart.leftAxis;
    [leftAxis removeAllLimitLines];
    leftAxis.customAxisMax = 5;
    leftAxis.customAxisMin = 0;
    leftAxis.labelCount = 5;
    leftAxis.startAtZeroEnabled = NO;
    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    leftAxis.spaceTop = 3.25;
    
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
       NSString *abc = [NSString stringWithFormat:@"%d", i*10];

       [xVals addObject: abc];
    
     }
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i <count; i++)
    {
        // double mult = (range + 1);
        // double val = (double) (arc4random_uniform(mult));
        double val =i;
        if(i == 6){
            val = 3.5;
        }
        if(i==0){
            val=0;
        }
       [yVals addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
    }
    
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@"DataSet 1"];
    
    set1.lineDashLengths = @[@5.f, @2.5f];
    [set1 setColor:UIColor.blackColor];
    [set1 setCircleColor:UIColor.greenColor];
    set1.lineWidth = 1.0;
    set1.circleRadius = 3.0;
    set1.drawCircleHoleEnabled = YES;
    set1.valueFont = [UIFont systemFontOfSize:9.f];
    set1.fillAlpha = 65/255.0;
    set1.fillColor = UIColor.blackColor;
    set1.drawValuesEnabled = FALSE;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
    
    _linechart.data = data;
}

- (void)setDataCountlinechart2:(int)count range:(double)range
{
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    
    //for (int i = 0; i < count; i++)
    //{
    //   NSString *abc = [NSString stringWithFormat:@"%d", i];
    //Adding X Values
    
    // @[@"5 min",@"10 min",@"15 min",@"20 min",@"25 min",@"30 min"]];
    [xVals addObject: @"3 min"];
    [xVals addObject: @"8 min"];
    [xVals addObject: @"15 min"];
    [xVals addObject: @"18 min"];
    [xVals addObject: @"24 min"];
    [xVals addObject: @"28 min"];
    [xVals addObject: @"30 min"];
    
    // }
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i <count; i++)
    {
        // double mult = (range + 1);
        // double val = (double) (arc4random_uniform(mult));
        double val =i;
        if(i == 6){
            val = 3.5;
        }
        if(i==0){
            val=4.8;
        }
        [yVals addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
    }
    
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@"DataSet 1"];
    
    set1.lineDashLengths = @[@5.f, @2.5f];
    [set1 setColor:UIColor.blackColor];
    [set1 setCircleColor:UIColor.greenColor];
    set1.lineWidth = 1.0;
    set1.circleRadius = 3.0;
    set1.drawCircleHoleEnabled = YES;
    set1.valueFont = [UIFont systemFontOfSize:9.f];
    set1.fillAlpha = 65/255.0;
    set1.fillColor = UIColor.blackColor;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
    
    _linechart2.data = data;
}


- (IBAction)changevalue:(id)sender {
    [_dispatcher bind:@"send_session" callback:^(id data) {
        NSLog(@"send_session: %@", data);
    }];
}
@end
