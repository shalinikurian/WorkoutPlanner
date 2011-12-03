//
//  Exercise+Create.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/22/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "Exercise.h"

typedef void (^completion_block_exercise)(Exercise *exercise);
@interface Exercise (Create)
+ (void) createExerciseWithName:(NSString *) name
                withDescription:(NSString *)desc
                      withImage:(NSURL *)imageURL
                inManagedObjectContext:(NSManagedObjectContext *) context
                      managedDocument: (UIManagedDocument *) doc
                            callBlock: (completion_block_exercise) completion_block;
@end
