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
@property (nonatomic, strong) UITextField * reps;
@property (nonatomic, strong) UITextField * weight;
@property (strong, nonatomic) UITextField * exerciseName;
@property (strong, nonatomic) UITextView *exerciseDescription;
@end
@implementation ShowExerciseInWorkout
@synthesize scrollView;
@synthesize exerciseDetailsTableView;
@synthesize showSetsTableView = _showSetsTableView;
@synthesize reps = _reps;
@synthesize weight = _weight;
@synthesize exerciseName = _exerciseName;
@synthesize exerciseDescription = _exerciseDescription;
@synthesize exercise = _exercise;
@synthesize setsForExercise = _setsForExercise;

- (NSArray *) setsForExercise
{
    if(!_setsForExercise){
        _setsForExercise = [[NSArray alloc] init];
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
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.exerciseDetailsTableView.scrollEnabled = NO;
    self.scrollView.delegate = self;
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width,
                                               self.view.frame.size.height)];
    //disable text fields and text area
    self.exerciseName.enabled = NO;
    self.exerciseDescription.editable = NO;
}
- (void) viewDidLoad
{
    [self.exerciseDetailsTableView setDelegate:self];
    [self.exerciseDetailsTableView  setDataSource:self];
    [self.showSetsTableView setDelegate:self];
    [self.showSetsTableView setDataSource:self];
    //for textfields
    [self.reps setDelegate:self];
    [self.weight setDelegate:self];
    [self.exerciseName setDelegate:self];
}
- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setExerciseDetailsTableView:nil];
    [self setShowSetsTableView:nil];
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
    return [self.setsForExercise count];
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
    //sets table view
    static NSString *CellIdentifier = @"set";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Set *set = [self.setsForExercise objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ reps X %@ lb", set.rep,set.weight];
    return cell;

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
