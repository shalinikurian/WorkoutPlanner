//
//  AddWorkoutViewController.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/22/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNewExerciseViewController.h"

@interface AddWorkoutViewController : UITableViewController <AddNewExerciseViewController>
@property (strong, nonatomic) IBOutlet UITextField *workoutNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *workoutDescription;
@property (strong,nonatomic)UIManagedDocument *database;
@end
