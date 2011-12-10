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
@interface ShowExistingExercisesViewController()<UISearchBarDelegate>
@end
@implementation ShowExistingExercisesViewController
@synthesize searchBar = _searchBar;
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
    [self.searchBar setDelegate:self];
    self.searchBar.showsCancelButton = YES;
    //if in edit mode add a navigation item for save
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
    [super viewWillAppear:animated];
    //search bar tint color
    self.searchBar.tintColor = [UIColor colorWithRed:0.7 green:0.1 blue:0.2 alpha:1.0];
    
    //set up fetchedResultsController
    NSFetchRequest *request =[NSFetchRequest   fetchRequestWithEntityName:@"Exercise"];
    NSSortDescriptor *sortDecriptor = [NSSortDescriptor sortDescriptorWithKey:@"exerciseId" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDecriptor];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.database.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"texture.png"]];
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
    return YES;
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
    
    cell.textLabel.text = exercise.name;
    cell.detailTextLabel.text = exercise.exerciseDescription;
    CustomButton *selectButton =[[CustomButton alloc] initWithFrame:CGRectMake(0, 0,30,30)];
    selectButton.indexPath = indexPath;
    selectButton.exercise = exercise;
    [selectButton addTarget:self action:@selector(chooseFromExistingExercises:) forControlEvents:UIControlEventTouchUpInside];
    [cell setAccessoryView:selectButton];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

//search bar
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText

{
    NSFetchRequest * request = [NSFetchRequest   fetchRequestWithEntityName:@"Exercise"];
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
