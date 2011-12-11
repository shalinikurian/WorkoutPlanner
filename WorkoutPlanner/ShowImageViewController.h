//
//  ShowImageViewController.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/8/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ShowImageViewController <NSObject>
- (void) deletePictureWithURL :(NSString *) url
atIndexPath: (NSIndexPath *)indexPath
atPosition:(int) position;
@end

@interface ShowImageViewController : UIViewController
@property (nonatomic, weak) id <ShowImageViewController> delegate;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) UIManagedDocument *database;
@property (nonatomic) int position;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
