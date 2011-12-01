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
    NSLog(@"context %@",context);
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Set"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    //search by workout id
    NSString *workoutId = [NSString stringWithFormat:@"%d", [workout.workoutId intValue]];
    NSString *exerciseId = [NSString stringWithFormat:@"%d", [exercise.exerciseId intValue]];
    request.predicate = [NSPredicate predicateWithFormat:@"belongsToWorkout.workoutId = %@ and exerciseId = %@",workoutId,exerciseId];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request
                                              error:&error];
    return matches;
}
@end
