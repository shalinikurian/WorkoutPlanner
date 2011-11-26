//
//  AddNewWorkoutViewController.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/25/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNewExerciseViewController.h"
@interface AddNewWorkoutViewController : UIViewController <AddNewExerciseViewController>
@property (nonatomic, strong) UIManagedDocument *database;
@property (strong, nonatomic)  UITextField *workoutNameTextField;
@property (strong, nonatomic)  UITextView *workoutDescription;
@end
