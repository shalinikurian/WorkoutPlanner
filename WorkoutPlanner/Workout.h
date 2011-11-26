//
//  Workout.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/25/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ActualWorkout, Exercise, ExerciseOrder, Set;

@interface Workout : NSManagedObject

@property (nonatomic, retain) NSNumber * workoutId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * workoutDescription;
@property (nonatomic, retain) NSSet *hasExercises;
@property (nonatomic, retain) NSSet *hasLoggedWorkouts;
@property (nonatomic, retain) NSSet *setsForExercises;
@property (nonatomic, retain) NSSet *hasExerciseOrder;
@end

@interface Workout (CoreDataGeneratedAccessors)

- (void)addHasExercisesObject:(Exercise *)value;
- (void)removeHasExercisesObject:(Exercise *)value;
- (void)addHasExercises:(NSSet *)values;
- (void)removeHasExercises:(NSSet *)values;

- (void)addHasLoggedWorkoutsObject:(ActualWorkout *)value;
- (void)removeHasLoggedWorkoutsObject:(ActualWorkout *)value;
- (void)addHasLoggedWorkouts:(NSSet *)values;
- (void)removeHasLoggedWorkouts:(NSSet *)values;

- (void)addSetsForExercisesObject:(Set *)value;
- (void)removeSetsForExercisesObject:(Set *)value;
- (void)addSetsForExercises:(NSSet *)values;
- (void)removeSetsForExercises:(NSSet *)values;

- (void)addHasExerciseOrderObject:(ExerciseOrder *)value;
- (void)removeHasExerciseOrderObject:(ExerciseOrder *)value;
- (void)addHasExerciseOrder:(NSSet *)values;
- (void)removeHasExerciseOrder:(NSSet *)values;

@end
