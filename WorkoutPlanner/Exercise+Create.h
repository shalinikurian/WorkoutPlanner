//
//  Exercise+Create.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/22/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "Exercise.h"

@interface Exercise (Create)
+ (Exercise *) createExerciseWithName:(NSString *) name
                withDescription:(NSString *)desc
                      withImage:(NSURL *)imageURL
                inManagedObjectContext:(NSManagedObjectContext *) context;
@end
