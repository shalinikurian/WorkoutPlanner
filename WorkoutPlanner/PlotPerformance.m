//
//  PlotPerformance.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/4/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "PlotPerformance.h"
#import "GraphView.h"
#import "ActualWorkout+Performance.h"
@interface PlotPerformance()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet GraphView *graphView;
@property (strong, nonatomic) IBOutlet UIView *optionsView;

@end
@implementation PlotPerformance
@synthesize scrollView = _scrollView;
@synthesize graphView = _graphView;
@synthesize optionsView = _optionsView;
@synthesize performance = _performance;
@synthesize exerciseName = _exerciseName;
@synthesize toDate = _toDate;
@synthesize exercise = _exercise;
@synthesize database = _database;

- (void) getPerformanceForDays:(int) days{
    self.performance = [ActualWorkout perfomanceOfExercise:  self.exercise                                                                                                                                   forDays:days
                                                    toDate:self.toDate
                                    inManagedObjectContext:self.database.managedObjectContext];
    

}

- (IBAction)showOptions:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"Week"]){
        [self getPerformanceForDays:7];
        self.graphView.noOfDays = 7;
        self.title = [NSString stringWithFormat:@"%@ -Week",self.exerciseName];
        sender.title = @"30 Days";
    } else {
        [self getPerformanceForDays:30];
        //get performance for month
        self.graphView.noOfDays = 30;
        self.title = [NSString stringWithFormat:@"%@ - 30 days",self.exerciseName];
        sender.title = @"Week";

    }
    self.graphView.performance = self.performance;
    [self.graphView setNeedsDisplay];
}

- (NSArray *) performance
{
    if(!_performance){
        _performance = [[NSArray alloc] init];
    }
    return _performance;
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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //get performance
    self.toDate = [NSDate date];
    [self getPerformanceForDays:7];
    self.graphView.performance = self.performance;
    self.graphView.toDate = self.toDate;
    self.graphView.noOfDays = 7;//by default a week
    self.navigationItem.title = [NSString stringWithFormat:@"%@ -Week", self.exerciseName];
    [self.optionsView setHidden:YES];    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setDelegate:self];
    /*UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"graphBk.jpg"]];
    background.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:background];*/
    
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setGraphView:nil];
    [self setOptionsView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
        self.graphView.kDefaultGraphWidth = 320;
        self.graphView.kGraphHeight = 367;
        //self.graphView.kGraphBottom = 367;
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        /*self.graphView.kDefaultGraphWidth = 480;
        self.graphView.kGraphHeight = 207;
        self.graphView.kGraphBottom = 207;*/
    }
   [self.graphView setNeedsDisplay];
    return YES;
}

@end
