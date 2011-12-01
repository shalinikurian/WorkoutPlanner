//
//  Exercise+Details.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/26/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "Exercise+Details.h"
#import "Workout.h"
@implementation Exercise (Details)
+ (NSArray *) fetchExericesForWorkout : (Workout *) workout 
              inManagedObjectContext:(NSManagedObjectContext *)context{
    NSLog(@"context %@",context);
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Exercise"];
    //search by workout id
    NSString *workoutId = [NSString stringWithFormat:@"%d", [workout.workoutId intValue]];
    NSLog(@"workout id %@", workoutId);
    request.predicate = [NSPredicate predicateWithFormat:@"%@ IN belongsToWorkout.workoutId",workoutId];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request
                                              error:&error];
    if ([matches count] > 0 ) {
        /*Exercise *exercise = nil;
        exercise = [matches lastObject];
        NSLog(@"all exercises %@",matches);
        NSSet *workouts = exercise.belongsToWorkout;
        NSArray *wks = [workouts allObjects];
        Workout *wk = (Workout *)[wks lastObject];
        NSLog(@"belongs to workout %@",wk);
        NSLog(@"count %d",[matches count]);*/
    }
    return matches;
}
@end
