//
//  ActualWorkout.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/9/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ImageForWorkout, Set, Workout;

@interface ActualWorkout : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) Workout *belongsToWorkout;
@property (nonatomic, retain) NSOrderedSet *hasImage;
@property (nonatomic, retain) NSSet *setForExercises;
@end

@interface ActualWorkout (CoreDataGeneratedAccessors)

- (void)insertObject:(ImageForWorkout *)value inHasImageAtIndex:(NSUInteger)idx;
- (void)removeObjectFromHasImageAtIndex:(NSUInteger)idx;
- (void)insertHasImage:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeHasImageAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInHasImageAtIndex:(NSUInteger)idx withObject:(ImageForWorkout *)value;
- (void)replaceHasImageAtIndexes:(NSIndexSet *)indexes withHasImage:(NSArray *)values;
- (void)addHasImageObject:(ImageForWorkout *)value;
- (void)removeHasImageObject:(ImageForWorkout *)value;
- (void)addHasImage:(NSOrderedSet *)values;
- (void)removeHasImage:(NSOrderedSet *)values;
- (void)addSetForExercisesObject:(Set *)value;
- (void)removeSetForExercisesObject:(Set *)value;
- (void)addSetForExercises:(NSSet *)values;
- (void)removeSetForExercises:(NSSet *)values;

@end
