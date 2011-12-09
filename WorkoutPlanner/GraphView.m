//
//  GraphView.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/4/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "GraphView.h"

@interface GraphView ()
//adjust is for a week or a month
@property (nonatomic) int kStepX;
@end
@implementation GraphView
@synthesize kStepX = _kStepX;
@synthesize performance = _performance;
@synthesize toDate = _toDate;
@synthesize noOfDays = _noOfDays;
@synthesize graphWidth = _graphWidth;
@synthesize graphHeight = _graphHeight;

+ (NSDate *) getPreviousDayFromDate: (NSDate *) currDate{
    NSDate *prevDate;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];  
    [components setDay:-1];
    prevDate  = [cal dateByAddingComponents:components toDate:currDate options:0];
    return prevDate;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (NSArray *) getDataPoints
{
    //reverse data points
    NSMutableArray * dataPts = [[NSMutableArray alloc] init];
    for ( int i = [self.performance count]-1; i >=0; i--){
        NSDictionary *perDay = [self.performance objectAtIndex:i];
        NSNumber *wtPerRep = [perDay objectForKey:@"weightPerRep"];
        [dataPts addObject:wtPerRep];
    }
    //append zeros if needed
    for (int i = [dataPts count] ; i < self.noOfDays; i++){
        [dataPts addObject:[NSNumber numberWithFloat:0.0]];
    }
    NSLog(@"data pts %@",dataPts);
    return dataPts;
}

- (float) getMaxValueFromData
{
    float highest = 0;
    for (int i = 0; i < [self.performance count]; i++){
        NSDictionary *perDay = [self.performance objectAtIndex:i];
        float wtPerRep = [[perDay objectForKey:@"weightPerRep"] floatValue];
        if (wtPerRep > highest) highest = wtPerRep;
    }
    return highest;
}

- (void) drawPerformanceLineGraph
{
 
    NSArray *dataValues = [self getDataPoints];
    
    int maxGraphHeight = kGraphHeight - kOffsetY;
    int stepX = (kDefaultGraphWidth - kOffsetX) / self.noOfDays + 1;
    float yPlot;
    

    
    //make gradient
    size_t num_of_locations = 2;
    CGFloat locations[2] = {0.0 , 1.0};
    CGFloat components[8] = {0.2, 0.5, 0.7, 0.2 ,0.1 ,0.4 , 0.0, 0.8};
    CGColorSpaceRef cSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef grad =  CGGradientCreateWithColorComponents(cSpace, components, locations, num_of_locations);
    CGPoint startAt, endAt;
    startAt = CGPointMake(kOffsetX +stepX, kGraphHeight);
    endAt = CGPointMake(kOffsetX + stepX, kOffsetY);
    
    
    
    //fill in the graph
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:0.2 green:0.5 blue:0.2 alpha:1.0] CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0.2 green:0.5 blue:0.2 alpha:0.2] CGColor]);
    
    
   
       //draw gradient
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, kOffsetX + stepX, kGraphHeight);
    NSNumber *firstValue = [dataValues objectAtIndex:0];
    float maxValue = [self getMaxValueFromData];
    for (int i = 0; i < [dataValues count]; i++)
    {
        NSNumber *value = [dataValues objectAtIndex:i];
        yPlot = MIN(kGraphHeight - (float)maxGraphHeight / maxValue * [value floatValue], maxGraphHeight);
        CGContextAddLineToPoint(context, kOffsetX + (i+1) * stepX, yPlot);
    }
    
    yPlot = MIN(kGraphHeight - (float)maxGraphHeight / maxValue * [firstValue floatValue], maxGraphHeight);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, kOffsetX + stepX, kGraphHeight - kOffsetY);
    
    for (int i = 0; i < [dataValues count]; i++)
    {
        NSNumber *value = [dataValues objectAtIndex:i];
        yPlot = MIN(kGraphHeight - (float)maxGraphHeight / maxValue * [value floatValue], maxGraphHeight);
        CGContextAddLineToPoint(context, kOffsetX + (i+1) * stepX, yPlot);
    }
    CGContextAddLineToPoint(context, kOffsetX + (self.noOfDays) * stepX, kGraphHeight - kOffsetY);
    
    CGContextClosePath(context);
    CGContextSaveGState(context);
    CGContextClip(context);
    CGContextDrawPath(context, kCGPathFill);
    CGContextDrawLinearGradient(context, grad, startAt, endAt, 0);
    
    CGContextRestoreGState(context);
    CGColorSpaceRelease(cSpace);
    CGGradientRelease(grad);
    
    
    //draw line graph

    CGContextBeginPath(context);
    CGContextMoveToPoint(context, kOffsetX + stepX, kGraphHeight - kOffsetY);

    for (int i = 0; i < [dataValues count]; i++)
    {
        NSNumber *value = [dataValues objectAtIndex:i];
        yPlot = MIN(kGraphHeight - (float)maxGraphHeight / maxValue * [value floatValue], maxGraphHeight);
        CGContextAddLineToPoint(context, kOffsetX + (i+1) * stepX, yPlot);
    }
    CGContextAddLineToPoint(context, kOffsetX + (self.noOfDays) * stepX, kGraphHeight - kOffsetY);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    
    //draw data points
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0.5 green:0.51 blue:0.5 alpha:1.0] CGColor]);
    for (int i = 0; i <[dataValues count];i ++){
        float x = kOffsetX + (i+1) * stepX;
        NSNumber *value = [dataValues objectAtIndex:i];
        float y = MIN(kGraphHeight - (float)maxGraphHeight / maxValue * [value floatValue], maxGraphHeight);
        CGRect dataPoint = CGRectMake(x - dataPointThickness,y - dataPointThickness , dataPointThickness * 3, dataPointThickness*3);
        CGContextAddEllipseInRect(context, dataPoint);
    }
    CGContextDrawPath(context, kCGPathFillStroke);
    
    
}

