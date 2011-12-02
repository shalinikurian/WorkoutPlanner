//
//  GetSetForExerciseFromUserViewController.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/1/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GetSetForExerciseFromUserViewController <NSObject>
- (void) weightForExercise: (NSInteger) weight
            repForExercise: (NSInteger) rep
                  forSetNo: (NSInteger) setNo
             forExerciseNo: (NSInteger) exerciseNo;
@end
@interface GetSetForExerciseFromUserViewController : UIViewController
@property (nonatomic, weak) id<GetSetForExerciseFromUserViewController>delegate;
@property (nonatomic) NSInteger setNo;
@property (nonatomic) NSInteger exerciseNo;
@end
