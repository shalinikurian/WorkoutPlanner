//
//  ShowImageViewController.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/8/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "ShowImageViewController.h"
#import "ImageForWorkout+DeleteImage.h"

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
@synthesize delegate = _delegate;
@synthesize position = _position;
@synthesize indexPath = _indexPath;

- (IBAction)deletePhoto:(UIBarButtonItem *)sender {
    
    [self.delegate deletePictureWithURL:self.url atIndexPath:self.indexPath atPosition:self.position];
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

-(void) resizeView
{
    CGFloat scale = 1;
    self.scrollView.delegate = self;
    if (self.scrollView.contentSize.width > self.scrollView.contentSize.height)
    {
        //scale = self.scrollView.bounds.size.height / self.scrollView.contentSize.height;
        scale = self.view.frame.size.height/self.scrollView.contentSize.height;
    } else {
        
       // scale = self.scrollView.bounds.size.width / self.scrollView.contentSize.width;
        scale = self.view.frame.size.width / self.scrollView.contentSize.width;
    }
    
    NSLog(@"scale %f",scale);
    [self.scrollView setZoomScale:scale];
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.2 alpha:1.0];
    self.imageView.image = self.image;
    self.scrollView.contentSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale=0.5;
    self.scrollView.maximumZoomScale=6.0;
    [self resizeView];
}
- (void) viewDidLoad:(BOOL)animated
{
    [self viewDidLoad:YES];
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
    [self.view setNeedsDisplay];
    [self resizeView];
    return YES;
}

@end
