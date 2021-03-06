//
//  AddNewExerciseViewController.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/24/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exercise+Create.h"

@class AddingNewExerciseViewController;

@protocol AddNewExerciseViewController <NSObject>
- (void) addExercise:(Exercise *)exercise
             withSet:(NSArray*) set
editingExistingExercise:(bool) flag;
@end

@interface AddNewExerciseViewController : UIViewController <UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, weak) id<AddNewExerciseViewController>delegate;
@property (strong, nonatomic) UITextField * exerciseName;
@property (strong, nonatomic) UITextView *exerciseDescription;
@property (nonatomic) bool editAddedExercise;
@property (strong, nonatomic) Exercise * exerciseToAdd;
@property (nonatomic, strong) NSMutableArray *arrayOfSets;
@end
