//
//  GraphView.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/4/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import <UIKit/UIKit.h>
#define kGraphHeight 320
#define kDefaultGraphWidth 367
#define kOffsetX 10
#define kGraphBottom 320
#define kGraphTop 0
#define kStepY 30
#define kOffsetY 10
#define dataPointThickness 3
#define DRAW_COLOR [UIColor lightGrayColor]
#define noOFHorizontalLines 10
#define week 7
@interface GraphView : UIView
@property (nonatomic, weak) NSArray *performance;
@property (nonatomic, strong) NSDate *toDate;
@property (nonatomic) int noOfDays;
@end
