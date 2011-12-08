//
//  ImageForWorkout+createImage.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/7/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "ImageForWorkout+createImage.h"

@implementation ImageForWorkout (createImage)

+ (ImageForWorkout *) createAnImageWithURL:(NSString *)url inManagedObjectContext:(NSManagedObjectContext *)context
{
    ImageForWorkout *im = [NSEntityDescription insertNewObjectForEntityForName:@"ImageForWorkout"
                                        inManagedObjectContext:context];
    im.image_url = url;
    return im;

}
@end
