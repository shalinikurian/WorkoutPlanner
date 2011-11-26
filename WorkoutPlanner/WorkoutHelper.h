//
//  WorkoutHelper.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/22/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^completion_block_t)(UIManagedDocument *vacation);

@interface WorkoutHelper : NSObject
+ (void)openWorkoutPlannerusingBlock:(completion_block_t)completionBlock;
@end
