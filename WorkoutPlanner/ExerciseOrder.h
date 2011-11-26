//
//  ExerciseOrder.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/25/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Workout;

@interface ExerciseOrder : NSManagedObject

@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * exerciseId;
@property (nonatomic, retain) Workout *belongsToWorkout;

@end
