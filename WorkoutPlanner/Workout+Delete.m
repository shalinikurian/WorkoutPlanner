//
//  Workout+Delete.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/25/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "Workout+Delete.h"

@implementation Workout (Delete)

+ (void) deleteWorkout:(Workout *)workout 
inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSLog(@"deleting a workout");
    NSLog(@"workout %@",workout);
    Workout *obj = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Workout"];
    request.predicate = [NSPredicate predicateWithFormat:@"workoutId = %@",workout.workoutId];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if(!matches ||([matches count] >1)){
        NSLog(@"error in workout");
        //error
    }else if ([matches count] == 1) {
        //delete workout
        obj =[matches lastObject];
        //delete sets for exercises , exercise order 
        [context deleteObject:obj];
        [context save:&error];
    }
}
@end
