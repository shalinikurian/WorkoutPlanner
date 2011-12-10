//
//  GraphView.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/4/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import <UIKit/UIKit.h>
//#define kGraphHeight 367
//#define kDefaultGraphWidth 320
#define kOffsetX 30
//#define kGraphBottom 367
#define kOffsetY 20
#define dataPointThickness 3
#define DRAW_HORIZONTAL_LINE_COLOR [UIColor colorWithRed:0.3 green:0.5 blue:0.4 alpha:0.9]
#define SHADOW_COLOR [UIColor colorWithRed:0.3 green:0.8 blue:0.6 alpha:0.9]
#define noOFHorizontalLines 6
#define week 7
@interface GraphView : UIView
@property (nonatomic, weak) NSArray *performance;
@property (nonatomic, strong) NSDate *toDate;
@property (nonatomic) int noOfDays;
@property (nonatomic) float kGraphHeight;
@property (nonatomic) float kDefaultGraphWidth;
@end
