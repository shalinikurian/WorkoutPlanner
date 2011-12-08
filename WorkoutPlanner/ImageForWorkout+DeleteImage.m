//
//  ImageForWorkout+DeleteImage.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/8/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "ImageForWorkout+DeleteImage.h"

@implementation ImageForWorkout (DeleteImage)

+ (void) deleteImageWithURL:(NSString *)url
     inManagedObjectContext:(NSManagedObjectContext *)context
{
    ImageForWorkout  *obj = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ImageForWorkout"];
    request.predicate = [NSPredicate predicateWithFormat:@"url = %@",url];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if(!matches ||([matches count] >1)){
        NSLog(@"error in image for workout");
        //error
    }else if ([matches count] == 1) {
        //delete image
        obj =[matches lastObject];
        [context deleteObject:obj];
        [context save:&error];
    }

}
@end
