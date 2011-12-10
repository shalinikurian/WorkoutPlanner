//
//  LogAWorkoutViewController.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/29/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "LogAWorkoutViewController.h"
#import "Exercise.h"
#import "GetSetForExerciseFromUserViewController.h"
#import "ActualWorkout+Create.h"
#import "ImageForWorkout+createImage.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface LogAWorkoutViewController()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, GetSetForExerciseFromUserViewController>
@property (strong, nonatomic) IBOutlet UITableView *workoutDetails;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UITextView *workoutDescription;
@property (strong, nonatomic) UITextField *workoutNameTextField;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) NSDate *startDate;
@property (nonatomic) bool expandCell;
@property (strong, nonatomic) IBOutlet UITableView *exercisesTable;
@property (strong, nonatomic) NSFileManager *fileManager;
@property (strong, nonatomic) UIButton *photoButton;
@property (strong, nonatomic) NSMutableArray *logForSets;
@property (nonatomic) bool threadStarted;
@property (strong, nonatomic) NSMutableArray *imageUrls;
@property (nonatomic) int imageNo;
@end
@implementation LogAWorkoutViewController
@synthesize workoutDetails = _workoutDetails;
@synthesize scrollView = _scrollView;
@synthesize workoutNameTextField = _workoutNameTextField;
@synthesize timerLabel = _timerLabel;
@synthesize workoutDescription = _workoutDescription;
@synthesize database = _database;
@synthesize workout = _workout;
@synthesize expandCell = _expandCell;
@synthesize exercisesTable = _exercisesTable;
@synthesize startDate = _startDate;
@synthesize exercises = _exercises;
@synthesize setsInExercises = _setsInExercises;
@synthesize photoButton = _photoButton;
@synthesize threadStarted = _threadStarted;
@synthesize fileManager = _fileManager;
@synthesize logForSets = _logForSets;
@synthesize imageUrls = _imageUrls;
@synthesize imageNo = _imageNo;

- (int) imageNo
{
    if (!_imageNo){
        _imageNo = 0;

    }
    return  _imageNo;
}
- (NSMutableArray *) imageUrls
{
    if (!_imageUrls){
        _imageUrls = [[NSMutableArray alloc] init];
    }
    return _imageUrls;
}
- (NSMutableArray *) logForSets
{
    if (!_logForSets){
        _logForSets = [[NSMutableArray alloc] initWithCapacity:[self.exercises count]];
        //initialize with zeros
        for (int i = 0; i< [self.exercises count] ; i++ ){
            //store a nsmutablearray for sets
            NSInteger countOfSet = [[self.setsInExercises objectAtIndex:i] count];
            NSMutableArray *sets = [[NSMutableArray alloc] initWithCapacity:countOfSet];
            for (int j = 0; j <countOfSet ; j++){
            //each set is a nsdictionary of reps and weight          
                NSDictionary *setDictionary =  [NSDictionary dictionaryWithObjectsAndKeys:
                                                [NSNumber numberWithInt:0], @"reps",
                                                [NSNumber numberWithInt:0], @"weight",
                                                nil];  
                [sets addObject:setDictionary];
            }
            [_logForSets addObject:sets];
        }
    }
    return _logForSets;
}

- (NSMutableArray*) exercises
{
    if (!_exercises){
        _exercises = [[NSMutableArray alloc] init];
    }
    return _exercises;
}

- (NSMutableArray*) setsInExercises
{
    if (!_setsInExercises){
        _setsInExercises = [[NSMutableArray alloc] init];
    }
    return _setsInExercises;
}

