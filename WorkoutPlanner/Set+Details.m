//
//  Set+Details.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/26/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "Set+Details.h"

@implementation Set (Details)

+ (NSArray *)setsForExercise:(Exercise *)exercise 
                  andWorkout:(Workout *)workout 
      inManagedObjectContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Set"];
    //search by workout id
    NSString *workoutId = [NSString stringWithFormat:@"%d", [workout.workoutId intValue]];
    NSString *exerciseId = [NSString stringWithFormat:@"%d", [exercise.exerciseId intValue]];
    NSLog(@"workout id %@", workoutId);
    request.predicate = [NSPredicate predicateWithFormat:@"%@ IN belongsToWorkout.workoutId and exerciseId = %@",workoutId,exerciseId];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request
                                              error:&error];
    if ([matches count] >0 ){
        for (Set *set in matches) {
            NSLog(@"%@ rep",set.rep);
            NSLog(@"%@ wt",set.weight);
            NSLog(@"%@ order",set.order);
        }
    }
    return matches;
}
@end
