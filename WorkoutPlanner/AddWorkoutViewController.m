//
//  AddWorkoutViewController.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/22/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "AddWorkoutViewController.h"
#import "Workout+Create.h"
#import "WorkoutHelper.h"
#import "AddNewExerciseViewController.h"

@interface AddWorkoutViewController()
@property (nonatomic,strong) NSMutableArray * exercises;
@property (nonatomic,strong) NSMutableArray *setsForExercises;
@end

@implementation AddWorkoutViewController
@synthesize workoutNameTextField = _workoutNameTextField;
@synthesize workoutDescription = _workoutDescription;
@synthesize database = _database;
@synthesize exercises = _exercises;
@synthesize setsForExercises = _setsForExercises;

- (IBAction)saveButtonClicked:(UIBarButtonItem * )sender {
    //save to coredata
    [Workout createAWorkoutWithName:self.workoutNameTextField.text
     withDescription:self.workoutDescription.text
     withExercises:self.exercises 
     withSets:self.setsForExercises
     inManagedObjectContext:self.database.managedObjectContext];
    //pop after saving
     [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButtonClicked:(UIBarButtonItem *)sender {
    //pop back to previous view
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setWorkoutNameTextField:nil];
    [self setWorkoutDescription:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*[WorkoutHelper openWorkoutPlannerusingBlock:^(UIManagedDocument * workoutPlanner){
        NSLog(@"got context");
        self.database = workoutPlanner; 
    }];*/
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [self.view setNeedsDisplay];
    return YES;
}

- (NSMutableArray *) exercises{
    if(!_exercises){
        _exercises = [[NSMutableArray alloc]init ];
    }
    return _exercises;
}

- (NSMutableArray *) setsForExercises{
    if(!_setsForExercises){
        _setsForExercises = [[NSMutableArray alloc]init ];
    }
    return _setsForExercises;
}

- (void) addExercise:(Exercise *)exercise 
             withSet:(NSArray *)set
{
    [self.setsForExercises addObject:set];
    [self.exercises addObject:exercise];
    //reload to show exercises
}

#pragma mark - Table view delegate
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setDelegate:self];
    [segue.destinationViewController setDatabase:self.database];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 0 && indexPath.row == 0) //name text field
  {
      [self.workoutNameTextField becomeFirstResponder];
  }else if(indexPath.section == 0 && indexPath.row == 1)//description
  {
      [self.workoutDescription becomeFirstResponder];
  }
}

@end
