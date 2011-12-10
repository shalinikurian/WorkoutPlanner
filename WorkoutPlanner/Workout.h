//
//  Workout.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/9/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ActualWorkout, Exercise, Set;

@interface Workout : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * workoutDescription;
@property (nonatomic, retain) NSNumber * workoutId;
@property (nonatomic, retain) NSOrderedSet *hasExercises;
@property (nonatomic, retain) NSSet *hasLoggedWorkouts;
@property (nonatomic, retain) NSOrderedSet *setsForExercises;
@end

@interface Workout (CoreDataGeneratedAccessors)

- (void)insertObject:(Exercise *)value inHasExercisesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromHasExercisesAtIndex:(NSUInteger)idx;
- (void)insertHasExercises:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeHasExercisesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInHasExercisesAtIndex:(NSUInteger)idx withObject:(Exercise *)value;
- (void)replaceHasExercisesAtIndexes:(NSIndexSet *)indexes withHasExercises:(NSArray *)values;
- (void)addHasExercisesObject:(Exercise *)value;
- (void)removeHasExercisesObject:(Exercise *)value;
- (void)addHasExercises:(NSOrderedSet *)values;
- (void)removeHasExercises:(NSOrderedSet *)values;
- (void)addHasLoggedWorkoutsObject:(ActualWorkout *)value;
- (void)removeHasLoggedWorkoutsObject:(ActualWorkout *)value;
- (void)addHasLoggedWorkouts:(NSSet *)values;
- (void)removeHasLoggedWorkouts:(NSSet *)values;

- (void)insertObject:(Set *)value inSetsForExercisesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSetsForExercisesAtIndex:(NSUInteger)idx;
- (void)insertSetsForExercises:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSetsForExercisesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSetsForExercisesAtIndex:(NSUInteger)idx withObject:(Set *)value;
- (void)replaceSetsForExercisesAtIndexes:(NSIndexSet *)indexes withSetsForExercises:(NSArray *)values;
- (void)addSetsForExercisesObject:(Set *)value;
- (void)removeSetsForExercisesObject:(Set *)value;
- (void)addSetsForExercises:(NSOrderedSet *)values;
- (void)removeSetsForExercises:(NSOrderedSet *)values;
@end
