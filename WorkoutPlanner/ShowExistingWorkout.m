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
#import "Workout+Edit.h"
#import "ShowExerciseInWorkout.h"
#import "AddNewExerciseViewController.h"
#import "LogAWorkoutViewController.h"
#import "MessageUI/MessageUI.h"
#import <QuartzCore/QuartzCore.h>
#import "AddEventViewController.h"

@interface ShowExistingWorkout ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate,MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate ,ShowExistingExercisesInWorkoutProtocol, AddNewExerciseViewController>
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
@property (nonatomic) bool notPlaceHolder;
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
@synthesize notPlaceHolder = _notPlaceHolder;

- (void) textViewDidChange:(UITextView *)textView   
{
    if (!self.notPlaceHolder) {
        self.notPlaceHolder = YES;
        textView.textColor = [UIColor blackColor];
    }
}

- (void) reloadWorkoutDetails
{
    self.exercises= [[Exercise fetchExericesForWorkout:self.workout
                                inManagedObjectContext:self.database.managedObjectContext] mutableCopy];
    [self.setsForExercises removeAllObjects];
    //fetch sets for exercises
    for (Exercise *exercise in self.exercises){
        NSMutableArray *sets = [[Set setsForExercise:exercise 
                                          andWorkout:self.workout 
                              inManagedObjectContext:self.database.managedObjectContext] mutableCopy];
        NSMutableArray *setPerExercise = [[NSMutableArray alloc] init];
        //loop over each set and for a nsmutablearray for sets of an exercise
        for (Set *set in sets){
            NSDictionary *setDictionary =  [NSDictionary dictionaryWithObjectsAndKeys:
                                            set.rep, @"reps",
                                            set.weight, @"weight",
                                            nil];  
            [setPerExercise addObject:setDictionary];
        }
        [self.setsForExercises addObject:setPerExercise];
    }
    //reload table
    [self.workOutDetails reloadData];
    [self.exerciseList reloadData];
}

//protocol methods
- (void) addExercise:(Exercise *)exercise 
             withSet:(NSArray *)set 
editingExistingExercise:(bool)flag
{
    [self.exercises addObject:exercise];
    [self.setsForExercises addObject:set];
    [self.exerciseList reloadData];
}
- (void) editExercise:(Exercise *)exercise 
              withSet:(NSArray *)set 
{
    //replace older exercise with new information
    NSUInteger index = [self.exercises indexOfObject:exercise];
    [self.setsForExercises replaceObjectAtIndex:index withObject:set];
    [self.exerciseList  reloadData];
    
}
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
- (IBAction)addExerciseLogWorkoutButtonClicked:(UIButton *)sender {
    if (self.editWorkout){//add exercise
        [self performSegueWithIdentifier:@"add new exercise" sender:self];
    }
    else { //LOG a workout
        [self performSegueWithIdentifier:@"log a workout" sender:self];
    }
    
}

- (IBAction)EditDoneButtonClicked:(UIBarButtonItem *)sender {
    if (self.editWorkout)//change button to have label edit
    {
        self.editWorkout = NO;
        self.backAndCancelButton.title = @"Back";
        sender.title = @"Edit";
        self.addExerciseButton.titleLabel.text = @"Log a Workout";
        self.workoutNameTextField.enabled = NO;
        self.workoutDescription.editable =NO;
        //save the workout here
        [Workout editAWorkout:self.workout 
                  withNewName:self.workoutNameTextField.text 
           withNewDescription:self.workoutDescription.text 
             withNewExercises:self.exercises 
                  withNewSets:self.setsForExercises 
       inManagedObjectContext:self.database.managedObjectContext];
        self.workoutDescription.textColor = [UIColor lightGrayColor];
        self.workoutNameTextField.textColor = [UIColor lightGrayColor];
        
        //[self reloadWorkoutDetails];
        
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
        self.addExerciseButton.titleLabel.text = @"Log a Workout";
        [self reloadWorkoutDetails];
    }else { //acts as back button
        //pop controller
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self.workOutDetails reloadData];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"view exercise"]){ //destination is ShowExerciseInWorkout
        NSNumber *rowFromTable = (NSNumber *)sender;
        [segue.destinationViewController setExercise:[self.exercises objectAtIndex:[rowFromTable intValue]]];
        [segue.destinationViewController setSetsForExercise:[[self.setsForExercises objectAtIndex:[rowFromTable intValue]] mutableCopy]];
        [segue.destinationViewController setDelegate:self];
        if (self.editWorkout) { //editing workout
            [segue.destinationViewController setEditExercise:YES];
        }
    }
    if ([segue.identifier isEqualToString:@"add new exercise"]){
        [segue.destinationViewController setDelegate:self];
        [segue.destinationViewController setDatabase:self.database];
    }
    if ([segue.identifier isEqualToString:@"log a workout"]){
        [segue.destinationViewController setDatabase:self.database];
        [segue.destinationViewController setWorkout:self.workout];
        [segue.destinationViewController setExercises:self.exercises];
        [segue.destinationViewController setSetsInExercises:self.setsForExercises];
    }
    if([segue.identifier isEqualToString:@"add event"]){
        AddEventViewController *addevent = (AddEventViewController *) segue.destinationViewController;
        [addevent setEventNameText: self.workout.name];
        
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
    
    if (tableView == self.exerciseList){ //only show workoutlist
        [self performSegueWithIdentifier:@"view exercise" sender:[NSNumber numberWithInt:indexPath.row]];
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
        _workoutNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(30,10,200,21)];
        _workoutNameTextField.delegate = self;
    }
    return _workoutNameTextField;
}

