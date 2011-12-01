//
//  LogAWorkoutViewController.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/29/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "LogAWorkoutViewController.h"
#import "Exercise.h"
@interface LogAWorkoutViewController()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *workoutDetails;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UITextView *workoutDescription;
@property (strong, nonatomic) UITextField *workoutNameTextField;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) NSDate *startDate;
@property (nonatomic) bool expandCell;
@property (strong, nonatomic) IBOutlet UITableView *exercisesTable;

@end
@implementation LogAWorkoutViewController
@synthesize workoutDetails = _workoutDetails;
@synthesize scrollView = _scrollView;
@synthesize workoutNameTextField = _workoutNameTextField;
@synthesize timerLabel = _timerLabel;
@synthesize workoutDescription = _workoutDescription;
@synthesize database = _database;
@synthesize workout = _workout;
@synthesize expandCell = _expandCell;
@synthesize exercisesTable = _exercisesTable;
@synthesize startDate = _startDate;
@synthesize exercises = _exercises;
@synthesize setsInExercises = _setsInExercises;


- (NSMutableArray*) exercises
{
    if (!_exercises){
        _exercises = [[NSMutableArray alloc] init];
    }
    return _exercises;
}

- (NSMutableArray*) setsInExercises
{
    if (!_setsInExercises){
        _setsInExercises = [[NSMutableArray alloc] init];
    }
    return _setsInExercises;
}

- (NSDate *) startDate
{
    if(!_startDate){
       _startDate = [NSDate date];
    }    
    return _startDate; 
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)saveLog:(UIBarButtonItem *)sender {
    //stop timer, get duration , other data and store in acutal workout
}

- (IBAction)cancelLogClicked:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.delegate = self;
    [self.workoutDetails setDelegate:self];
    self.workoutDetails.scrollEnabled = NO;
    self.workoutNameTextField.enabled = NO;
    self.workoutDescription.editable = NO;
    [self.workoutDetails setDataSource:self];
    [self.exercisesTable setDataSource:self];
    [self.exercisesTable setDelegate:self];
}

- (void) startTimer: (NSTimer *) timer
{
    //get current time 
    NSDate *currDateTime = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"hh:mm:ss"];
    NSTimeInterval diff = [currDateTime timeIntervalSinceDate:self.startDate];
    NSInteger ti = (NSInteger)diff;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    self.timerLabel.text =  [NSString stringWithFormat:@"Duration: %02i:%02i:%02i", hours, minutes, seconds];
    
}
- (void) setupTimerThread
{
    self.timerLabel.text = @"Duration: 00:00:00";
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0 
                                                      target:self 
                                                    selector:@selector(startTimer:) 
                                                    userInfo:nil 
                                                     repeats:YES];
  
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
    [runLoop run];
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(setupTimerThread) object:nil];
    [thread start];
}
- (void)viewDidUnload
{
    [self setWorkoutDetails:nil];
    [self setScrollView:nil];
    [self setTimerLabel:nil];
    [self setExercisesTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.workoutDetails) return 1;
    if (tableView == self.exercisesTable) return [self.exercises count];
    return 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.workoutDetails) return 1; 
    if (tableView == self.exercisesTable) {
        return [[self.setsInExercises objectAtIndex:section] count];
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.workoutDetails == tableView && self.expandCell) return 100;
    return 35;
}

- (UITextField *) workoutNameTextField {
    if(!_workoutNameTextField){
        _workoutNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20,10,200,21)];
    }
    return _workoutNameTextField;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.workoutDetails){
        //show date for workout log
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"MM/dd/yyyy"];
        return [dateFormat stringFromDate:date];  
    }
    Exercise *exercise = (Exercise *)[self.exercises objectAtIndex:section];
    return exercise.name;
}
- (UITableViewCell *) configureCellForWorkout: (UITableViewCell *) cell
                                   atIndexPath:(NSIndexPath *)indexPath{
    self.workoutNameTextField.text = self.workout.name;
    [cell addSubview:self.workoutNameTextField];
    
    if (self.expandCell){
        self.workoutDescription = [[UITextView alloc] initWithFrame:CGRectMake(20,40,cell.bounds.size.width-30,50)];
        self.workoutDescription.text = self.workout.workoutDescription;
        [cell addSubview:self.workoutDescription];
    } else {
        [self.workoutDescription removeFromSuperview];
    }
    return cell;

    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.workoutDetails){
        static NSString *CellIdentifier = @"workout details";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.editing = NO;
        }
        
        
        cell = [self configureCellForWorkout:cell atIndexPath:indexPath];
        return cell;

    }
    static NSString *CellIdentifier = @"exercise in log";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.editing = NO;
    }
    NSMutableArray *sets = [[self.setsInExercises objectAtIndex:indexPath.section] mutableCopy];
    NSDictionary *set = (NSDictionary *) [sets objectAtIndex:indexPath.row];
    cell.detailTextLabel.text =  cell.textLabel.text = [NSString stringWithFormat:@"%@ reps X %@ lb", [set objectForKey:@"reps"],[set objectForKey:@"weight"]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.workoutDetails){
        self.expandCell = !self.expandCell;
        NSArray *array = [NSArray arrayWithObject: indexPath];
        [self.workoutDetails reloadRowsAtIndexPaths: array
                                  withRowAnimation: UITableViewRowAnimationAutomatic];
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
