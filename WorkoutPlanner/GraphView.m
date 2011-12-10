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
@synthesize kDefaultGraphWidth = _kDefaultGraphWidth;
@synthesize kGraphHeight = _kGraphHeight;

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
    
    float kStepY = (self.frame.size.height - 2*kOffsetY) /(noOFHorizontalLines);
    float yUnit =[self getMaxValueFromData]/(noOFHorizontalLines-1);
    float stepX = (self.frame.size.width - 2*kOffsetX) / (self.noOfDays-1);
    float yPlot;
    
    //fill in the graph
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:0.2 green:0.5 blue:0.2 alpha:1.0] CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0.2 green:0.5 blue:0.2 alpha:0.2] CGColor]);
    CGContextSetShadowWithColor(context, CGSizeMake(5, 5), 20, [[UIColor colorWithRed:0.2 green:0.7 blue:0.2 alpha:0.8] CGColor]);
    
    //draw line graph
    for (int i = 0; i < [dataValues count] - 1; i++)
    {
        NSNumber *value = [dataValues objectAtIndex:i];
        NSNumber *value2 = [dataValues objectAtIndex:i+1];
    
        yPlot = kStepY / yUnit * [value floatValue];
        yPlot = self.kGraphHeight - kOffsetY - yPlot;
        float yPlot2 = kStepY / yUnit * [value2 floatValue];
        yPlot2 = self.kGraphHeight - kOffsetY - yPlot2;
        
        CGContextMoveToPoint(context, kOffsetX + (i*stepX), yPlot);
        CGContextAddLineToPoint(context, kOffsetX + (i+1) * stepX, yPlot2);
        CGContextStrokePath(context);
    }
    
       
    
    //draw data points
        
    CGContextSetShadowWithColor(context, CGSizeMake(5, 5), 15, NULL);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0.5 green:0.51 blue:0.5 alpha:1.0] CGColor]);
    for (int i = 0; i <[dataValues count];i ++){
        float x = kOffsetX + i * stepX;
        NSNumber *value = [dataValues objectAtIndex:i];
        float y = kStepY / yUnit * [value floatValue];
        y = self.kGraphHeight - kOffsetY - y;
        CGRect dataPoint = CGRectMake(x - dataPointThickness,y - dataPointThickness , dataPointThickness*2.5, dataPointThickness*2.5);
        CGContextAddEllipseInRect(context, dataPoint);
    }
    CGContextDrawPath(context, kCGPathFillStroke);
    
    
}

- (void)drawRect:(CGRect)rect
{
    //get graph height and width
    float kGraphBottom = self.kGraphHeight;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //add background image
    UIImage *image =[UIImage imageNamed:@"graphBk.jpg"];
    CGRect imageFrame =  CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGContextDrawImage(context, imageFrame, image.CGImage);
    
    [self drawPerformanceLineGraph];
    
    //set shadow
    CGContextSetShadowWithColor(context, CGSizeMake(2, 2), 12, [SHADOW_COLOR CGColor]);
    //draw horizontal lines
    CGContextSetLineWidth(context, 0.3);
    
    CGContextSetStrokeColorWithColor(context,[DRAW_HORIZONTAL_LINE_COLOR CGColor] );   //for a month 30 , for a week 7
    float stepX = (self.frame.size.width - 2*kOffsetX) / (self.noOfDays-1);
    float kStepY = (self.frame.size.height - 2*kOffsetY) /(noOFHorizontalLines);

    for (int i = 0 ;i < noOFHorizontalLines; i++){
        CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - i * kStepY);
        CGContextAddLineToPoint(context, self.frame.size.width - kOffsetX, kGraphBottom - kOffsetY - i * kStepY);
        CGContextStrokePath(context);
    }
    //draw hash marks on the bottom most line
    for (int i = 0; i < self.noOfDays ; i++){
        CGContextMoveToPoint(context, kOffsetX + i*stepX, kGraphBottom - kOffsetY + 1);
        CGContextAddLineToPoint(context, kOffsetX + i*stepX, kGraphBottom - kOffsetY - 4);
        CGContextStrokePath(context);
    }
    
   
    
    //set shadow null
    CGContextSetShadowWithColor(context, CGSizeMake(2, 2), 12, NULL);
    
    //draw axes labels
    
    //x axis
    CGContextSetTextMatrix (context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    CGContextSelectFont(context, "Helvetica", 15, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, 255.0f/255.0f, 255.0f/255.0f, 255.0f/255.0f, 1.0f);
    
    
    NSString * xAxisLabel = @"Date";
    CGContextShowTextAtPoint(context, self.kDefaultGraphWidth/2 - kOffsetX , kGraphBottom + 45, [xAxisLabel cStringUsingEncoding:NSUTF8StringEncoding], [xAxisLabel length]);
    
    
    //y axis markings
    
    CGContextSelectFont(context, "Helvetica", 12, kCGEncodingMacRoman);
    CGContextSetRGBFillColor(context, 100.0f/255.0f, 100.0f/255.0f, 100.0f/255.0f, 1.0f);
    float highestDataValue = [self getMaxValueFromData];
    if (highestDataValue == 0) highestDataValue = 1;
    NSLog(@"highest %f",kGraphBottom -  kOffsetY - (5*kStepY));
    float yUnit =highestDataValue/(noOFHorizontalLines-1);
    float label = 0;
    for (int i = 0 ; i < noOFHorizontalLines; i++){
        NSString * labelY = [NSString stringWithFormat:@"%.01f" , label];
        label+=yUnit;
        CGContextShowTextAtPoint(context, 2, kGraphBottom - kOffsetY - i * kStepY, [labelY cStringUsingEncoding:NSUTF8StringEncoding], [labelY length]);
    }
    
    
    //y axis label
    CGContextSelectFont(context, "Helvetica", 15, kCGEncodingMacRoman);
    CGContextSetRGBFillColor(context, 255.0f/255.0f, 255.0f/255.0f, 255.0f/255.0f, 1.0f);
    CGContextSetTextMatrix(context, CGAffineTransformRotate(CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0), M_PI / 2));
    NSString * yAxisLabel = @"lbs/rep";
    CGContextShowTextAtPoint(context, 15, self.kGraphHeight/2 + kOffsetY + 5, [yAxisLabel cStringUsingEncoding:NSUTF8StringEncoding], [yAxisLabel length]);
    
    //x axis markings
    CGContextSelectFont(context, "Helvetica", 12, kCGEncodingMacRoman);
    CGContextSetRGBFillColor(context, 100.0f/255.0f, 100.0f/255.0f, 100.0f/255.0f, 1.0f);
    NSDate *currDate = self.toDate;
    for ( int i = self.noOfDays-1; i >= 0; i--){
        //plot date 
        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"MMMd" options:0
                                                                  locale:[NSLocale currentLocale]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatString];
        
        NSString * labelX = [dateFormatter stringFromDate:currDate];      
        CGContextShowTextAtPoint(context, kOffsetX + (i) *stepX, kGraphBottom +30, [labelX cStringUsingEncoding:NSUTF8StringEncoding], [labelX length]);
        currDate = [[GraphView class] getPreviousDayFromDate:currDate];
    }
   
       
   
}


@end
