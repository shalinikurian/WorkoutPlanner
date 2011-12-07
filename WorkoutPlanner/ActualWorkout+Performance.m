//
//  ActualWorkout+Performance.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/5/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "ActualWorkout+Performance.h"
#import "Workout.h"
#import "Set.h"


@implementation ActualWorkout (Performance)

+ (NSDate *) getPreviousDayFromDate: (NSDate *) currDate{
    NSDate *prevDate;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];  
    [components setDay:-1];
    prevDate  = [cal dateByAddingComponents:components toDate:currDate options:0];
    return prevDate;
}

+ (NSArray *) perfomanceOfExercise: (Exercise *) exercise
                           forDays:(NSInteger ) totalDays
                            toDate:(NSDate *) date
inManagedObjectContext:(NSManagedObjectContext *)context{
    

    NSMutableArray *performanceByDate = [[NSMutableArray alloc] init];
    NSError *error = nil;
        
    //get logs for last week or month
    for (int i = 0; i < totalDays;i++) {
        NSDate *prevDate = [[ActualWorkout class] getPreviousDayFromDate:date];
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ActualWorkout"];
        request.predicate = [NSPredicate predicateWithFormat:@"%@ IN setForExercises.exerciseId and (date >= %@) AND (date <= %@)",exercise.exerciseId,prevDate,date];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
        request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        //change prevDate and date to get an earlier date
        NSArray *matches = [context executeFetchRequest:request error:&error];
        float totalWeight=0, totalReps=0;
        if ([matches count] > 0){ //process log per day
            //get sets corresponding to this exercise 
            for (ActualWorkout * aw in matches){
                NSSet *sets = aw.setForExercises;
                for (Set *set in sets){
                    //if reps is 0 skip the set , if sets belong to different exercise , skip the set
                    if (set.rep !=0 && set.exerciseId == exercise.exerciseId){
                        totalWeight += [set.weight floatValue];
                        totalReps += [set.rep  floatValue];
                    }
                }//end of processing sets for a log
            }//end of processing logs for a day
            //append to performanceByDate array
            float wtPerRep = totalWeight / totalReps;
            NSDictionary *performancePerDay = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [NSNumber numberWithFloat:wtPerRep], @"weightPerRep",
                                                date,@"forDate",nil];
            //append to nsarray
            [performanceByDate addObject:performancePerDay];
        }
        date = prevDate;
    }//end of processing all workouts for all days
    
    
    NSLog(@"performance %@",performanceByDate);
    return performanceByDate;

}

@end
