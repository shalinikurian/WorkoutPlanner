//
//  ShowImageViewController.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/8/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "ShowImageViewController.h"
@interface ShowImageViewController()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
@implementation ShowImageViewController
@synthesize imageView = _imageView;
@synthesize scrollView = _scrollView;
@synthesize image = _image;
@synthesize url = _url;
@synthesize database = _database;

- (IBAction)deletePhoto:(UIBarButtonItem *)sender {
    
    //delete image from core data
    
    //pop controller
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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

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
    self.scrollView.delegate = self;
}


- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
