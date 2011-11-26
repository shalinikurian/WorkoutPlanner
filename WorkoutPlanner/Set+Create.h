//
//  Set+Create.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/25/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "Set.h"
#import "Exercise.h"

@interface Set (Create)

+ (Set*) createASetforExercise:(Exercise*) exercise
                      withReps:(NSInteger) reps
                    withWeight:(NSInteger) weight
                     withOrder:(NSInteger) order
         inManagedObjectContext:(NSManagedObjectContext *) context;
@end
