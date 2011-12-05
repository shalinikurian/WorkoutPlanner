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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void) drawPerformanceLineGraph
{
    float data[] = {0.7, 0.4, 0.9, 1.0, 0.2, 0.85, 0.11, 0.75, 0.53, 0.44, 0.88, 0.77, 0.99, 0.55};
    
    //make gradient
    size_t num_of_locations = 2;
    CGFloat locations[2] = {0.0 , 1.0};
    CGFloat components[8] = {0.6, 0.2, 0.9, 0.3 ,0.2 ,0.5 , 0.0, 0.9};
    CGColorSpaceRef cSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef grad =  CGGradientCreateWithColorComponents(cSpace, components, locations, num_of_locations);
    CGPoint startAt, endAt;
    startAt = CGPointMake(kOffsetX, kGraphHeight);
    endAt = CGPointMake(kOffsetX, kOffsetY);
    
    
    
    //fill in the graph
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:0.6 green:0.2 blue:1.0 alpha:1.0] CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0.6 green:0.2 blue:1.0 alpha:0.4] CGColor]);
    
    
   
    int maxGraphHeight = kGraphHeight - kOffsetY;
    int verticleLinesNo = 7;
    int stepX = (kDefaultGraphWidth - kOffsetX) / verticleLinesNo;
    
    
    //draw gradient
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, kOffsetX, kGraphHeight);
    CGContextAddLineToPoint(context, kOffsetX, kGraphHeight - maxGraphHeight * data[0]);
    for (int i = 1; i < sizeof(data); i++)
    {
        CGContextAddLineToPoint(context, kOffsetX + i * stepX, kGraphHeight - maxGraphHeight * data[i]);
    }
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, kOffsetX, kGraphHeight);
    CGContextAddLineToPoint(context, kOffsetX, kGraphHeight - maxGraphHeight * data[0]);
    for (int i = 1; i < sizeof(data); i++)
    {
        CGContextAddLineToPoint(context, kOffsetX + i * stepX, kGraphHeight - maxGraphHeight * data[i]);
    }
    CGContextAddLineToPoint(context, kOffsetX + (sizeof(data) - 1) * stepX, kGraphHeight);
    CGContextClosePath(context);
    CGContextSaveGState(context);
    CGContextClip(context);
    CGContextDrawPath(context, kCGPathFill);
    CGContextDrawLinearGradient(context, grad, startAt, endAt, 0);
    
    CGContextRestoreGState(context);
    CGColorSpaceRelease(cSpace);
    CGGradientRelease(grad);
    
    
    //draw line graoh
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, kOffsetX, kGraphHeight);
    CGContextAddLineToPoint(context, kOffsetX, kGraphHeight - maxGraphHeight * data[0]);
    for (int i = 1; i < sizeof(data); i++)
    {
        CGContextAddLineToPoint(context, kOffsetX + i * stepX, kGraphHeight - maxGraphHeight * data[i]);
    }
    CGContextAddLineToPoint(context, kOffsetX + (sizeof(data) - 1) * stepX, kGraphHeight);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    
    //draw data points
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0.5 green:0.51 blue:0.5 alpha:1.0] CGColor]);
    for (int i = 0; i <sizeof(data);i ++){
        float x = kOffsetX + i * stepX;
        float y = kGraphHeight - maxGraphHeight * data[i];
        CGRect dataPoint = CGRectMake(x - dataPointThickness,y - dataPointThickness , dataPointThickness * 3, dataPointThickness*3);
        CGContextAddEllipseInRect(context, dataPoint);
    }
    CGContextDrawPath(context, kCGPathFillStroke);
    
    
}
- (void)drawRect:(CGRect)rect
{
    float data[] = {0.7, 0.4, 0.9, 1.0, 0.2, 0.85, 0.11, 0.75, 0.53, 0.44, 0.88, 0.77, 0.99, 0.55};
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
    
    //draw vertical lines
    //for a month 30 , for a week 7
    int verticleLinesNo = 7;
    NSLog(@"no of vertical lines %d",verticleLinesNo);
    int stepX = (kDefaultGraphWidth - kOffsetX) / verticleLinesNo;
    for (int i =0 ;i < verticleLinesNo ; i++)
    {
        CGContextMoveToPoint(context, kOffsetX + i * stepX, kGraphTop);
        CGContextAddLineToPoint(context, kOffsetX + i * stepX, kGraphBottom);
        CGContextStrokePath(context);
    }
    
    //draw horizontal lines TODO depending on datea
    int horizontalLinesNo = (kGraphBottom - kGraphTop - kOffsetX) / kStepY;
    for (int i = 0 ;i <= horizontalLinesNo; i++){
        CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - i * kStepY);
        CGContextAddLineToPoint(context, kDefaultGraphWidth, kGraphBottom - kOffsetY - i * kStepY);
        CGContextStrokePath(context);
    }
    
    //disable dash for future drawing
    CGContextSetLineDash(context, 0.0, NULL, 0);   
    
    //draw graph labels
    //support rotation of text
    CGContextSetTextMatrix(context, CGAffineTransformRotate(CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0), M_PI / 2));
    CGContextSelectFont(context, "Helvetica", 10, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]);
    for ( int i = 1 ; i <sizeof(data); i ++){
        //plot date 
        NSString * label = [NSString stringWithFormat:@"%d" , i];
        CGContextShowTextAtPoint(context, kOffsetX + i *stepX, kGraphBottom - 10, [label cStringUsingEncoding:NSUTF8StringEncoding], [label length]);
    }
}


@end
