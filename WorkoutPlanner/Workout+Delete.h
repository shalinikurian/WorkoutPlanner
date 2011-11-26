//
//  Workout+Delete.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/25/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "Workout.h"

@interface Workout (Delete)

+ (void) deleteWorkout: (Workout *) workout
inManagedObjectContext:(NSManagedObjectContext *) context;

@end
