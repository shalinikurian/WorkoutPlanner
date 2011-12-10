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
#import <QuartzCore/QuartzCore.h>

@interface AddNewWorkoutViewController()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UITextViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *addExerciseButton;
@property (strong, nonatomic) IBOutlet UITableView *workoutDetailsTable;
@property (strong, nonatomic) IBOutlet UITableView *addExerciseTable;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray * exercises;
@property (nonatomic,strong) NSMutableArray *setsForExercises;
@property (nonatomic) bool notPlaceHolder;
@end
@implementation AddNewWorkoutViewController@synthesize database = _database;
@synthesize addExerciseButton = _addExerciseButton;
@synthesize workoutDetailsTable = _workoutDetailsTable;
@synthesize addExerciseTable = _addExerciseTable;
@synthesize scrollView = _scrollView;
@synthesize exercises= _exercises;
@synthesize setsForExercises = _setsForExercises;
@synthesize workoutNameTextField = _workoutNameTextField;
@synthesize workoutDescription = _workoutDescription;
@synthesize notPlaceHolder = _notPlaceHolder;

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
    [self.navigationController popViewControllerAnimated:YES];
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
    NSLog(@"going to add exercise %@ with set %@",exercise, set);
    if (flag){//edit existing exercise
        NSInteger exercisePos = [self.exercises indexOfObject:exercise];
        [self.setsForExercises replaceObjectAtIndex:exercisePos withObject:set];
    } else {
        [self.setsForExercises addObject:set];
        [self.exercises addObject:exercise];
    }
    //reload to show exercises
}

- (void) textViewDidChange:(UITextView *)textView   
{
    if (!self.notPlaceHolder) {
        self.notPlaceHolder = YES;
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
    }
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
        self.workoutNameTextField.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        [cell addSubview:self.workoutNameTextField];
    }
    
    if (indexPath.row == 1 && self.workoutDetailsTable) //workoutdescription field
    {
        self.workoutDescription = [[UITextView alloc] initWithFrame:CGRectMake(10,10,cell.bounds.size.width-30,50)];
        self.workoutDescription.delegate = self;
        self.workoutDescription.text = @" Workout Description";
        self.workoutDescription.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        self.workoutDescription.textColor = [UIColor lightGrayColor];
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
        cell.backgroundColor = [UIColor whiteColor];
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view.subviews isKindOfClass:[UITextView class]]) return NO;
    if ([touch.view.subviews isKindOfClass:[UITextField class]]) return NO;
    
    return YES;
}

- (void) singleTap : (UIGestureRecognizer *) gesture
{
    //resign first responder
    [self.workoutNameTextField resignFirstResponder];
    [self.workoutDescription resignFirstResponder];
    
    //change text color
    self.workoutNameTextField.textColor = [UIColor lightGrayColor];
    self.workoutDescription.textColor = [UIColor lightGrayColor];
    
}

- (void) styleAddExerciseButton
{
    //self.addExerciseButton
    CALayer *layer = [self.addExerciseButton layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:8.0f];
    [layer setBorderWidth:0.5f];
    [layer setBorderColor:[[UIColor blackColor] CGColor]];
 
    self.addExerciseButton.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"redGloss.png"]];
    self.addExerciseButton.titleLabel.textColor = [UIColor whiteColor];

}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.scrollView.delegate = self;
 
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width,
                                               self.view.frame.size.height)];
    
    //style add exercise button
    [self styleAddExerciseButton];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.2 alpha:1.0];
    
    //add tap
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                                 action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    
    [self.addExerciseTable reloadData];
    self.workoutDetailsTable.scrollEnabled = NO;
    //resign first responder
    [self.workoutNameTextField resignFirstResponder];
    [self.workoutDescription resignFirstResponder];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"texture.png"]];
    self.addExerciseTable.backgroundColor = [UIColor clearColor];
    self.workoutDetailsTable.backgroundColor = [UIColor clearColor];
}

 -(void) viewDidLoad
{
    [self.workoutDetailsTable setDelegate:self];
    [self.workoutDetailsTable setDataSource:self];
    [self.addExerciseTable setDelegate:self];
    [self.addExerciseTable setDataSource:self];
    
    self.workoutDescription.delegate = self;
    self.workoutNameTextField.delegate = self;
}
- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setWorkoutDetailsTable:nil];
    [self setAddExerciseTable:nil];
    [self setAddExerciseButton:nil];
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