- (void)drawRect:(CGRect)rect
{
    //get graph height and width
    self.graphHeight = self.frame.size.height;
    self.graphWidth = self.frame.size.width;
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    /*UIImage *image =[UIImage imageNamed:@"graphBackground.png"];
    CGRect imageFrame = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextDrawImage(context, imageFrame, image.CGImage);*/
    
    [self drawPerformanceLineGraph];
    
    //Quartz preparation step
    //thickness and color
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context,[DRAW_COLOR CGColor]);
    CGFloat dash[] = {1.0,1.0};
    CGContextSetLineDash(context, 0.0, dash, 2);
    
    //for a month 30 , for a week 7
    int stepX = (kDefaultGraphWidth - kOffsetX) / (self.noOfDays+1);
    
    //draw horizontal lines 
    for (int i = 0 ;i <= noOFHorizontalLines; i++){
        CGContextMoveToPoint(context, kOffsetX + stepX, kGraphBottom - kOffsetY - i * kStepY);
        CGContextAddLineToPoint(context, kDefaultGraphWidth, kGraphBottom - kOffsetY - i * kStepY);
        CGContextStrokePath(context);
    }
    
    //draw vertical lines
    
    for (int i =1 ;i <= self.noOfDays+1 ; i++)
    {
        CGContextMoveToPoint(context, kOffsetX + i * stepX, kGraphTop);
        CGContextAddLineToPoint(context, kOffsetX + i * stepX, kGraphBottom - kOffsetY);
        CGContextStrokePath(context);
    }
    
    
    //disable dash for future drawing
    CGContextSetLineDash(context, 0.0, NULL, 0);   
    
    //draw graph labels
    CGContextSetTextMatrix (context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    CGContextSelectFont(context, "Helvetica", 15, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]);
    NSString * xAxisLabel = @"Date";
    CGContextShowTextAtPoint(context, kDefaultGraphWidth/2  , kGraphBottom + kOffsetY, [xAxisLabel cStringUsingEncoding:NSUTF8StringEncoding], [xAxisLabel length]);
    
    // y axis labels
    CGContextSelectFont(context, "Helvetica", 10, kCGEncodingMacRoman);
    float highestDataValue = [self getMaxValueFromData];
    if (highestDataValue == 0) highestDataValue = 1;
    float yUnit =highestDataValue/noOFHorizontalLines;
    float label = 0;
    for (int i = 0 ; i <= noOFHorizontalLines; i++){
        NSString * labelY = [NSString stringWithFormat:@"%.02f" , label];
        label+=yUnit;
        CGContextShowTextAtPoint(context, kOffsetX+5, kGraphBottom - kOffsetY - i * kStepY, [labelY cStringUsingEncoding:NSUTF8StringEncoding], [labelY length]);
    }
    
    CGContextSetTextMatrix(context, CGAffineTransformRotate(CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0), M_PI / 2));
    NSString * yAxisLabel = @"lbs/rep";
    CGContextShowTextAtPoint(context, kOffsetX, kGraphHeight/2, [yAxisLabel cStringUsingEncoding:NSUTF8StringEncoding], [yAxisLabel length]);
    //x axis labels
    CGContextSelectFont(context, "Helvetica", 10, kCGEncodingMacRoman);
    NSDate *currDate = self.toDate;
    for ( int i = self.noOfDays-1; i >= 0; i--){
        //plot date 
        NSDate *date = [[GraphView class] getPreviousDayFromDate:currDate];
        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"MMMd" options:0
                                                                  locale:[NSLocale currentLocale]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatString];
        
        NSString * labelX = [dateFormatter stringFromDate:date];      CGContextShowTextAtPoint(context, kOffsetX + (i+1) *stepX, kGraphBottom +30, [labelX cStringUsingEncoding:NSUTF8StringEncoding], [labelX length]);
        currDate = date;
    }
}


@end
