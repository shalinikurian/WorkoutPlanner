//
//  AddNewExerciseViewController.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/24/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "AddNewExerciseViewController.h"
#import "ShowExistingExercisesViewController.h"
#import "GetSetForExerciseFromUserViewController.h"
@interface AddNewExerciseViewController() <ShowExistingExercisesViewControllerProtocol, GetSetForExerciseFromUserViewController, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *showSetsTableView;
@property (strong, nonatomic) IBOutlet UITableView *addSetTableView;
@property (nonatomic, strong) UIManagedDocument *database;
@property (strong, nonatomic) IBOutlet UITableView *exerciseDetailsTableView;
@property (nonatomic) bool chosenFromExisitingExercises;
@property (nonatomic) bool expandCell;
@property (nonatomic, strong) UITextField * reps;
@property (nonatomic, strong) UITextField * weight;
@property (nonatomic, strong) UITextField *currentFirstResponder;
@property (nonatomic, strong) UIButton *addCancelSetButton;
@end

@implementation AddNewExerciseViewController 
@synthesize delegate = _delegate;
@synthesize scrollView = _scrollView;
@synthesize showSetsTableView = _showSetsTableView;
@synthesize addSetTableView = _addSetTableView;
@synthesize database = _database;
@synthesize exerciseDetailsTableView = _exerciseDetailsTableView;
@synthesize exerciseName = _exerciseName;
@synthesize exerciseDescription = _exerciseDescription;
@synthesize chosenFromExisitingExercises = _chosenFromExisitingExercises;
@synthesize exerciseToAdd = _exerciseToAdd;
@synthesize expandCell = _expandCell;
@synthesize arrayOfSets = _arrayOfSets;
@synthesize reps = _reps;
@synthesize weight= _weight;
@synthesize currentFirstResponder = _currentFirstResponder;
@synthesize addCancelSetButton = _addCancelSetButton;
@synthesize editAddedExercise = _editAddedExercise;

- (void) weightForExercise:(NSString *)weight 
            repForExercise:(NSString *)rep 
                  forSetNo:(NSInteger)setNo 
             forExerciseNo:(NSInteger)exerciseNo
{
    NSDictionary *setDictionary =  [NSDictionary dictionaryWithObjectsAndKeys:
                                    rep, @"reps",
                                    weight, @"weight",
                                    nil]; 
    [self.arrayOfSets addObject:setDictionary];
    [self.addSetTableView reloadData];
    [self.showSetsTableView reloadData];
    
}

- (NSMutableArray *) arrayOfSets{
    if(!_arrayOfSets){
        _arrayOfSets = [[NSMutableArray alloc] init];
    }
    return _arrayOfSets;
}
- (void) setExercise:(Exercise *)exercise{
    self.exerciseToAdd = exercise;
    self.exerciseName.text = exercise.name;
    self.exerciseDescription.text = exercise.exerciseDescription;
    self.exerciseName.enabled = NO;
    self.exerciseDescription.editable = NO;
    self.chosenFromExisitingExercises = YES;
}

- (void) addExerciseAndDismissController
{
    NSLog(@"sets %@",self.arrayOfSets);
    [self.delegate addExercise:self.exerciseToAdd
                       withSet:self.arrayOfSets
       editingExistingExercise:self.editAddedExercise];
    
    NSLog(@"popping controllers");
    NSMutableArray *allControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    [self.navigationController popToViewController:[allControllers objectAtIndex:[allControllers count]-2] animated:YES];
}
- (IBAction)exerciseAdded:(id)sender {
    NSLog(@"came to exercise added");
    //if not chosen from existing exercises or not editing already added exercise add exercise in database
    if (!self.chosenFromExisitingExercises && !self.editAddedExercise) {
        NSLog(@"added a new exercise");
        [Exercise createExerciseWithName:[self.exerciseName text]
                         withDescription:[self.exerciseDescription text]
                               withImage:nil
                  inManagedObjectContext:self.database.managedObjectContext
                         managedDocument:self.database
                               callBlock:^(Exercise *exercise){
                                   self.exerciseToAdd = exercise;
                                   [self addExerciseAndDismissController];
                               }];
    } else {
        [self addExerciseAndDismissController];
    }
}
- (IBAction)cancelExercise:(id)sender {
    NSMutableArray *allControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    [self.navigationController popToViewController:[allControllers objectAtIndex:[allControllers count]-2] animated:YES];
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

- (void) viewDidLoad{
    [super viewDidLoad];
    [self.exerciseDetailsTableView setDelegate:self];
    [self.exerciseDetailsTableView  setDataSource:self];
    [self.addSetTableView setDelegate:self];
    [self.addSetTableView setDataSource:self];
    [self.showSetsTableView setDelegate:self];
    [self.showSetsTableView setDataSource:self];
    //for textfields
    [self.reps setDelegate:self];
    [self.weight setDelegate:self];
    [self.exerciseName setDelegate:self];
    }


- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
- (void) addSetClicked :(id) sender {
    
    [self.reps resignFirstResponder];
    [self.weight resignFirstResponder];
    [self performSegueWithIdentifier:@"add set" sender:self];
}

- (void) prePopulateFields
{
    self.exerciseName.enabled = NO;
    self.exerciseName.text = self.exerciseToAdd.name;
    self.exerciseDescription.text = self.exerciseToAdd.exerciseDescription;
    self.exerciseDescription.editable = NO;
}

- (void) addButtonForAddingSetInUI
{
    CGRect frame = self.addSetTableView.frame;
    self.addCancelSetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:@"addImage.png"];
    [self.addCancelSetButton setImage:img forState:UIControlStateNormal];
    [self.addCancelSetButton addTarget:self action:@selector(addSetClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.addCancelSetButton setFrame:CGRectMake(frame.origin.x-30, frame.origin.y+20, 30, 30)];
    
    [self.scrollView addSubview:self.addCancelSetButton];
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
    [self.exerciseDescription resignFirstResponder];
    [self.exerciseName resignFirstResponder];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //add tap
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                                 action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    
    [self addButtonForAddingSetInUI];
    self.addSetTableView.scrollEnabled = NO;
    self.exerciseDetailsTableView.scrollEnabled = NO;
    self.scrollView.delegate = self;
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width,
                               self.view.frame.size.height)];
    
}
- (void) viewDidAppear:(BOOL)animated
{
    if (self.editAddedExercise) {
        [self prePopulateFields];
    }
}
- (void)viewDidUnload
{
    [self setAddSetTableView:nil];
    [self setShowSetsTableView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection:(NSInteger)section  
{
    if (tableView == self.exerciseDetailsTableView) return 2;
    if (tableView == self.addSetTableView) {
        return 1;
    }
    return [self.arrayOfSets count]; //sets table
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.exerciseDetailsTableView == tableView && indexPath.row  == 1) return 80;
    return 50;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"show existing exercise"]){
        [segue.destinationViewController setDelegate:self];
        [segue.destinationViewController setDatabase:self.database];

    }else if ([segue.identifier isEqualToString:@"add set"]){
        
        GetSetForExerciseFromUserViewController *destination = (GetSetForExerciseFromUserViewController *)segue.destinationViewController;
        [destination setDelegate:self];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.reps || textField == self.weight ){
        if ([textField.text isEqualToString:@""]) return NO;
    }
    return YES;
}
- (void) addExercise: (id) sender
{
    [self performSegueWithIdentifier:@"show existing exercise" sender:self];
}

