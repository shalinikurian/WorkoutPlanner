//
//  ShowExistingExercisesViewController.h
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/24/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Exercise.h"

@protocol ShowExistingExercisesViewControllerProtocol <NSObject>

- (void) setExercise: (Exercise*) exercise;

@end
@interface ShowExistingExercisesViewController : CoreDataTableViewController<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong) UIManagedDocument *database;
@property (nonatomic, weak) id <ShowExistingExercisesViewControllerProtocol> delegate;
@end
