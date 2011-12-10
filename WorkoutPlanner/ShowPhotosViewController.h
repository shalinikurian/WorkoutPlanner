//
//  ShowPhotosViewController.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/7/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import <UIKit/UIKit.h>

#define topOffset 10
#define thumbnailWidth 80
#define thumbnailHeight 80
#define noOfPhotosPerRow 3
#define tableCellHeight 100
#define SHADOW_COLOR_FOR_PHOTO [UIColor blackColor]
#define section_header_text_color [UIColor colorWithRed:0.1 green:0.2 blue:0.2 alpha:1.0]

@interface ShowPhotosViewController : UITableViewController
@property (nonatomic, strong) UIManagedDocument *database;
@property (nonatomic, strong) NSMutableArray *datesAndPhotos;
@end
