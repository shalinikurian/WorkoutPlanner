//
//  ShowPhotosViewController.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/7/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "ShowPhotosViewController.h"
#import "ActualWorkout+PhotosByDate.h"
#import "WorkoutHelper.h"
#import "PhotoButtonInCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageForWorkout+DeleteImage.h"
#import "ShowImageViewController.h"


@interface ShowPhotosViewController()<ShowImageViewController>
@property (nonatomic, strong) NSFileManager *fileManager;
@end
@implementation ShowPhotosViewController
@synthesize database = _database;
@synthesize datesAndPhotos = _datesAndPhotos;
@synthesize fileManager = _fileManager;

- (void) deletePictureWithURL:(NSString *)url
atIndexPath:(NSIndexPath *)indexPath 
                   atPosition:(int)position
{
    //delete image from core data
    [ImageForWorkout deleteImageWithURL:url inManagedObjectContext:self.database.managedObjectContext];
    //delete image from file system
    dispatch_queue_t photoQueue = dispatch_queue_create("delete file", NULL);
    dispatch_async(photoQueue, ^{
        if ([[NSFileManager defaultManager] removeItemAtPath:url error:nil]){
            NSLog(@"deleted file at path %@",url);
        }
    });
    NSLog(@"before delete");
    self.datesAndPhotos = [[ActualWorkout photosByDateinManagedObjectContext:self.database.managedObjectContext] mutableCopy];
    NSLog(@"self.datesAndPhotos %@", self.datesAndPhotos);
    [self.tableView reloadData];
}

- (NSMutableArray *) datesAndPhotos 
{
    if (!_datesAndPhotos){
        _datesAndPhotos = [[NSMutableArray alloc] init];
    }
    return _datesAndPhotos;
}


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

    //file manager
    //make file manager
    self.fileManager = [NSFileManager defaultManager];
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dataPath    = [pathList  objectAtIndex:0];
    dataPath = [NSString stringWithFormat:@"%@/%@",dataPath,@"myPhotos"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        //create folder
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; 
    } 

   [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
   [self.tableView setSeparatorColor:[UIColor clearColor]];
    

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
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"texture.png"]];
    [WorkoutHelper openWorkoutPlannerusingBlock:^(UIManagedDocument * workoutPlanner){
        self.database = workoutPlanner; 
        //get photos
        self.datesAndPhotos = [[ActualWorkout photosByDateinManagedObjectContext:self.database.managedObjectContext] mutableCopy];
        [self.tableView reloadData];
    }];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
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
    [self.tableView reloadData];
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.datesAndPhotos count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict = [self.datesAndPhotos objectAtIndex:section];
    NSArray *allKeys = [dict allKeys];
    NSArray *photos = (NSArray *) [dict objectForKey:[allKeys objectAtIndex:0]];

    int mod = [photos count] % noOfPhotosPerRow ;
    if (mod == 0){
        return [photos count] / noOfPhotosPerRow;
    } 
    if ([photos count] < noOfPhotosPerRow) {
        return 1;
    }
    return [photos count] / noOfPhotosPerRow + 1;
    
}


- (UIImage *) getImageForURL : (NSString *) url
{
   
        UIImage *image;
        if ([self.fileManager fileExistsAtPath:url]) {
            image = [UIImage imageWithContentsOfFile:url];
        } 
        return image;
}

- (void) photoClicked: (id) sender
{
    PhotoButtonInCell * button = (PhotoButtonInCell *) sender;
    [self performSegueWithIdentifier:@"show image" sender:button];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PhotoButtonInCell *button = (PhotoButtonInCell *) sender;
    //get url of image
    ShowImageViewController *destination = (ShowImageViewController *) segue.destinationViewController;
    [destination setUrl:button.url];
    [destination setDatabase:self.database];
    [destination setImage:button.image];
    [destination setDelegate:self];
    [destination setIndexPath:button.indexPath];
    [destination setPosition:button.position];
}


