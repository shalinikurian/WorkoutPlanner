//
//  Exercise+Details.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/26/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "Exercise.h"

@interface Exercise (Details)
+ (NSArray *) fetchExericesForWorkout : (Workout *) workout
              inManagedObjectContext: (NSManagedObjectContext *) context;
@end
