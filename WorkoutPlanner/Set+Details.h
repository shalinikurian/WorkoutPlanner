//
//  Set+Details.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/26/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "Set.h"
#import "Exercise.h"
#import "Workout.h"

@interface Set (Details)

+ (NSArray *) setsForExercise:(Exercise *) exercise
                   andWorkout:(Workout *) workout
       inManagedObjectContext: (NSManagedObjectContext *) context;

@end
