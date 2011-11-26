//
//  ShowExistingWorkout.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/26/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Workout.h"

@interface ShowExistingWorkout : UIViewController
@property (nonatomic, strong) UIManagedDocument *database;
@property (nonatomic, strong) Workout *workout;
@end
