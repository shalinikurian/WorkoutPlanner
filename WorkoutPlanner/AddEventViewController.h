//
//  AddEventViewController.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/11/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddEventViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *startTime;
@property (strong, nonatomic) IBOutlet UITextField *endTime;
@property (strong, nonatomic) IBOutlet UITextField *eventName;

@property (strong, nonatomic) NSString *eventNameText;
@end
