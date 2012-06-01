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
@end

@implementation DatePickerViewController
@synthesize doneButton = _doneButton;
@synthesize listener = _listener;
@synthesize datePicker = _datePicker;
@synthesize date = _date;
@synthesize toolBar = _toolbar;

- (id)initWithDate:(NSDate *)date
{
    self = [super initWithNibName:@"DatePickerViewController" bundle:nil];
    if (self) {
        [self setDate:date];
    }
    return self;
}

- (IBAction)updateDateTime:(id)sender
{
    UIDatePicker *picker = sender;
    [[self listener] dateTimeUpdated:[picker date]];
}

- (void)didFinish:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    [[self listener] didFinishDatePicker];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [LayerFormater roundCornersForView:[self toolBar]];
    [LayerFormater roundCornersForView:[self datePicker]];
    [[self datePicker] setMinuteInterval:5];
    [[self datePicker] setDate:[self date]];
    
    UITapGestureRecognizer *normalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didFinish:)];
    [[self view] addGestureRecognizer:normalTap];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setDoneButton:nil];
    [self setDatePicker:nil];
    [self setDate:nil];
    [self setToolBar:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
