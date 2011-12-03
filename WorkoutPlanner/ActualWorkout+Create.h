//
//  ActualWorkout+Create.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/2/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "ActualWorkout.h"
#import "Workout.h"
#import "Exercise.h"

@interface ActualWorkout (Create)

+ (void) createLogForWorkout :(Workout *) workout
        withSetsForExercises : (NSArray *) setsForExercises
                 forExercises: (NSArray *)exercises
        withDurationInSeconds: (NSInteger ) duration
                    withDate : (NSDate *) date
                   withImages: (NSArray *) imageUrls
      inManagedObjectContext : (NSManagedObjectContext *) context;
@end
