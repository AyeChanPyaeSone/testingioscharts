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

@interface CombinedChartViewController () <ChartViewDelegate,UIPickerViewDataSource, UIPickerViewDelegate>
- (IBAction)remove:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *label_todayDate;
@property (weak, nonatomic) IBOutlet UILabel *label_maxPressure;
@property (weak, nonatomic) IBOutlet UILabel *label_avgPressure;

@property (weak, nonatomic) IBOutlet UIView *gradientview;

@property (nonatomic, strong) IBOutlet CombinedChartView *chartView;
@property (nonatomic, strong) WebSocketRailsDispatcher *dispatcher;

@end

@implementation CombinedChartViewController
NSMutableArray *sessionsArr;
NSString *session_id;

LineChartDataSet *channelTwoLineChatDataSet;
LineChartDataSet *channelOneLineChatDataSet;
BarChartDataSet *barChartDataset;
CombinedChartData *data;
NSMutableArray *linechartentries;
NSMutableArray *linechartsecondentries;
NSMutableArray *barchartentries;


int datasetindex;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    self.title = @"Tcould";
    
     sessionsArr= [[NSMutableArray alloc]init];
    [sessionsArr addObject:@""];
    [sessionsArr addObject:@"CE5E3AC7-01F2-4DB2-89B7-0D0A95433843-3637-000008A3C37CD283"];
    [sessionsArr addObject:@"CE1B25CF-FA5C-4962-84DC-DC5A5D8A3D0B-3637-000008991FA1B7DD"];
    [sessionsArr addObject:@"303DFA39-0715-43F1-B557-52BEE7A9F1F5-3637-0000088BCC3FFE58"];
    [sessionsArr addObject:@"A67A0667-DF9C-4D0C-99BC-A263593B779B-2633-000005AFECE0E107"];
    [sessionsArr addObject:@"F750DF11-997B-4F9F-80DD-D246EDA51013-889-000002A18FECC964"];
    [sessionsArr addObject:@"FA454011-0234-4A48-A403-90243A5BBADF-889-000002A1855DAFB5"];
    
    self.sessionIdPicker.dataSource = self;
    self.sessionIdPicker.delegate = self;
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
    //gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:244/250. green:133/255. blue:48/255. alpha:1.f] CGColor], (id)[[UIColor colorWithRed:255/255. green:36/255. blue:0/255. alpha:0.8f] CGColor],nil];
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:244/250. green:133/255. blue:48/255. alpha:1.f] CGColor], (id)[[UIColor colorWithRed:251/255. green:181/255. blue:20/255. alpha:0.7f] CGColor],nil];
    gradient.startPoint = CGPointMake(0, 0.5);
    gradient.endPoint = CGPointMake(0, 1);
    [self.gradientview.layer insertSublayer:gradient atIndex:0];
    
    _chartView.backgroundColor = UIColor.clearColor;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateStyle=kCFDateFormatterMediumStyle;
    self.userIdTextField.text = @"kyawmyintthein2020@gmail.com";
//    self.sessionIdPicker.text = @"9EC287E3-E59C-4733-9401-14F33CF1FFD0-821-0000027AE84E7B63";
    self.label_todayDate.text = [format stringFromDate:[NSDate new]];
   
}

