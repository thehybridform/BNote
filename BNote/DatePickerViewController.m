//
//  DatePickerViewController.m
//  BNote
//
//  Created by Young Kristin on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DatePickerViewController.h"
#import "LayerFormater.h"

@interface DatePickerViewController ()
@property (strong, nonatomic) NSDate *date;
@property (assign, nonatomic) UIDatePickerMode mode;
@end

@implementation DatePickerViewController
@synthesize listener = _listener;
@synthesize datePicker = _datePicker;
@synthesize date = _date;
@synthesize titleText = _titleText;
@synthesize mode = _mode;

- (id)initWithDate:(NSDate *)date
{
    return [self initWithDate:date andMode:UIDatePickerModeDateAndTime];
}

- (id)initWithDate:(NSDate *)date andMode:(UIDatePickerMode)mode
{
    self = [super initWithNibName:@"DatePickerViewController" bundle:nil];
    if (self) {
        [self setDate:date];
        [self setMode:mode];
    }
    return self;
}


- (IBAction)updateDateTime:(id)sender
{
    UIDatePicker *picker = sender;
    [[self listener] dateTimeUpdated:[picker date]];
}

- (IBAction)didFinish:(id)sender
{
    [[self listener] selectedDatePickerViewDone];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self datePicker] setMinuteInterval:5];
    [[self datePicker] setDate:[self date]];
    [[self datePicker] setDatePickerMode:[self mode]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setDatePicker:nil];
    [self setDate:nil];
    [self setTitleText:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
