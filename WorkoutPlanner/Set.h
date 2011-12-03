//
//  Set.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/2/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ActualWorkout, Workout;

@interface Set : NSManagedObject

@property (nonatomic, retain) NSNumber * exerciseId;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * rep;
@property (nonatomic, retain) NSNumber * setId;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) ActualWorkout *belongsToAcutalWorkout;
@property (nonatomic, retain) Workout *belongsToWorkout;

@end
