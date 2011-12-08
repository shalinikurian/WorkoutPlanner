//
//  Workout+Create.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/22/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "Workout+Create.h"
#import "Set+Create.h"
#import "Exercise.h"

@implementation Workout (Create)

+ (void) createAWorkoutWithName:(NSString *)name 
                withDescription:(NSString *)desc 
                  withExercises:(NSArray *)exercises 
                       withSets:(NSArray *)sets 
         inManagedObjectContext:(NSManagedObjectContext *)context
managedDocutment:(UIManagedDocument *)doc
callBlock:(completion_block_workout)completion_block{
    
    NSLog(@"context %@",context);
   //[context reset];
   NSFetchRequest *requestWorkout = [NSFetchRequest fetchRequestWithEntityName:@"Workout"];
   NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"workoutId" ascending:NO];
   requestWorkout.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
   NSError *error = nil;
   NSArray *result = [context executeFetchRequest:requestWorkout error:&error];
   int idForWorkout = 1;
   Workout *newWorkout = nil;

   if([result count] > 0){//not the first workout in the database
        Workout * workoutWithHighestId = [result objectAtIndex:0];
        idForWorkout = [workoutWithHighestId.workoutId intValue];
        idForWorkout = idForWorkout + 1;
   }
    //add the workout to the database
    newWorkout = [NSEntityDescription insertNewObjectForEntityForName:@"Workout"
                                                inManagedObjectContext:context];
    if ([name length] == 0){
        name=@"Unknown";
    }
    if ([desc length] == 0){
        desc=@"Unknown";
    }
    newWorkout.workoutId = [NSNumber numberWithInt:idForWorkout];
    newWorkout.name = name;
    newWorkout.workoutDescription = desc;

    NSMutableOrderedSet *exerciseList = [newWorkout mutableOrderedSetValueForKey:@"hasExercises"];
    for (Exercise *exercise in exercises){
        [exerciseList addObject:exercise];
        requestWorkout = [NSFetchRequest fetchRequestWithEntityName:@"Workout"];
        requestWorkout.predicate = [NSPredicate predicateWithFormat:@"workoutId = %@",newWorkout.workoutId];
        NSError *error = nil;
        NSArray *result = [context executeFetchRequest:requestWorkout error:&error];    
        NSLog(@"workout after adding exercise %@",[result lastObject]);
    }
    
    //store exercisesets
    NSMutableOrderedSet *setForExercises = [newWorkout mutableOrderedSetValueForKey:@"setsForExercises"];
    //form sets
    for (int i = 0 ;i<[sets count];i++){
        //set is a nsarray of set for exercise at same position in exercises array
        NSArray *setsPerExercise = (NSArray*)[sets objectAtIndex:i];
        for (int j=0;j<[setsPerExercise count];j++){
            NSDictionary *oneSet = (NSDictionary *) [setsPerExercise objectAtIndex:j];
            NSInteger reps,weight;
            if ([oneSet objectForKey:@"reps"]){
                reps = [[oneSet objectForKey:@"reps"] intValue];
            }
            if ([oneSet objectForKey:@"weight"]){
                weight = [[oneSet objectForKey:@"weight"] intValue];
            }
            //NSInteger weight = (NSInteger) [oneSet objectForKey:@"weight"];
            Set *set = [Set createASetforExercise:[exercises objectAtIndex:i] 
                        withReps:reps
                      withWeight:weight
                        withOrder:j
          inManagedObjectContext:context];
          set.belongsToWorkout = newWorkout;
            //add set to setForExercises
          [setForExercises addObject:set];
        }
    }
    //newWorkout.setsForExercises = setForExercises;
    NSLog(@"saving workout %@",newWorkout);
    [context save:&error];
    //save document
    /*NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"My Workout Planner"];
    [doc saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
        if (!success) {
            // Handle the error.
        }
        completion_block();
    }];*/

}
@end