- (NSDate *) startDate
{
    if(!_startDate){
       _startDate = [NSDate date];
    }    
    return _startDate; 
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)saveLog:(UIBarButtonItem *)sender {
    //stop timer, get duration , other data and store in acutal workout
    //stop the timer loop
    CFRunLoopStop([[NSRunLoop currentRunLoop] getCFRunLoop]);
    //get current time and date
    NSDate *currDateTime = [NSDate date];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"yy/mm/dd hh:mm:ss"];
    NSTimeInterval diff = [currDateTime timeIntervalSinceDate:self.startDate]; //duration for current workout
    NSInteger secs = (NSInteger) diff;
    [ActualWorkout createLogForWorkout:self.workout
                  withSetsForExercises:self.logForSets
                          forExercises:self.exercises
                 withDurationInSeconds:secs
                              withDate:currDateTime
                            withImages:self.imageUrls
                inManagedObjectContext:self.database.managedObjectContext];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (IBAction)cancelLogClicked:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.delegate = self;
    [self.workoutDetails setDelegate:self];
    self.workoutDetails.scrollEnabled = NO;
    self.workoutNameTextField.enabled = NO;
    self.workoutDescription.editable = NO;
    [self.workoutDetails setDataSource:self];
    [self.exercisesTable setDataSource:self];
    [self.exercisesTable setDelegate:self];
    //file manager
    //make file manager
    self.fileManager = [NSFileManager defaultManager];
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dataPath    = [pathList  objectAtIndex:0];
    dataPath = [NSString stringWithFormat:@"%@/%@",dataPath,@"WorkoutPlannerPhotos"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        //create folder
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; 
    } 

}

- (void) startTimer: (NSTimer *) timer
{
    //get current time 
    NSDate *currDateTime = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"hh:mm:ss"];
    NSTimeInterval diff = [currDateTime timeIntervalSinceDate:self.startDate];
    NSInteger ti = (NSInteger)diff;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    self.timerLabel.text =  [NSString stringWithFormat:@"Duration: %02i:%02i:%02i", hours, minutes, seconds];
    
}
- (void) setupTimerThread
{
    self.timerLabel.text = @"Duration: 00:00:00";
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0 
                                                      target:self 
                                                    selector:@selector(startTimer:) 
                                                    userInfo:nil 
                                                     repeats:YES];
  
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
    [runLoop run];
}

- (void) clickPhoto: (id) sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if ([mediaTypes containsObject:(NSString *)kUTTypeImage]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing = YES;
            [self presentModalViewController:picker animated:YES];
        }
    }
}

- (void)dismissImagePicker
{
    [self dismissModalViewControllerAnimated:YES];
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image) {
        NSLog(@"got the image");
        //store in core data
        
        //delete all photos
       /* NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dataPath    = [pathList  objectAtIndex:0];
        dataPath = [NSString stringWithFormat:@"%@/%@",dataPath,@"WorkoutPlannerPhotos"];
        NSFileManager *manager = [NSFileManager defaultManager];
        NSError *error = nil;
        NSArray *files = [manager contentsOfDirectoryAtPath:dataPath 
                                                      error:&error];
        
        if(error) {
            //deal with error and bail.
        }
        
        for(NSString *file in files) {
            [manager removeItemAtPath:[dataPath stringByAppendingPathComponent:file]
                                error:&error];
            if(error) {
                //an error occurred...
            }
        } */
        dispatch_queue_t photoQueue = dispatch_queue_create("write picture to file", NULL);
        dispatch_async(photoQueue, ^{
            //save the image 
            NSData * data = UIImagePNGRepresentation(image);
            NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *dataPath    = [pathList  objectAtIndex:0];
            dataPath = [NSString stringWithFormat:@"%@/%@",dataPath,@"WorkoutPlannerPhotos"];
            //give unique name to image workout_id + autoincrement number
            self.imageNo = self.imageNo + [ImageForWorkout imageIdAvailableForUseForNewImageInManagedObjectContext:self.database.managedObjectContext];
            NSString * imageName =  [NSString stringWithFormat:@"%d_%d",self.workout.workoutId,self.imageNo];
            NSString *imagePath = [NSString stringWithFormat:@"%@/%@",dataPath,imageName];
            if (![self.fileManager fileExistsAtPath:imagePath]) {
                [data writeToFile:imagePath atomically:YES];
                [self.imageUrls addObject:imagePath];
                NSLog(@"added file");
            } else {
                NSLog(@"exists");
            }
        });
        dispatch_release(photoQueue);
    }
    [self dismissImagePicker];
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    //add photo icon
    self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.photoButton.backgroundColor = [UIColor clearColor];
    UIImage *img = [UIImage imageNamed:@"camera.jpeg"];
    [self.photoButton setImage:img forState:UIControlStateNormal];
    [self.photoButton addTarget:self action:@selector(clickPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.photoButton setFrame:CGRectMake(0, 8, 50, 50)];
    [self.scrollView addSubview:self.photoButton];

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissImagePicker];
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.threadStarted) {
        self.threadStarted = YES;
        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(setupTimerThread) object:nil];
        [thread start];
    }
}
- (void)viewDidUnload
{
    [self setWorkoutDetails:nil];
    [self setScrollView:nil];
    [self setTimerLabel:nil];
    [self setExercisesTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.workoutDetails) return 1;
    if (tableView == self.exercisesTable) return [self.exercises count];
    return 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.workoutDetails) return 1; 
    if (tableView == self.exercisesTable) {
        return MAX([[self.setsInExercises objectAtIndex:section] count], 1);
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.workoutDetails == tableView && self.expandCell) return 100;
    return 35;
}

