//
//  Set+Create.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/25/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "Set+Create.h"

@implementation Set (Create)

+ (Set*) createASetforExercise:(Exercise*) exercise
                      withReps:(NSInteger) reps
                    withWeight:(NSInteger) weight
                     withOrder:(NSInteger) order
        inManagedObjectContext:(NSManagedObjectContext *) context{
    Set * set = nil;
    
    NSFetchRequest *requestExercise = [NSFetchRequest fetchRequestWithEntityName:@"Set"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"setId" ascending:NO];
    requestExercise.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:requestExercise error:&error];
    int idForSet = 1;

    if([result count] > 0){//not the first set in the database
        Set * setWithHighestId = [result objectAtIndex:0];
        idForSet = [setWithHighestId.setId intValue];
        idForSet = idForSet + 1;
    }
    
    //add the exercise to the database
    set = [NSEntityDescription insertNewObjectForEntityForName:@"Set"
                                                inManagedObjectContext:context];
    NSLog(@"making set from reps and weight %d %d",reps, weight);
    set.setId = [NSNumber numberWithInt:idForSet];
    set.rep =[NSNumber numberWithInt:reps];
    set.weight = [NSNumber numberWithInt:weight];
    set.order = [NSNumber numberWithInt:order];
    set.exerciseId = exercise.exerciseId;

    return set;
}
@end
