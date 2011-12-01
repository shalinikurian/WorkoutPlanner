//
//  ShowExistingExercisesViewController.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/24/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "ShowExistingExercisesViewController.h"
#import "Exercise.h"
#import "CustomButton.h"
@interface ShowExistingExercisesViewController()
@end
@implementation ShowExistingExercisesViewController
@synthesize database = _database;
@synthesize delegate = _delegate;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    //if in edit mode add a navigation item for save
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //set up fetchedResultsController
    NSFetchRequest *request =[NSFetchRequest   fetchRequestWithEntityName:@"Exercise"];
    NSSortDescriptor *sortDecriptor = [NSSortDescriptor sortDescriptorWithKey:@"exerciseId" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDecriptor];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.database.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (void)chooseFromExistingExercises:(id) sender{
    CustomButton *selectButton = (CustomButton *)sender;
    Exercise *exerciseChosen = selectButton.exercise;
    [self.delegate setExercise:exerciseChosen];
    [self.navigationController popViewControllerAnimated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Existing Exercises";
    Exercise *exercise = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    //customize cell
    UITextView *description = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width-30,50)];
    description.editable = NO;
    description.text = exercise.exerciseDescription;
    [cell.contentView addSubview:description];
    CustomButton *selectButton =[[CustomButton alloc] initWithFrame:CGRectMake(0, 0,30,30)];
    selectButton.indexPath = indexPath;
    selectButton.exercise = exercise;
    [selectButton addTarget:self action:@selector(chooseFromExistingExercises:) forControlEvents:UIControlEventTouchUpInside];
    [cell setAccessoryView:selectButton];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

@end
