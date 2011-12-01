//
//  Workout+Edit.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/28/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "Workout+Edit.h"
#import "Set+Create.h"

@implementation Workout (Edit)

+ (void) editAWorkout:(Workout *)workout 
          withNewName:(NSString *)name 
   withNewDescription:(NSString *)desc 
     withNewExercises:(NSArray *)exercises 
          withNewSets:(NSArray *)sets 
inManagedObjectContext:(NSManagedObjectContext *)context
{
    Workout *obj = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Workout"];
    request.predicate = [NSPredicate predicateWithFormat:@"workoutId = %@",workout.workoutId];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if ([name length] == 0){
        name=@"Unknown";
    }
    if ([desc length] == 0){
        desc=@"Unknown";
    }

    if(!matches ||([matches count] >1)){
        NSLog(@"error in workout");
        //error
    }else if ([matches count] == 1) {
        //edit workout
        obj =[matches lastObject];
        //delete sets for exercises , exercise order 
        obj.name = name;
        obj.workoutDescription = desc;
        obj.hasExercises = [NSOrderedSet orderedSetWithArray:exercises];   
        //delete older sets
        NSOrderedSet *exisitingSets = obj.setsForExercises;
        for (Set * set in exisitingSets) [context deleteObject:set];
        //store exercisesets
        NSMutableOrderedSet *setForExercises =[[NSMutableOrderedSet alloc] init];
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
                set.belongsToWorkout = obj;
                //add set to setForExercises
                [setForExercises addObject:set];
            }
        }
        obj.setsForExercises = setForExercises;
        [context save:&error];
    }

}
@end