- (UITextField *) workoutNameTextField {
    if(!_workoutNameTextField){
        _workoutNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20,10,200,21)];
    }
    return _workoutNameTextField;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.workoutDetails){
        //show date for workout log
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"MM/dd/yyyy"];
        return [dateFormat stringFromDate:date];  
    }
    Exercise *exercise = (Exercise *)[self.exercises objectAtIndex:section];
    return exercise.name;
}
- (UITableViewCell *) configureCellForWorkout: (UITableViewCell *) cell
                                   atIndexPath:(NSIndexPath *)indexPath{
    self.workoutNameTextField.text = self.workout.name;
    [cell addSubview:self.workoutNameTextField];
    
    if (self.expandCell){
        self.workoutDescription = [[UITextView alloc] initWithFrame:CGRectMake(20,40,cell.bounds.size.width-30,50)];
        self.workoutDescription.text = self.workout.workoutDescription;
        [cell addSubview:self.workoutDescription];
    } else {
        [self.workoutDescription removeFromSuperview];
    }
    return cell;

    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.workoutDetails){
        static NSString *CellIdentifier = @"workout details";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.editing = NO;
        }
        
        
        cell = [self configureCellForWorkout:cell atIndexPath:indexPath];
        return cell;

    }
    static NSString *CellIdentifier = @"exercise in log";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    NSMutableArray *sets = [[self.setsInExercises objectAtIndex:indexPath.section] mutableCopy];
    if ([sets count] > 0){
        NSDictionary *set = (NSDictionary *) [sets objectAtIndex:indexPath.row];
        cell.textLabel.text =  cell.textLabel.text = [NSString stringWithFormat:@"%@ reps X %@ lb", [set objectForKey:@"reps"],[set objectForKey:@"weight"]];
    } else {
        cell.textLabel.text = @"No sets";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.accessoryView removeFromSuperview];
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.workoutDetails){
        self.expandCell = !self.expandCell;
        NSArray *array = [NSArray arrayWithObject: indexPath];
        [self.workoutDetails reloadRowsAtIndexPaths: array
                                  withRowAnimation: UITableViewRowAnimationAutomatic];
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSMutableArray *sets = [[self.setsInExercises objectAtIndex:indexPath.section] mutableCopy];
    if ([sets count] >0 ){
        [self performSegueWithIdentifier:@"enter set" sender:cell];
    }
}

- (void) weightForExercise:(NSString *)weight
            repForExercise:(NSString *)rep 
                  forSetNo:(NSInteger)setNo 
             forExerciseNo:(NSInteger)exerciseNo
{
    NSLog(@"exercise no set no rep weight %d,%d,%@,%@",exerciseNo,setNo,rep,weight);
    NSDictionary *setDictionary =  [NSDictionary dictionaryWithObjectsAndKeys:
                                     rep, @"reps",
                                     weight, @"weight",
                                     nil];  
    [[self.logForSets objectAtIndex:exerciseNo] replaceObjectAtIndex:setNo withObject:setDictionary];
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.exercisesTable indexPathForCell:sender];
    GetSetForExerciseFromUserViewController *destination = (GetSetForExerciseFromUserViewController*) segue.destinationViewController;
    [destination setDelegate:self];
    [destination setSetNo:indexPath.row];
    [destination setExerciseNo:indexPath.section];
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
