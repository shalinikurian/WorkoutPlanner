//
//  PlotPerformance.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/4/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exercise.h"

@interface PlotPerformance : UIViewController
@property (nonatomic, strong) NSArray *performance;
@property (nonatomic, strong) NSString *exerciseName;
@property (nonatomic, strong) NSDate *toDate ;
@property (nonatomic, strong) Exercise *exercise;
@property (nonatomic, strong) UIManagedDocument *database;
@end
