//
//  ChooseExerciseToViewPerformanceViewController.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/4/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "ChooseExerciseToViewPerformanceViewController.h"
#import "WorkoutHelper.h"
#import "Exercise.h"
#import "PlotPerformance.h"
#import "ActualWorkout+Performance.h"

@interface ChooseExerciseToViewPerformanceViewController()
@property (nonatomic,strong) UIManagedDocument *database;
@end
@implementation ChooseExerciseToViewPerformanceViewController
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
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [WorkoutHelper openWorkoutPlannerusingBlock:^(UIManagedDocument * workoutPlanner){
        self.database = workoutPlanner; 
        NSFetchRequest *request =[NSFetchRequest   fetchRequestWithEntityName:@"Exercise"];
        NSSortDescriptor *sortDecriptor = [NSSortDescriptor sortDescriptorWithKey:@"exerciseId" ascending:YES];
        request.sortDescriptors = [NSArray arrayWithObject:sortDecriptor];
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.database.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"texture.png"]];
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
     //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return  YES;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"exercise to choose";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    Exercise *exercise = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = exercise.name;
    cell.detailTextLabel.text = exercise.exerciseDescription;
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"show graph"]) {
        NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
        PlotPerformance *destination = (PlotPerformance *) segue.destinationViewController;
        Exercise *exercise = [self.fetchedResultsController objectAtIndexPath:indexPath]
        ;
        [destination setExercise:exercise];
        [destination setExerciseName:exercise.name];
        [destination setDatabase:self.database];
        destination.hidesBottomBarWhenPushed = YES;
        //[destination setToDate:date];
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



@end
