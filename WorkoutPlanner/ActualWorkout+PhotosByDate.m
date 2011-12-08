//
//  ActualWorkout+PhotosByDate.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/7/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "ActualWorkout+PhotosByDate.h"
#import "ImageForWorkout.h"

@implementation ActualWorkout (PhotosByDate)
+ (NSArray *) photosByDateinManagedObjectContext:(NSManagedObjectContext *)context{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ActualWorkout"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    ActualWorkout *aw;
    NSMutableDictionary *photosByDate = [[NSMutableDictionary alloc] init];
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    if ([matches count] > 0 ){
        aw = [matches objectAtIndex:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM YYYY"];
        //loop over all logs and collect photos
        for ( aw in matches) {
            NSOrderedSet *images = aw.hasImage;
            //get date for current workout
            NSString *currDate = [dateFormatter stringFromDate:aw.date];
            if ([images count] > 0){
                //loop over all images
                for ( ImageForWorkout *im in images){
                    NSMutableArray * photos;
                    if (![photosByDate objectForKey:currDate]){//new month and year
                        photos = [[NSMutableArray alloc] init];
                    }else {
                        photos = (NSMutableArray *) [photosByDate objectForKey:currDate];
                    }
                    if (![dates containsObject:currDate]){
                        [dates addObject:currDate];
                    }
                    [photos addObject:im];
                    [photosByDate setObject:photos forKey:currDate];
                }
            }
        }
        
    }
    NSMutableArray *photosForDate = [[NSMutableArray alloc] init];
    for (int i = 0; i< [dates count]; i ++){
        NSDictionary *dict = [NSDictionary dictionaryWithObject:[photosByDate objectForKey:[dates objectAtIndex:i]] forKey:[dates objectAtIndex:i]];
        [photosForDate addObject:dict];
    }
    NSLog(@"photos %@",photosForDate);
    return [photosForDate copy];
}
@end