- (UITableViewCell *) configureCellForExercise: (UITableViewCell *) cell
                                   atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) //exercisename field
    {
        self.exerciseName = [[UITextField alloc] initWithFrame:CGRectMake(20,10,200,21)];
        self.exerciseName.placeholder = @"Exercise Name";
        
        //do not allow to choose from existing exercises if self.editAddedExercise is YES . In that case
        //user is editing already added exercise
        if (!self.editAddedExercise){
            UIButton *addFromExistingExercise = [UIButton buttonWithType:UIButtonTypeContactAdd];
            [addFromExistingExercise addTarget:self action:@selector(addExercise:) forControlEvents:UIControlEventTouchUpInside];
            [cell setAccessoryView:addFromExistingExercise];
        }
        [cell addSubview:self.exerciseName];
    }
    
    if (indexPath.row == 1) //exercisedescription field
    {
        self.exerciseDescription = [[UITextView alloc] initWithFrame:CGRectMake(20,10,cell.bounds.size.width-30,50)];
        self.exerciseDescription.text = @"Exercise Description";
        [cell addSubview:self.exerciseDescription];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (UITextField *) reps {
    if (!_reps){
        _reps = [[UITextField alloc] initWithFrame:CGRectMake(20,10,50,21)];
    }
    return _reps;
}

- (UITextField *) weight {
    if (!_weight){
        _weight = [[UITextField alloc] initWithFrame:CGRectMake(80,10,50,21)];
    }
    return _weight;
}

/*- (UITableViewCell *) configureCellForAddSet: (UITableViewCell*) cell 
{
   
    self.reps.text = @"";
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60,10,10,21)];     
    label.backgroundColor =[UIColor clearColor];
    label.text = @"X";
    self.weight.text = @"";
    self.reps.placeholder = @"reps";
    self.weight.placeholder = @"weight";
    cell.textLabel.text =@"";
    self.reps.keyboardType = UIKeyboardTypeNumberPad;
    self.weight.keyboardType = UIKeyboardTypeNumberPad;
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [doneButton addTarget:self action:@selector(doneAddingSetClicked:) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setFrame:CGRectMake(0, 0, 50, 35)];
    [cell setAccessoryView:doneButton];
    [cell.contentView addSubview:self.reps];
    [cell.contentView addSubview:label];
    [cell.contentView addSubview:self.weight];
    return cell;
    
}*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.exerciseDetailsTableView) {
        static NSString *CellIdentifier = @"exerciseDetails";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.editing = NO;
        }
        
        
        cell = [self configureCellForExercise:cell atIndexPath:indexPath];
        return cell;
    }
    if (tableView == self.addSetTableView) {
        static NSString *CellIdentifier = @"add a set";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.editing = NO;
        }
       
        cell.textLabel.text = @"Add a set";
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.accessoryView = nil;
        return cell;
    }
    //sets table view
    static NSString *CellIdentifier = @"set";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *set = [self.arrayOfSets objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ reps X %@ lb", [set objectForKey:@"reps"],[set objectForKey:@"weight"]];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.showSetsTableView && [self.arrayOfSets count]>0) return @"Sets Added";
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0 && tableView == self.exerciseDetailsTableView) //name text field
    {
        [self.exerciseName becomeFirstResponder];
    }else if(indexPath.section == 0 && indexPath.row == 1 && tableView == self.exerciseDetailsTableView)//description
    {
        [self.exerciseDescription becomeFirstResponder];
    }
    
}
 
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView 
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.showSetsTableView) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{
   
}


- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.arrayOfSets removeObjectAtIndex:indexPath.row];
    [tableView reloadData];
}

@end
