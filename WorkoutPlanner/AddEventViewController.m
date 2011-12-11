//
//  AddEventViewController.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 12/11/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "AddEventViewController.h" 
#import "GetDateViewController.h"
#import <EventKit/EventKit.h>
@interface AddEventViewController()<UITextFieldDelegate, GetDateViewController , UIAlertViewDelegate >
@property (nonatomic, strong) NSDate *sDate;
@property (nonatomic, strong) NSDate *eDate;
@end
@implementation AddEventViewController
@synthesize startTime = _startTime;
@synthesize endTime = _endTime;
@synthesize eventName = _eventName;
@synthesize eventNameText = _eventNameText;
@synthesize sDate = _sDate;
@synthesize eDate = _eDate;

- (IBAction)saveEvent:(id)sender {
    EKEventStore *eventDB = [[EKEventStore alloc] init];
    
    EKEvent *event  = [EKEvent eventWithEventStore:eventDB];
    event.title = self.eventNameText;
    event.startDate = self.sDate;
    event.endDate   = self.eDate;
    event.allDay = NO;
    NSLog(@"event name %@",self.eventNameText);
    
    [event setCalendar:[eventDB defaultCalendarForNewEvents]];
    NSError *err;
    [eventDB saveEvent:event span:EKSpanThisEvent error:&err];
    if (!err) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Event Created"
                              message:self.eventName.text
                              delegate:self
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles:nil];
        [alert show];
    } else {
        NSLog(@"error %@",[err description]);
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Event Not Created"
                              message:[err description]
                              delegate:self
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles:nil];
        [alert show];
    }
    
}
- (void) alertView: (UIAlertView *) alertView
    clickedButtonAtIndex: (NSInteger) buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) datePicked:(NSDate *)date
          startDate:(bool)startDatePicked
{
    NSLog(@"date picked %@",date);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy h:mm a"];
    if (startDatePicked) {
        self.sDate = date;
        NSLog(@"date format %@",[dateFormat stringFromDate:date]);
        self.startTime.text = [dateFormat stringFromDate:date];
    } else {
        self.eDate = date;
        self.endTime.text = [dateFormat stringFromDate:date];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.startTime || textField == self.endTime) {
        [textField resignFirstResponder];
        [self performSegueWithIdentifier:@"add date" sender:textField];
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.eventName) self.eventNameText = textField.text;
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITextField *dateChosen = (UITextField *) sender;
    if([segue.identifier isEqualToString:@"add date"]) {
        GetDateViewController *getDate = segue.destinationViewController;
        [getDate setDelegate:self];
        if (dateChosen == self.startTime) {
            [getDate setStartDate:YES];
        }
    }
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.startTime.delegate = self;
    self.endTime.delegate = self;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"texture.png"]];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.2 alpha:1.0];
    
    self.eventName.placeholder = self.eventNameText;
    NSDate * date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy h:mm a"];
    self.startTime.placeholder = [dateFormat stringFromDate:date];
    self.endTime.placeholder = [dateFormat stringFromDate:date];
    
    
    self.sDate = date;
    self.eDate = date;
}
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [self setStartTime:nil];
    [self setEndTime:nil];
    [self setEventName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
