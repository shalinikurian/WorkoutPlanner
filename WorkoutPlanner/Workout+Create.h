//
//  Workout+Create.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/22/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "Workout.h"

@interface Workout (Create)
+ (void) createAWorkoutWithName:(NSString *) name
               withDescription:(NSString *)desc
                 withExercises:(NSArray *)exercises
                      withSets:(NSArray *)sets
        inManagedObjectContext:(NSManagedObjectContext *) context;
@end
