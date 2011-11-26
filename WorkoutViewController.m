//
//  WorkoutViewController.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/22/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "WorkoutViewController.h"
#import "WorkoutHelper.h"
#import "Workout.h"
#import "Workout+Delete.h"
#import "AddNewWorkoutViewController.h"
#import "ShowExistingWorkout.h"

@interface WorkoutViewController()
@property (nonatomic,strong) UIManagedDocument *database;
@end
@implementation WorkoutViewController
@synthesize database = _database;
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
    [WorkoutHelper openWorkoutPlannerusingBlock:^(UIManagedDocument * workoutPlanner){
        self.database = workoutPlanner; 
        NSFetchRequest *request =[NSFetchRequest   fetchRequestWithEntityName:@"Workout"];
        NSSortDescriptor *sortDecriptor = [NSSortDescriptor sortDescriptorWithKey:@"workoutId" ascending:YES];
        request.sortDescriptors = [NSArray arrayWithObject:sortDecriptor];
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.database.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    }];
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
    [self.view setNeedsDisplay];
    return YES;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setDatabase:self.database];
    if ([segue.identifier isEqualToString:@"see existing workout"]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Workout *workout = [self.fetchedResultsController objectAtIndexPath:indexPath];
        //show exisiting workout
        [segue.destinationViewController setWorkout:workout];
    }
}
#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"workout";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    Workout *workout = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = workout.name;
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView 
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{

    Workout *workout = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [Workout deleteWorkout:workout inManagedObjectContext:self.database.managedObjectContext];
    [tableView reloadData];   
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView reloadData];
}


@end
