//
//  ActualWorkout+Performance.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/5/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "ActualWorkout.h"
#import "Exercise.h"
@interface ActualWorkout (Performance)
+ (NSArray *) perfomanceOfExercise: (Exercise *) exercise
                           forDays:(NSInteger ) days
                            toDate:(NSDate *) date
inManagedObjectContext:(NSManagedObjectContext *)context;
@end
