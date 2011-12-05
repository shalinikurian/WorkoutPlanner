//
//  PlotPerformance.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/4/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "PlotPerformance.h"
#import "GraphView.h"

@interface PlotPerformance()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet GraphView *graphView;

@end
@implementation PlotPerformance
@synthesize scrollView = _scrollView;
@synthesize graphView = _graphView;

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
    self.scrollView.contentSize = CGSizeMake(kDefaultGraphWidth, kGraphHeight + 50);

}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setDelegate:self];
    
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setGraphView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
