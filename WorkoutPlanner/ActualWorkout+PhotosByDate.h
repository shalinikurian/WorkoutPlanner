//
//  ActualWorkout+PhotosByDate.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/7/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "ActualWorkout.h"

@interface ActualWorkout (PhotosByDate)
+ (NSArray *) photosByDateinManagedObjectContext:(NSManagedObjectContext *)context;
@end
