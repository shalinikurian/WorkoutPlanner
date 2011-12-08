//
//  ImageForWorkout+DeleteImage.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/8/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "ImageForWorkout.h"

@interface ImageForWorkout (DeleteImage)

+ (void) deleteImageWithURL: (NSString *) url
inManagedObjectContext : (NSManagedObjectContext *) context;
@end
