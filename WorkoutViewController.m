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
#import "MessageUI/MessageUI.h"

@interface WorkoutViewController()<MFMailComposeViewControllerDelegate, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong) UIManagedDocument *database;
@end
@implementation WorkoutViewController
@synthesize searchBar = _searchBar;
@synthesize database = _database;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)emailPressed:(id)sender {
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"workout"];
    [controller setMessageBody:@"...bla bla" isHTML:NO];
    [self presentModalViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self becomeFirstResponder];
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.searchBar setDelegate:self];
    self.searchBar.showsCancelButton = YES;
    NSLog(@"view did load");
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"view will appear");
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.searchBar.tintColor = [UIColor colorWithRed:0.7 green:0.1 blue:0.2 alpha:1.0];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.2 alpha:1.0];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"texture.png"]];
    
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
    NSLog(@"rotating");
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

//search bar
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText

{
      NSFetchRequest * request = [NSFetchRequest   fetchRequestWithEntityName:@"Workout"];
      if (![searchText isEqualToString:@""])//search text has non empty string 
      {
          request.predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH %@ ",searchText];
      } 
      NSSortDescriptor *sortDecriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
      
      request.sortDescriptors = [NSArray arrayWithObject:sortDecriptor];
      self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.database.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
                          
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    
}


@end
