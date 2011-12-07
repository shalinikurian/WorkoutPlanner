//
//  ActualWorkout+Create.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/2/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "ActualWorkout+Create.h"
#import "Set+Create.h"
#import "ImageForWorkout.h"

@implementation ActualWorkout (Create)
+ (NSDate *) getPreviousDayFromDate: (NSDate *) currDate
{
    NSDate *prevDate;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];  
    [components setDay:-1];
    prevDate  = [cal dateByAddingComponents:components toDate:currDate options:0];
    return prevDate;
}

+ (void) fakeData:(ActualWorkout *) aw
    withSetsForExercises:(NSArray *)setsForExercises 
        forExercises:(NSArray *) exercises
    withDurationInSeconds:(NSInteger )duration 
            withDate:(NSDate *)date 
        withImages:(NSArray *)imageUrls
    inManagedObjectContext:(NSManagedObjectContext *)context{
    
    
    NSDate *currDate = aw.date;
    //enter 6 workouts for the other days
    int repInc = 2;
    int wtInc = 5;
    int cnt = 1;
    NSError *error;
    for (int i = 0 ;i < 30;i++){
        ActualWorkout *fakeLog = [NSEntityDescription insertNewObjectForEntityForName:@"ActualWorkout"
                                                               inManagedObjectContext:context];
        fakeLog.date = [[ActualWorkout class] getPreviousDayFromDate:currDate];
        currDate = fakeLog.date;

        //add sets for exercises
        for (int i = 0 ;i<[setsForExercises count];i++){
            //set is a nsarray of set for exercise at same position in exercises array
            NSArray *setsPerExercise = (NSArray*)[setsForExercises objectAtIndex:i];
            for (int j=0;j<[setsPerExercise count];j++){
                NSDictionary *oneSet = (NSDictionary *) [setsPerExercise objectAtIndex:j];
                NSInteger reps,weight;
                if ([oneSet objectForKey:@"reps"]){
                    reps = [[oneSet objectForKey:@"reps"] intValue] + (repInc *cnt);
                }
                if ([oneSet objectForKey:@"weight"]){
                    weight = [[oneSet objectForKey:@"weight"] intValue] + (wtInc *cnt);
                }
                Set *set = [Set createASetforExercise:[exercises objectAtIndex:i] 
                                             withReps:reps
                                           withWeight:weight
                                            withOrder:j
                               inManagedObjectContext:context];
                set.belongsToAcutalWorkout = fakeLog;
            }
        }
        cnt ++;
        fakeLog.belongsToWorkout = aw.belongsToWorkout;
        NSLog(@"entering workout %@",fakeLog);
        [context save:&error];
    }
    
}
+ (void) createLogForWorkout:(Workout *)workout 
        withSetsForExercises:(NSArray *)setsForExercises 
                forExercises:(NSArray *) exercises
       withDurationInSeconds:(NSInteger )duration 
                    withDate:(NSDate *)date 
                  withImages:(NSArray *)imageUrls
      inManagedObjectContext:(NSManagedObjectContext *)context
{
    if (context) {
        NSLog(@"i have context in actual workout");
    }else {
        NSLog(@"i dont have context in actual workout");
    }
    ActualWorkout * aw = nil;
    NSError *error = nil;
    //add the workout to the database
    aw = [NSEntityDescription insertNewObjectForEntityForName:@"ActualWorkout"
                                               inManagedObjectContext:context];
    //add date of log
    aw.date = date;
    
    //add duration in seconds
    aw.duration = [NSNumber numberWithInt: duration];
    
    //add sets for exercises
    for (int i = 0 ;i<[setsForExercises count];i++){
        //set is a nsarray of set for exercise at same position in exercises array
        NSArray *setsPerExercise = (NSArray*)[setsForExercises objectAtIndex:i];
        for (int j=0;j<[setsPerExercise count];j++){
            NSDictionary *oneSet = (NSDictionary *) [setsPerExercise objectAtIndex:j];
            NSInteger reps,weight;
            if ([oneSet objectForKey:@"reps"]){
                reps = [[oneSet objectForKey:@"reps"] intValue];
            }
            if ([oneSet objectForKey:@"weight"]){
                weight = [[oneSet objectForKey:@"weight"] intValue];
            }
            Set *set = [Set createASetforExercise:[exercises objectAtIndex:i] 
                                         withReps:reps
                                       withWeight:weight
                                        withOrder:j
                           inManagedObjectContext:context];
            set.belongsToAcutalWorkout = aw;
        }
    }
    aw.belongsToWorkout = workout;
    //add images to actual workout
    for (NSString *imagePath in imageUrls) {
        ImageForWorkout *im = [NSEntityDescription insertNewObjectForEntityForName:@"ImageForWorkout" inManagedObjectContext:context];
        im.belongsToWorkout = aw;
    }
    
    [context save:&error];
    //remove later TODO
    //generate fake data
    [[ActualWorkout class] fakeData:aw withSetsForExercises:setsForExercises forExercises:exercises withDurationInSeconds:duration withDate:date withImages:nil inManagedObjectContext:context];
    
    
    //check creation of actual workout
    /*NSFetchRequest *requestExercise = [NSFetchRequest fetchRequestWithEntityName:@"ActualWorkout"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    requestExercise.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:requestExercise error:&error];
    NSLog(@"workout %@",[result lastObject]);*/
    
}
@end
