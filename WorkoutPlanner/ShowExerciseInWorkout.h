//
//  ShowExerciseInWorkout.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/26/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exercise.h"

@interface ShowExerciseInWorkout : UIViewController
@property (nonatomic, strong) Exercise *exercise;
@property (nonatomic, strong) NSArray *setsForExercise;
@end
