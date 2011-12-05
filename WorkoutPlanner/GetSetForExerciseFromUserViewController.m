//
//  GetSetForExerciseFromUserViewController.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/1/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "GetSetForExerciseFromUserViewController.h"

@interface GetSetForExerciseFromUserViewController()<UIScrollViewDelegate, UIPickerViewDelegate,UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPickerView *repsPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *weightPicker;
@property (strong, nonatomic) NSArray *reps;
@property (strong, nonatomic) NSArray *weight;
@end
@implementation GetSetForExerciseFromUserViewController
@synthesize scrollView = _scrollView;
@synthesize repsPicker = _repsPicker;
@synthesize weightPicker = _weightPicker;
@synthesize delegate = _delegate;
@synthesize setNo = _setNo;
@synthesize exerciseNo = _exerciseNo;
@synthesize reps =_reps;
@synthesize weight = _weight;

- (NSArray *) reps 
{
    if (!_reps){
        _reps = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil];
    }
    return _reps;
}

- (NSArray *) weight 
{
    if (!_weight){
        _weight = [[NSArray alloc] initWithObjects:@"0",@"5",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"75",@"100",@"200",@"300",@"400", nil];
    }
    return _weight;
}

- (IBAction)cancelPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)savePressed:(id)sender {
    NSInteger indexOfRepSelected = [self.repsPicker selectedRowInComponent:0];
    NSString *selectedRep = (NSString *)[self.reps objectAtIndex:indexOfRepSelected];
    NSString *selectedWeight = (NSString *)[self.weight objectAtIndex:[self.weightPicker selectedRowInComponent:0]];
    [self.delegate weightForExercise:selectedWeight repForExercise:selectedRep forSetNo:self.setNo forExerciseNo:self.exerciseNo];
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setDelegate:self];
    [self.repsPicker setDelegate:self];
    [self.weightPicker setDelegate:self];
    [self.repsPicker setDataSource:self];
    [self.weightPicker setDataSource:self];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setRepsPicker:nil];
    [self setWeightPicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.repsPicker) return [self.reps count];
    return [self.weight count];
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.repsPicker){
        NSString *rep = (NSString *)[self.reps objectAtIndex:row];
        return rep;
    }
    NSString *weight = (NSString *)[self.weight objectAtIndex:row];
    weight = [weight stringByAppendingString:@" lbs"];
    return weight;
}

@end