-(void) LoadChartView:(NSArray *)pressures motion:(NSArray *)motions {
    
    NSMutableArray *months =[[NSMutableArray alloc] init];
    
    for (int index = 0; index <= ITEM_COUNT; index++)
    {
        [months addObject:[NSString stringWithFormat:@"%d",index]];
    }
    
    data = [[CombinedChartData alloc] initWithXVals:months];
    
    
    data.lineData = [self generateLineData:pressures];
    data.barData = [self generateBarData:motions];
    
    _chartView.data = data;
    
    NSLog(@"Data Sets %@",data.dataSets);
    
    [_chartView setVisibleXRangeMaximum:20.0];
    self.label_maxPressure.text=@"5";
    self.label_avgPressure.text=@"3";
    
    [_chartView notifyDataSetChanged];
    [_chartView setNeedsDisplay];
    
   [_chartView animateWithXAxisDuration:2.0 yAxisDuration:2.0];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) removeData{
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Toggle Data" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Toggle Line Data",
                            @"Toggle Line Body Pressure Data",
                            @"Toggle Bar Chart Data",
                            nil];
    [popup showInView:[UIApplication sharedApplication].keyWindow];
    
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {

    switch (buttonIndex) {
        case 0:
            [self toggleData:0];
            break;
        case 1:
            [self toggleData:1];
            break;
        case 2:
            [self toggleData:2];
            break;
        default:
            break;
    }
}
-(void) toggleData:(int) index{

    
    if(index ==0){
        datasetindex=(int)[data indexOfDataSet:channelOneLineChatDataSet];
        
        if(datasetindex>=0){
            for (int i=0; i<[linechartentries count]; i++) {
                
                [data removeEntryByXIndex:i dataSetIndex:datasetindex];
            }
            [data removeDataSet:channelOneLineChatDataSet];
        }
        else{
            [data addDataSet:channelOneLineChatDataSet];
            for (int i = 0; i < [linechartentries count]; i++)
            {
                ChartDataEntry * linechart= linechartentries[i];
                [data addEntry:linechart dataSetIndex:[data dataSetCount]-1];
            }
        }
    }
    else if(index ==1){
        datasetindex=(int)[data indexOfDataSet:channelTwoLineChatDataSet];
        
        if(datasetindex>=0){
            for (int i=0; i<[linechartsecondentries count]; i++) {
                
                [data removeEntryByXIndex:i dataSetIndex:datasetindex];
            }
            [data removeDataSet:channelTwoLineChatDataSet];
        }
        else{
            [data addDataSet:channelTwoLineChatDataSet];
            for (int i = 0; i < [linechartsecondentries count]; i++)
            {
                ChartDataEntry * linechart= linechartsecondentries[i];
                [data addEntry:linechart dataSetIndex:[data dataSetCount]-1];
            }
        }

    }
    else{
        datasetindex=(int)[data indexOfDataSet:barChartDataset];
        if(datasetindex>=0){
            
            for (int i=0; i<[barchartentries count]; i++) {
                [data removeEntryByXIndex:i dataSetIndex:datasetindex];
            }
            [data removeDataSet:barChartDataset];
        }
        else{
            
            [data addDataSet:barChartDataset];
            for (int i = 0; i < [barchartentries count]; i++)
            {
                ChartDataEntry * barchart= barchartentries[i];
                [data addEntry:barchart dataSetIndex:[data dataSetCount]-1];
            }
        }
    }
    NSLog(@"data %@",[data dataSets]);
    
    _chartView.data = data;
    [_chartView notifyDataSetChanged];
    [_chartView setNeedsDisplay];
    [_chartView setNeedsLayout];
    
    [_chartView animateWithXAxisDuration:3.0 yAxisDuration:3.0];
}
- (LineChartData *)generateLineData:(NSArray *)pressures
{
    LineChartData *lineChatData = [[LineChartData alloc] init];
    
    NSInteger min = 0;
    
    // Start Line 1
    
    NSMutableArray *yValues= [[NSMutableArray alloc] init];
    NSMutableArray *minutes= [[NSMutableArray alloc] init];
    linechartentries = [[NSMutableArray alloc] init];

    for (int i = 0; i <[pressures count]; i++)
    {
        Pressure *pressure = [pressures objectAtIndex:i];
        NSInteger val = [pressure.channel_2 intValue];
        
        //NSInteger seconds = [pressure.sec intValue];
        min = [pressure.min intValue];
        [linechartentries addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
    }
    
    channelOneLineChatDataSet = [[LineChartDataSet alloc] initWithYVals:linechartentries label:@"Abdominal Pressure"];
    [channelOneLineChatDataSet setColor:[UIColor colorWithRed:108/255. green:106/255. blue:203/255. alpha:0.8f]];
    channelOneLineChatDataSet.lineWidth = 8;
    [channelOneLineChatDataSet setCircleColor:UIColor.yellowColor];
    channelOneLineChatDataSet.drawValuesEnabled = NO;
    channelOneLineChatDataSet.valueFont = [UIFont systemFontOfSize:10.f];
    channelOneLineChatDataSet.circleRadius = 2.0;
    channelOneLineChatDataSet.drawCubicEnabled = NO;
    channelOneLineChatDataSet.highlightColor = UIColor.whiteColor;
    channelOneLineChatDataSet.drawCircleHoleEnabled = YES;
    channelOneLineChatDataSet.drawCirclesEnabled = NO;
    channelOneLineChatDataSet.valueTextColor = [UIColor colorWithRed:240/255.f green:238/255.f blue:70/255.f alpha:0.8f];
    
    channelOneLineChatDataSet.axisDependency = AxisDependencyLeft;
    
    //Start Line 2
    
    linechartsecondentries = [[NSMutableArray alloc] init];
    
    for (int i = 0; i <[pressures count]; i++)
    {
        Pressure *pressure = [pressures objectAtIndex:i];
        NSInteger val = [pressure.channel_2 intValue];
        
       // NSInteger seconds = [pressure.sec intValue];
        min = [pressure.min intValue];
         [linechartsecondentries addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
    }
    
   channelTwoLineChatDataSet = [[LineChartDataSet alloc] initWithYVals:linechartsecondentries label:@"Body Pressure"];
    [channelTwoLineChatDataSet setColor:[UIColor colorWithRed:142/255.f green:220/255.f blue:157/255.f alpha:1.f]];
    channelTwoLineChatDataSet.lineWidth = 2;
    [channelTwoLineChatDataSet setCircleColor:[UIColor colorWithRed:51/255.f green:90/255.f blue:150/255.f alpha:0.5f]];
    channelTwoLineChatDataSet.fillColor = UIColor.whiteColor;
    channelTwoLineChatDataSet.drawCircleHoleEnabled =YES;
    channelTwoLineChatDataSet.drawCubicEnabled = NO;
    channelTwoLineChatDataSet.drawValuesEnabled = NO;
    channelTwoLineChatDataSet.drawCirclesEnabled = NO;
    channelTwoLineChatDataSet.valueFont = [UIFont systemFontOfSize:10.f];
    channelTwoLineChatDataSet.circleRadius = 2.0;
    channelTwoLineChatDataSet.valueTextColor = [UIColor colorWithRed:240/255.f green:238/255.f blue:70/255.f alpha:1.f];
    
    channelTwoLineChatDataSet.axisDependency = AxisDependencyLeft;
    channelTwoLineChatDataSet.lineDashLengths = @[@5.f, @2.f];
    
    [lineChatData addDataSet:channelOneLineChatDataSet];
   [lineChatData addDataSet:channelTwoLineChatDataSet];
    
    

    return lineChatData;
}


- (BarChartData *)generateBarData:(NSArray *)motions
{
    BarChartData *d = [[BarChartData alloc] init];
    
    barchartentries = [[NSMutableArray alloc] init];
    int min = 0;
    
    for (int i = 0; i <[motions count]; i++)
    {
        Motion *motion = [motions objectAtIndex:i];
        NSInteger val = [motion.avg_motion intValue];
        
        NSInteger seconds = [motion.min intValue];
        min = (int) seconds/60000;
        for (int j=min-5; j<=min; j++) {
             [barchartentries addObject:[[BarChartDataEntry alloc] initWithValue:val xIndex:j]];
        }
       
    }

    barChartDataset = [[BarChartDataSet alloc] initWithYVals:barchartentries label:@"Motion"];
    [barChartDataset setColor:[UIColor colorWithRed:249/255.f green:229/255.f blue:89/255.f alpha:1.f]];
    barChartDataset.drawValuesEnabled  = NO;
    barChartDataset.barSpace = 0.5;
    barChartDataset.barShadowColor = UIColor.clearColor;
    
    barChartDataset.axisDependency = AxisDependencyLeft;
    
    [d addDataSet:barChartDataset];
    
    return d;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;//Or return whatever as you intend
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return sessionsArr.count;//Or, return as suitable for you...normally we use array for dynamic
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return sessionsArr[row];//Or, your suitable title; like Choice-a, etc.
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    session_id = [sessionsArr objectAtIndex:row];
}


- (id)eventDataWithString:(NSString *)string
{
    return @{@"data": string};
}

- (IBAction)loadSession:(id)sender {
    NSMutableDictionary *sessionParam = [[NSMutableDictionary alloc]init];
    //[sessionParam setObject:@"E727B27E-F7D8-4135-A93A-CDE6AE09286E-821-000002895A92A69F" forKey:@"session_id"];
    NSString *user_id = self.userIdTextField.text;

    [sessionParam setObject:session_id forKey:@"session_id"];
    [sessionParam setObject:user_id forKey:@"user_id"];
    
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
- (IBAction)remove:(id)sender {
    [self removeData];
}
@end
