//
//  LogAWorkoutViewController.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/29/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Workout.h"
@interface LogAWorkoutViewController : UIViewController
@property (nonatomic, strong) Workout *workout;
@property (nonatomic, strong) UIManagedDocument *database;
@property (nonatomic, strong) NSMutableArray *exercises;
@property (nonatomic, strong) NSMutableArray *setsInExercises;
@end
