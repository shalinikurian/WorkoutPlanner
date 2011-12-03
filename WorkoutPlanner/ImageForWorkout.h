//
//  ImageForWorkout.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/2/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ActualWorkout;

@interface ImageForWorkout : NSManagedObject

@property (nonatomic, retain) NSString * image_url;
@property (nonatomic, retain) ActualWorkout *belongsToWorkout;

@end
