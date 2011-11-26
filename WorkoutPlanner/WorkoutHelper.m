//
//  WorkoutHelper.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/22/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "WorkoutHelper.h"

static UIManagedDocument* workoutPlanner = nil;


@implementation WorkoutHelper
+(UIManagedDocument *) workoutPlannerGet
{
    if (!workoutPlanner) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"My Workout Planner"];
        workoutPlanner = [[UIManagedDocument alloc] initWithFileURL:url];
    } 
    return workoutPlanner;
}

+ (void)openWorkoutPlannerusingBlock:(completion_block_t)completionBlock
{
    if (!workoutPlanner) {
        [WorkoutHelper workoutPlannerGet];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[workoutPlanner.fileURL path]]) {
        // does not exist on disk, so create it
        [workoutPlanner saveToURL:workoutPlanner.fileURL forSaveOperation:UIDocumentSaveForCreating 
            completionHandler:^(BOOL success) {
                NSLog(@"created new");
            completionBlock(workoutPlanner);
        }];
    } else if (workoutPlanner.documentState == UIDocumentStateClosed) {
        // exists on disk, but we need to open it;
        [workoutPlanner openWithCompletionHandler:^(BOOL success) {
            NSLog(@"got document");
            completionBlock(workoutPlanner);
        }];
    } else if (workoutPlanner.documentState == UIDocumentStateNormal) {
        NSLog(@"open");
        completionBlock(workoutPlanner);
    }
    

}
@end
