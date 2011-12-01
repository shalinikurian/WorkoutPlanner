//
//  Exercise+Create.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/22/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "Exercise+Create.h"
#import "Workout.h"

@implementation Exercise (Create)

+ (Exercise *) createExerciseWithName:(NSString *)name 
                withDescription:(NSString *)desc 
                      withImage:(NSURL *)imageURL 
         inManagedObjectContext:(NSManagedObjectContext *)context{
    NSLog(@"context %@",context);
    NSFetchRequest *requestExercise = [NSFetchRequest fetchRequestWithEntityName:@"Exercise"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"exerciseId" ascending:NO];
    requestExercise.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:requestExercise error:&error];
    int idForExercise = 1;
    Exercise *newExercise = nil;
   
    if([result count] > 0){//not the first exercise in the database
        Exercise * exerciseWithHighestId = [result objectAtIndex:0];
        idForExercise = [exerciseWithHighestId.exerciseId intValue];
        idForExercise = idForExercise + 1;
        
    }
    
    //add the exercise to the database
    newExercise = [NSEntityDescription insertNewObjectForEntityForName:@"Exercise"
                                                inManagedObjectContext:context];
    newExercise.exerciseId = [NSNumber numberWithInt:idForExercise];
    if ([name length] == 0){
        name=@"Unknown";
    }
    if ([desc length] == 0){
        desc=@"Unknown";
    }
    newExercise.name = name;
    newExercise.exerciseDescription = desc;
    [context save:&error];
    return newExercise;
    
    
}
@end