- (NSString *) getEmailBody
{
    NSString *template =[NSString stringWithFormat:@"<font size='3' face='verdana' color='blue'><i>Workout Name :</i></font> <br/>%@<br/>  <font size='3' face='verdana' color='blue'><i>Workout Description :</i></font></br> %@ <br/> ", self.workoutNameTextField.text,self.workoutDescription.text];
    NSString *exercises=@"";
    if ([self.exercises count] == 0 ) {
        template = [NSString stringWithFormat:@"%@ \n %@No Exercises </br>",template, exercises];
        return template;
    }
    for (Exercise *exercise in self.exercises)
    {
        exercises = [NSString stringWithFormat:@"%@ <font size='3' face='verdana' color='blue'><i>Exercise Name :</i></font><br/> %@ <br/> <font size='3' face='verdana' color='blue'><i>Exercise Description :</i><br/></font> %@ <br/>" ,exercises, exercise.name , exercise.exerciseDescription];
        //add sets
        for  (int i = 0; i <[self.setsForExercises count]; i++) {
           
        }
    }
    template = [NSString stringWithFormat:@"%@ \n %@ ", template, exercises];
    
    return template;
}

- (void) addEventToCalender: (id) sender
{
    [self performSegueWithIdentifier:@"add event" sender:self];
}

- (void) email : (id) sender
{
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"workout"];
    
    [controller setMessageBody:[self getEmailBody] isHTML:YES];
    [self presentModalViewController:controller animated:YES];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self becomeFirstResponder];
    [self dismissModalViewControllerAnimated:YES];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    textField.textColor = [UIColor blackColor];
}
- (UITableViewCell *) configureCellForWorkout: (UITableViewCell *) cell
                                  atIndexPath:(NSIndexPath *)indexPath
{
    for (UIView * subview in cell.subviews){
        if ([subview isKindOfClass:[UIButton class]]) [subview removeFromSuperview];
        if ([subview isKindOfClass:[UITextView class]]) [subview removeFromSuperview];
        if ([subview isKindOfClass:[UITextField class]]) [subview removeFromSuperview];
    }
    
    if (indexPath.row == 0 && self.workOutDetails) //workoutname field
    {
        self.workoutNameTextField.text = self.workout.name;
        self.workoutNameTextField.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        self.workoutNameTextField.textColor = [UIColor lightGrayColor];
        //add email button
        UIButton *button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"emailSmall.png"] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(cell.bounds.size.width - 40, 10, 30, 30)];
        [button addTarget:self action:@selector(email:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button];
        [cell addSubview:self.workoutNameTextField];
    }
    
    if (indexPath.row == 1 && self.workOutDetails) //workoutdescription field
    {
        self.workoutDescription = [[UITextView alloc] initWithFrame:CGRectMake(20,10,200,50)];
        if (self.editWorkout) self.workoutDescription.editable = YES;
        else self.workoutDescription.editable = NO;
        self.workoutDescription.delegate = self;
        self.workoutDescription.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        self.workoutDescription.text = self.workout.workoutDescription;
        self.workoutDescription.textColor = [UIColor lightGrayColor];
        
        //add event button
        UIButton *eventButton = [[UIButton alloc] init];
        [eventButton setImage:[UIImage imageNamed:@"calender.png"] forState:UIControlStateNormal];
        [eventButton setFrame:CGRectMake(cell.bounds.size.width - 40, 10, 30, 30)];
        [eventButton addTarget:self action:@selector(addEventToCalender:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:eventButton];
        

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
        cell.backgroundColor = [UIColor whiteColor];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.exerciseList && [self.exercises count] >0) return 30;
    return 0;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
    customView.backgroundColor = [UIColor clearColor];
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:18];
    headerLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    headerLabel.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    headerLabel.frame = CGRectMake(11,-11, 320.0, 44.0);
    headerLabel.textAlignment = UITextAlignmentLeft;
    headerLabel.text = @"";
    if (tableView == self.exerciseList && [self.exercises count] >0)  headerLabel.text = @"Exercises";
    
    [customView addSubview:headerLabel];
    return customView;
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
    
    //set text color
    self.workoutNameTextField.textColor = [UIColor lightGrayColor];
    self.workoutDescription.textColor = [UIColor lightGrayColor];
}


- (void) styleButton
{
    CALayer *layer = [self.addExerciseButton layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:8.0f];
    [layer setBorderWidth:0.5f];
    [layer setBorderColor:[[UIColor blackColor] CGColor]];
    
    self.addExerciseButton.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"redGloss.png"]];
    self.addExerciseButton.titleLabel.textColor = [UIColor whiteColor];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //add background color

    self.workOutDetails.backgroundColor = [UIColor clearColor];
    self.exerciseList.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"texture.png"]];

    //style log workout button
    [self styleButton];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.2 alpha:1.0];
    //add tap
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                                 action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];

    if (!self.editWorkout){
        self.workoutNameTextField.enabled = NO;
        self.workoutDescription.editable = NO;
        self.workOutDetails.scrollEnabled = NO;
    } else {
        self.addExerciseButton.titleLabel.text = @"Add Exercise";
    }

}


-(void) viewDidLoad
{
    [self.workOutDetails setDelegate:self];
    [self.workOutDetails setDataSource:self];
    [self.exerciseList setDelegate:self];
    [self.exerciseList setDataSource:self];
    //fetch exercises
    [self reloadWorkoutDetails];

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
    [self.workOutDetails reloadData];
    return YES;
}

@end
