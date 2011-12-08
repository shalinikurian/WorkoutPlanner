//
//  PhotoButtonInCell.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/7/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoButtonInCell : UIButton

@property (nonatomic, weak) NSIndexPath *indexPath;
@property (nonatomic) int position;
@property (nonatomic, weak) NSString *url;

@end
