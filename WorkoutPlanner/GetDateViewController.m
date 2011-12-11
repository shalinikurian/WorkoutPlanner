//
//  GetDateViewController.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/11/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "GetDateViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface GetDateViewController()
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@end
@implementation GetDateViewController
@synthesize datePicker = _datePicker;
@synthesize doneButton = _doneButton;
@synthesize delegate = _delegate;
@synthesize startDate = _startDate;

- (void) styleButton
{
    CALayer *layer = [self.doneButton layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:8.0f];
    [layer setBorderWidth:0.5f];
    [layer setBorderColor:[[UIColor blackColor] CGColor]];
    
    self.doneButton.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"redGloss.png"]];
    self.doneButton.titleLabel.textColor = [UIColor whiteColor];
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"texture.png"]];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.2 alpha:1.0];
    [self styleButton];
}
- (IBAction)doneButtonClicked:(id)sender {
    //TODO send date from date picker
    NSDate * selected = [self.datePicker date];
    NSLog(@"date %@",selected);
    [self.delegate datePicked:selected startDate:self.startDate];
    
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

- (void)viewDidUnload
{
    [self setDatePicker:nil];
    [self setDoneButton:nil];
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