- (UITableViewCell *) addPhotosToCell : (UITableViewCell *) cell
                        withIndexPath :(NSIndexPath *) indexPath;
{    
    //remove subviews
    for (UIView * subview in cell.subviews){
        if ([subview isKindOfClass:[PhotoButtonInCell class]])[subview removeFromSuperview];
    }
    
    //photo frames
    PhotoButtonInCell  *photo1 = [[PhotoButtonInCell alloc] init];
    PhotoButtonInCell  *photo2 = [[PhotoButtonInCell alloc] init];
    PhotoButtonInCell  *photo3 = [[PhotoButtonInCell alloc] init];
    
    //photos for section to which cell belongs
    NSDictionary *photoForSection = [self.datesAndPhotos objectAtIndex:indexPath.section];
    NSArray *keys = [photoForSection allKeys];
    NSArray *photosArray = [photoForSection objectForKey:[keys objectAtIndex:0]];
    ImageForWorkout *im ;
    int startPos = noOfPhotosPerRow * indexPath.row;

    CGFloat offsetX = (cell.contentView.bounds.size.width - (noOfPhotosPerRow * thumbnailWidth))/(noOfPhotosPerRow+1);
    if (startPos < [photosArray count] ){ //first photo
        //set properties
        photo1.indexPath = indexPath;
        photo1.position = 1;
        im = (ImageForWorkout *)[photosArray objectAtIndex:startPos];
        photo1.url = im.image_url;
        photo1.image = [self getImageForURL:photo1.url];
        
        //border
        CALayer *layer1 = [photo1 layer];
        layer1.shadowColor = [SHADOW_COLOR_FOR_PHOTO CGColor];
        layer1.shadowOpacity = 0.7f;
        layer1.shadowOffset = CGSizeMake(3.0f, 3.0f);
        layer1.shadowRadius = 5.0f;

        //frame
        photo1.frame = CGRectMake(cell.contentView.frame.origin.x + offsetX + 5, cell.contentView.frame.origin.y + topOffset, thumbnailWidth, thumbnailHeight);
        
        //image
        [photo1 setImage:photo1.image forState:UIControlStateNormal];
        
        //add tap
        [photo1 addTarget:self action:@selector(photoClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell addSubview:photo1];
    }
    startPos ++;

    if (startPos <[photosArray count]){ //second photo
        //set properties
        photo2.indexPath = indexPath;
        photo2.position = 2;
        im = (ImageForWorkout *)[photosArray objectAtIndex:startPos];
        photo2.url = im.image_url;
        photo2.image = [self getImageForURL:photo2.url];
        //border
        CALayer *layer2 = [photo2 layer];
        layer2.shadowColor = [SHADOW_COLOR_FOR_PHOTO CGColor];
        layer2.shadowOpacity = 0.7f;
        layer2.shadowOffset = CGSizeMake(3.0f, 3.0f);
        layer2.shadowRadius = 5.0f;
        
        //frame
        photo2.frame = CGRectMake(cell.contentView.frame.origin.x + 2*offsetX + thumbnailWidth+ 5, cell.contentView.frame.origin.y + topOffset, thumbnailWidth, thumbnailHeight);
        
        //set image
        [photo2 setImage: photo2.image forState:UIControlStateNormal];
        
        [photo2 addTarget:self action:@selector(photoClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell addSubview:photo2];

    }
    
    startPos ++;
    
    if (startPos < [photosArray count]){ // third Photo
        //set properties
        photo3.indexPath = indexPath;
        photo3.position = 3;
        im = (ImageForWorkout *)[photosArray objectAtIndex:startPos];
        photo3.url = im.image_url;
        photo3.image = [self getImageForURL:photo3.url];
        
        //border
        CALayer *layer3 = [photo3 layer];
        
        layer3.shadowColor = [SHADOW_COLOR_FOR_PHOTO CGColor];
        layer3.shadowOpacity = 0.7f;
        layer3.shadowOffset = CGSizeMake(3.0f, 3.0f);
        layer3.shadowRadius = 5.0f;
        
        //frame
        photo3.frame = CGRectMake(cell.contentView.frame.origin.x + 3*offsetX + 2*thumbnailWidth + 5, cell.contentView.frame.origin.y + topOffset, thumbnailWidth, thumbnailHeight);
        
        //set image
        [photo3 setImage: photo3.image forState:UIControlStateNormal];
        
        [photo3 addTarget:self action:@selector(photoClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell addSubview:photo3];

    }
    
    
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"photo";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell = [self addPhotosToCell:cell withIndexPath:indexPath];
    cell.textLabel.text = @"";
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
    customView.backgroundColor = [UIColor clearColor];
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:18];
    headerLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    headerLabel.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    headerLabel.frame = CGRectMake(11,-11, 320.0, 44.0);
    headerLabel.textAlignment = UITextAlignmentLeft;
    
    
    NSDictionary *photoForSection = [self.datesAndPhotos objectAtIndex:section];
    NSArray *keys = [photoForSection allKeys];
    headerLabel.text =[keys objectAtIndex:0];
    [customView addSubview:headerLabel];
    return customView;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableCellHeight;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
