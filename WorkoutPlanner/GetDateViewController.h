//
//  GetDateViewController.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/11/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GetDateViewController <NSObject>

- (void) datePicked :(NSDate *) date
startDate: (bool) startDatePicked;

@end

@interface GetDateViewController : UIViewController

@property (nonatomic, weak) id <GetDateViewController> delegate;
@property (nonatomic) bool startDate;
@end
