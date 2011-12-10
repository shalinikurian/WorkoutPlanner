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
    NSFetchRequest *requestExercise = [NSFetchRequest fetchRequestWithEntityName:@"ImageForWorkout"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"image_id" ascending:NO];
    requestExercise.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:requestExercise error:&error];
    int idForImage = 1;
    
    if([result count] > 0){//not the first image in the database
        ImageForWorkout * imageWithHighestId = [result objectAtIndex:0];
        idForImage = [imageWithHighestId.image_id intValue];
        idForImage = idForImage + 1;
    }

    
    ImageForWorkout *im = [NSEntityDescription insertNewObjectForEntityForName:@"ImageForWorkout"
                                        inManagedObjectContext:context];
    im.image_url = url;
    im.image_id = [NSNumber numberWithInt:idForImage];
    return im;

}

+ (int) imageIdAvailableForUseForNewImageInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *requestExercise = [NSFetchRequest fetchRequestWithEntityName:@"ImageForWorkout"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"image_id" ascending:NO];
    requestExercise.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:requestExercise error:&error];
    int idForImage = 1;
    if([result count] > 0){//not the first image in the database
        ImageForWorkout * imageWithHighestId = [result objectAtIndex:0];
        idForImage = [imageWithHighestId.image_id intValue];
        idForImage = idForImage + 1;
    }
    
    return idForImage;
    
}



@end
