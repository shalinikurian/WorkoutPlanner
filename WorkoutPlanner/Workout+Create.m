//
//  Workout+Create.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/22/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "Workout+Create.h"
#import "Set+Create.h"
#import "ExerciseOrder.h"

@implementation Workout (Create)

+ (void) createAWorkoutWithName:(NSString *)name 
                withDescription:(NSString *)desc 
                  withExercises:(NSArray *)exercises 
                       withSets:(NSArray *)sets 
         inManagedObjectContext:(NSManagedObjectContext *)context{
    
   NSFetchRequest *requestWorkout = [NSFetchRequest fetchRequestWithEntityName:@"Workout"];
   NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"workoutId" ascending:NO];
   requestWorkout.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
   NSError *error = nil;
   NSArray *result = [context executeFetchRequest:requestWorkout error:&error];
   int idForWorkout = 1;
   Workout *newWorkout = nil;
   NSLog(@"all workout count %d",[result count]);

   if([result count] > 0){//not the first workout in the database
        Workout * workoutWithHighestId = [result objectAtIndex:0];
        idForWorkout = [workoutWithHighestId.workoutId intValue];
        idForWorkout = idForWorkout + 1;
   }
    //add the workout to the database
    if ([name isEqualToString:@""]){
        name=@"Unknown";
    }
    if ([desc isEqualToString:@""]){
        desc=@"Unknown";
    }
    newWorkout = [NSEntityDescription insertNewObjectForEntityForName:@"Workout"
                                                inManagedObjectContext:context];
    newWorkout.workoutId = [NSNumber numberWithInt:idForWorkout];
    newWorkout.name = name;
    newWorkout.workoutDescription = desc;
    newWorkout.hasExercises = [NSSet setWithArray:exercises];
    
    //set order for exercises
    NSMutableSet *exerciseOrders = [[NSMutableSet alloc] init];
    for (int order=0; order< [exercises count]; order++){
        ExerciseOrder *exerciseOrder = [NSEntityDescription insertNewObjectForEntityForName:@"ExerciseOrder"
                                                                     inManagedObjectContext:context];
        Exercise *exercise = (Exercise*)[exercises objectAtIndex:order];
        exerciseOrder.order = [NSNumber numberWithInt:order];
        exerciseOrder.exerciseId = exercise.exerciseId;
        [exerciseOrders addObject:exerciseOrder];
    }
    newWorkout.hasExerciseOrder = exerciseOrders;
    
    //store exercisesets
    NSMutableSet *setForExercises =[[NSMutableSet alloc] init];
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
    newWorkout.setsForExercises = setForExercises;
    NSLog(@"saving workout %@",newWorkout);
    [context save:&error];

}
@end
