//
//  ShowExerciseInWorkout.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/26/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "ShowExerciseInWorkout.h"
#import "Set.h"
@interface ShowExerciseInWorkout()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *exerciseDetailsTableView;
@property (strong, nonatomic) IBOutlet UITableView *showSetsTableView;
@property (strong, nonatomic) IBOutlet UITableView *addSetTableView;
@property (nonatomic, strong) UITextField * reps;
@property (nonatomic, strong) UITextField * weight;
@property (strong, nonatomic) UITextField * exerciseName;
@property (strong, nonatomic) UITextView *exerciseDescription;
@property (nonatomic, strong) UIButton *addCancelSetButton;
@property (nonatomic) bool expandCell;

@end
@implementation ShowExerciseInWorkout
@synthesize scrollView;
@synthesize exerciseDetailsTableView;
@synthesize showSetsTableView = _showSetsTableView;
@synthesize addSetTableView = _addSetTableView;
@synthesize reps = _reps;
@synthesize weight = _weight;
@synthesize exerciseName = _exerciseName;
@synthesize exerciseDescription = _exerciseDescription;
@synthesize exercise = _exercise;
@synthesize setsForExercise = _setsForExercise;
@synthesize editExercise = _editExercise;
@synthesize expandCell = _expandCell;
@synthesize addCancelSetButton = _addCancelSetButton;
@synthesize delegate = _delegate;

- (NSMutableArray *) setsForExercise
{
    if(!_setsForExercise){
        _setsForExercise = [[NSMutableArray alloc] init];
    }
    return _setsForExercise;
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/
- (void) changeAddMinusSetIcon {
    if (self.expandCell) {
        self.expandCell = false;
        UIImage *img = [UIImage imageNamed:@"addImage.png"];
        [self.addCancelSetButton setImage:img forState:UIControlStateNormal];
    }
    else {
        self.expandCell = true;
        [self.reps resignFirstResponder];
        [self.weight resignFirstResponder];
        UIImage *img = [UIImage imageNamed:@"minusImage.png"];
        [self.addCancelSetButton setImage:img forState:UIControlStateNormal];
    }
    
}

- (void) doneAddingSetClicked :(id) sender {
    [self changeAddMinusSetIcon];
    self.expandCell = NO;
    // make a set
    NSDictionary *setDictionary =  [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.reps.text, @"reps",
                                    self.weight.text, @"weight",
                                    nil]; 
    [self.setsForExercise addObject:setDictionary];
    [self.addSetTableView reloadData];
    [self.showSetsTableView reloadData];
    
}
- (void) addSetClicked :(id) sender {
    
    [self changeAddMinusSetIcon];
    [self.reps resignFirstResponder];
    [self.weight resignFirstResponder];
    [self.addSetTableView reloadData];
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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.exerciseDetailsTableView.scrollEnabled = NO;
    self.addSetTableView.scrollEnabled = NO;
    self.scrollView.delegate = self;
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.exerciseDetailsTableView.frame.size.height+self.addSetTableView.frame.size.height+self.showSetsTableView.frame.size.height)];
    //[self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width,
                                               //self.view.frame.size.height)];
    if (self.editExercise) {
       [self addButtonForAddingSetInUI]; 
        self.exerciseName.enabled = YES;
        self.exerciseDescription.editable = YES;
    }else {
        //disable text fields and text area
        self.exerciseName.enabled = NO;
        self.exerciseDescription.editable = NO;
    }
   
}

- (void) saveExercise: (id) sender
{
      [self.delegate editExercise:self.exercise
                          withSet:self.setsForExercise];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewDidLoad
{
    [self.exerciseDetailsTableView setDelegate:self];
    [self.exerciseDetailsTableView  setDataSource:self];
    [self.showSetsTableView setDelegate:self];
    [self.showSetsTableView setDataSource:self];
    [self.addSetTableView setDataSource:self];
    [self.addSetTableView setDelegate:self];
    //for textfields
    [self.reps setDelegate:self];
    [self.weight setDelegate:self];
    [self.exerciseName setDelegate:self];
    if (self.editExercise) {
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveExercise:)];          
        self.navigationItem.rightBarButtonItem = saveButton;
        self.navigationItem.rightBarButtonItem = saveButton;
    }
}
- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setExerciseDetailsTableView:nil];
    [self setShowSetsTableView:nil];
    [self setAddSetTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection:(NSInteger)section  
{
    if (tableView == self.exerciseDetailsTableView) return 2;
    if (tableView == self.showSetsTableView) return [self.setsForExercise count];
    //add set table view. show it only in edit mode
    if (self.editExercise) return 1;
    return 0; //not editing exercise only viewing exercise . add set button not shown.
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.exerciseDetailsTableView == tableView && indexPath.row  == 1) return 80;
    return 50;
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

- (UITableViewCell *) configureCellForExercise: (UITableViewCell *) cell
                                   atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) //exercisename field
    {
        self.exerciseName = [[UITextField alloc] initWithFrame:CGRectMake(20,10,200,21)];
        self.exerciseName.text = self.exercise.name;
        self.exerciseName.enabled = NO;
        [cell addSubview:self.exerciseName];
    }
    
    if (indexPath.row == 1) //exercisedescription field
    {
        self.exerciseDescription = [[UITextView alloc] initWithFrame:CGRectMake(20,10,cell.bounds.size.width-30,50)];
        self.exerciseDescription.text = self.exercise.exerciseDescription;
        self.exerciseDescription.editable = NO;
        [cell addSubview:self.exerciseDescription];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCell *) configureCellForAddSet: (UITableViewCell*) cell 
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
    
}

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
        if(self.expandCell){
            //set uitextlabels and configure keyboard
            cell = [self configureCellForAddSet:cell];
        }else {
            cell.textLabel.text = @"Add a set";
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.accessoryView = nil;
        }
        return cell;
    }
    //sets table view
    static NSString *CellIdentifier = @"set";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //Set *set = [self.setsForExercise objectAtIndex:indexPath.row];
    //cell.textLabel.text = [NSString stringWithFormat:@"%@ reps X %@ lb", set.rep,set.weight];
    NSDictionary *set = [self.setsForExercise objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ reps X %@ lb", [set objectForKey:@"reps"],[set objectForKey:@"weight"]];
    return cell;

}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView 
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editExercise)return UITableViewCellEditingStyleDelete;    
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.setsForExercise removeObjectAtIndex:indexPath.row];
    [tableView reloadData];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
