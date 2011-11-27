//
//  ShowExistingWorkout.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/26/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "ShowExistingWorkout.h"
#import "Exercise+Details.h"
#import "Set+Details.h"
#import "ShowExerciseInWorkout.h"

@interface ShowExistingWorkout ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *addExerciseButton;
@property (nonatomic) bool editWorkout;
@property (strong, nonatomic) IBOutlet UITableView *workOutDetails;
@property (strong, nonatomic) IBOutlet UITableView *exerciseList;
@property (strong, nonatomic)  UITextField *workoutNameTextField;
@property (strong, nonatomic)  UITextView *workoutDescription;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backAndCancelButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editAndDoneButton;
@property (strong, nonatomic) NSMutableArray *exercises;
@property (strong, nonatomic) NSMutableArray *setsForExercises;
@end
@implementation ShowExistingWorkout
@synthesize database = _database;
@synthesize addExerciseButton = _addExerciseButton;
@synthesize editWorkout = _editWorkout;
@synthesize workOutDetails = _workOutDetails;
@synthesize exerciseList = _exerciseList;
@synthesize workoutNameTextField = _workoutNameTextField;
@synthesize workoutDescription = _workoutDescription;
@synthesize backAndCancelButton = _backAndCancelButton;
@synthesize editAndDoneButton = _editAndDoneButton;
@synthesize workout = _workout;
@synthesize exercises = _exercises;
@synthesize setsForExercises = _setsForExercises;

- (NSMutableArray *) exercises {
    if (!_exercises)
    {
        _exercises = [[NSMutableArray alloc] init];
    }
    return _exercises;
}

- (NSMutableArray *) setsForExercises {
    if (!_setsForExercises)
    {
        _setsForExercises  = [[NSMutableArray alloc] init];
    }
    return _setsForExercises ;
}

- (IBAction)EditDoneButtonClicked:(UIBarButtonItem *)sender {
    if (self.editWorkout)//change button to have label edit
    {
        self.editWorkout = NO;
        self.backAndCancelButton.title = @"Back";
        self.addExerciseButton.titleLabel.text = @"Log a Workout";
        self.workoutNameTextField.enabled = NO;
        self.workoutDescription.editable =NO;
        //save the workout here
    }else { //change button to have have label done
        self.editWorkout = YES;
        self.workoutNameTextField.enabled = YES;
        self.workoutDescription.editable =YES;
        sender.title = @"Done";
        self.backAndCancelButton.title = @"Cancel";
        self.addExerciseButton.titleLabel.text = @"Add Exercise";
    }
    [self.workOutDetails reloadData];
}
- (IBAction)cancelBackButtonClicked:(UIBarButtonItem *)sender {
    if (self.editWorkout){ // acts as cancel button
        //abandon all changes
        self.editWorkout = NO;
        self.editAndDoneButton.title = @"Edit";
        sender.title = @"Back";
    }else { //acts as back button
        //pop controller
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self.workOutDetails reloadData];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"view exercise"]){ //destination is ShowExerciseInWorkout
        Exercise *exercise = (Exercise *) sender;
        [segue.destinationViewController setExercise:exercise];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0 && tableView == self.workOutDetails && self.editWorkout) //name text field
    {
        [self.workoutNameTextField becomeFirstResponder];
    }else if(indexPath.section == 0 && indexPath.row == 1 && tableView == self.workOutDetails && self.editWorkout)//description
    {
        [self.workoutDescription becomeFirstResponder];
    }
    
    if (tableView == self.exerciseList && !self.editWorkout){ //only show workoutlist
        [self performSegueWithIdentifier:@"view exercise" sender:[self.exercises objectAtIndex:indexPath.row]];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection:(NSInteger)section  
{
    if (tableView == self.workOutDetails) return 2;
    
    return [self.exercises count];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.workOutDetails == tableView && indexPath.row  == 1) return 80;
    return 50;
}

- (UITextField *) workoutNameTextField {
    if(!_workoutNameTextField){
        _workoutNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20,10,200,21)];
    }
    return _workoutNameTextField;
}

- (UITableViewCell *) configureCellForWorkout: (UITableViewCell *) cell
                                  atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && self.workOutDetails) //workoutname field
    {
        self.workoutNameTextField.text = self.workout.name;
        [cell addSubview:self.workoutNameTextField];
    }
    
    if (indexPath.row == 1 && self.workOutDetails) //workoutdescription field
    {
        self.workoutDescription = [[UITextView alloc] initWithFrame:CGRectMake(20,10,cell.bounds.size.width-30,50)];
        if (self.editWorkout) self.workoutDescription.editable = YES;
        else self.workoutDescription.editable = NO;
        self.workoutDescription.text = self.workout.workoutDescription;
        [cell addSubview:self.workoutDescription];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.workOutDetails) {
        static NSString *CellIdentifier = @"workoutDetails";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.editing = NO;
        }
        cell = [self configureCellForWorkout:cell atIndexPath:indexPath];
        return cell;
    }
    //list of exercises table
    if (tableView == self.exerciseList){
        static NSString *CellIdentifier = @"exercise";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        Exercise *exercise = [self.exercises objectAtIndex:indexPath.row];
        cell.textLabel.text = exercise.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d sets",[[self.setsForExercises objectAtIndex:indexPath.row] count]];
        return cell;
    }
    return nil;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.workoutNameTextField.enabled = NO;
    self.workoutDescription.editable = NO;
    self.workOutDetails.scrollEnabled = NO;
    //fetch exercises
    self.exercises= [[Exercise fetchExericesForWorkout:self.workout
                         inManagedObjectContext:self.database.managedObjectContext] mutableCopy];
    //fetch sets for exercises
    for (Exercise *exercise in self.exercises){
        NSMutableArray *sets = [[Set setsForExercise:exercise 
                                          andWorkout:self.workout 
                              inManagedObjectContext:self.database.managedObjectContext] mutableCopy];
        [self.setsForExercises addObject:sets];
    }
}


-(void) viewDidLoad
{
    [self.workOutDetails setDelegate:self];
    [self.workOutDetails setDataSource:self];
    [self.exerciseList setDelegate:self];
    [self.exerciseList setDataSource:self];
}
- (void)viewDidUnload
{
    [self setAddExerciseButton:nil];
    [self setWorkOutDetails:nil];
    [self setExerciseList:nil];
    [self setBackAndCancelButton:nil];
    [self setEditAndDoneButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
