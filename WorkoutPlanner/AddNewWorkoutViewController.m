//
//  AddNewWorkoutViewController.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/25/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "AddNewWorkoutViewController.h"
#import "Exercise.h"
#import "Workout+Create.h"

@interface AddNewWorkoutViewController()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *workoutDetailsTable;
@property (strong, nonatomic) IBOutlet UITableView *addExerciseTable;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray * exercises;
@property (nonatomic,strong) NSMutableArray *setsForExercises;
@end
@implementation AddNewWorkoutViewController@synthesize database = _database;
@synthesize workoutDetailsTable = _workoutDetailsTable;
@synthesize addExerciseTable = _addExerciseTable;
@synthesize scrollView = _scrollView;
@synthesize exercises= _exercises;
@synthesize setsForExercises = _setsForExercises;
@synthesize workoutNameTextField = _workoutNameTextField;
@synthesize workoutDescription = _workoutDescription;

- (IBAction)saveWorkout:(id)sender {
    [Workout createAWorkoutWithName:self.workoutNameTextField.text 
                    withDescription:self.workoutDescription.text 
                      withExercises:self.exercises 
                           withSets:self.setsForExercises 
             inManagedObjectContext:self.database.managedObjectContext
     managedDocutment:self.database
                          callBlock:^{
                              NSLog(@"finished saving doc");
                              [self.navigationController popViewControllerAnimated:YES];
                          }];
}
- (IBAction)cancelWorkout:(id)sender {
    NSMutableArray *allControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    [self.navigationController popToViewController:[allControllers objectAtIndex:[allControllers count]-2] animated:YES];
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
editingExistingExercise:(bool)flag
{
    if (flag){//edit existing exercise
        NSInteger exercisePos = [self.exercises indexOfObject:exercise];
        [self.setsForExercises replaceObjectAtIndex:exercisePos withObject:set];
    } else {
        [self.setsForExercises addObject:set];
        [self.exercises addObject:exercise];
    }
    //reload to show exercises
}

#pragma mark - Table view delegate
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"edit exercise added"]){ //pre populate name , desc, sets
        [segue.destinationViewController setEditAddedExercise:YES];
         NSIndexPath *indexPath = [self.addExerciseTable indexPathForCell:sender];
        //get exercise
        Exercise * exercise = [self.exercises objectAtIndex:indexPath.row];
        [segue.destinationViewController setExerciseToAdd:exercise];
        [segue.destinationViewController setArrayOfSets:[self.setsForExercises objectAtIndex:indexPath.row]];
    }
    
    [segue.destinationViewController setDelegate:self];
    [segue.destinationViewController setDatabase:self.database];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0 && tableView == self.workoutDetailsTable) //name text field
    {
        [self.workoutNameTextField becomeFirstResponder];
    }else if(indexPath.section == 0 && indexPath.row == 1 && tableView == self.workoutDetailsTable)//description
    {
        [self.workoutDescription becomeFirstResponder];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection:(NSInteger)section  
{
    if (tableView == self.workoutDetailsTable) return 2;
    if (tableView == self.addExerciseTable) return [self.exercises count];
    return 0;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.workoutDetailsTable == tableView && indexPath.row  == 1) return 80;
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
    if (indexPath.row == 0 && self.workoutDetailsTable) //workoutname field
    {
        self.workoutNameTextField.placeholder = @"Workout Name";
        [cell addSubview:self.workoutNameTextField];
    }
    
    if (indexPath.row == 1 && self.workoutDetailsTable) //workoutdescription field
    {
        self.workoutDescription = [[UITextView alloc] initWithFrame:CGRectMake(20,10,cell.bounds.size.width-30,50)];
        self.workoutDescription.text = @"Workout Description";
        [cell addSubview:self.workoutDescription];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.workoutDetailsTable) {
        static NSString *CellIdentifier = @"workoutDetails";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.editing = NO;
        }
        cell = [self configureCellForWorkout:cell atIndexPath:indexPath];
        return cell;
    }
    if (tableView == self.addExerciseTable) {
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

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView 
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.addExerciseTable) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.exercises removeObjectAtIndex:indexPath.row];
    [tableView reloadData];
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
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.scrollView.delegate = self;
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width,
                                               self.view.frame.size.height)];
    [self.addExerciseTable reloadData];
    self.workoutDetailsTable.scrollEnabled = NO;
    //resign first responder
    [self.workoutNameTextField resignFirstResponder];
    [self.workoutDescription resignFirstResponder];
}

 -(void) viewDidLoad
{
    [self.workoutDetailsTable setDelegate:self];
    [self.workoutDetailsTable setDataSource:self];
    [self.addExerciseTable setDelegate:self];
    [self.addExerciseTable setDataSource:self];
}
- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setWorkoutDetailsTable:nil];
    [self setAddExerciseTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
