//
//  ShowExerciseInWorkout.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/26/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exercise.h"

@protocol ShowExistingExercisesInWorkoutProtocol <NSObject>
- (void) editExercise:(Exercise *)exercise
              withSet:(NSArray*) set;
@end

@interface ShowExerciseInWorkout : UIViewController
@property (nonatomic, strong) Exercise *exercise;
@property (nonatomic, strong) NSMutableArray *setsForExercise;
@property (nonatomic) bool editExercise;
@property (nonatomic, weak) id<ShowExistingExercisesInWorkoutProtocol>delegate;
@end

