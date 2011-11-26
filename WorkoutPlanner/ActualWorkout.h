//
//  ActualWorkout.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/25/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Set, Workout;

@interface ActualWorkout : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Workout *belongsToWorkout;
@property (nonatomic, retain) NSSet *setForExercises;
@end

@interface ActualWorkout (CoreDataGeneratedAccessors)

- (void)addSetForExercisesObject:(Set *)value;
- (void)removeSetForExercisesObject:(Set *)value;
- (void)addSetForExercises:(NSSet *)values;
- (void)removeSetForExercises:(NSSet *)values;

@end
