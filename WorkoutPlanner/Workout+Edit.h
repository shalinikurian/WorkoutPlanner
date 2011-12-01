//
//  Workout+Edit.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/28/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "Workout.h"

@interface Workout (Edit)

+ (void) editAWorkout: (Workout *) workout
          withNewName:(NSString *) name
                withNewDescription:(NSString *)desc 
                  withNewExercises:(NSArray *)exercises 
                       withNewSets:(NSArray *)sets 
         inManagedObjectContext:(NSManagedObjectContext *)context;
@end
