//
//  ImageForWorkout+createImage.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/7/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "ImageForWorkout.h"

@interface ImageForWorkout (createImage)
+ (ImageForWorkout*) createAnImageWithURL:(NSString *) url
        inManagedObjectContext:(NSManagedObjectContext *) context;

+ (int) imageIdAvailableForUseForNewImageInManagedObjectContext : (NSManagedObjectContext *) context;
@end
