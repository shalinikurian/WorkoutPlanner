//
//  Exercise.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/30/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Workout;

@interface Exercise : NSManagedObject

@property (nonatomic, retain) NSString * exerciseDescription;
@property (nonatomic, retain) NSNumber * exerciseId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *belongsToWorkout;
@end

@interface Exercise (CoreDataGeneratedAccessors)

- (void)addBelongsToWorkoutObject:(Workout *)value;
- (void)removeBelongsToWorkoutObject:(Workout *)value;
- (void)addBelongsToWorkout:(NSSet *)values;
- (void)removeBelongsToWorkout:(NSSet *)values;

@end
