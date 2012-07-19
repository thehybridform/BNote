//
//  ActionItemContentViewController.m
//  BeNote
//
//  Created by Young Kristin on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActionItemContentViewController.h"
#import "BNoteSessionData.h"
#import "BNoteEntryUtils.h"
#import "LayerFormater.h"
#import "BNoteStringUtils.h"
#import "BNoteEntryUtils.h"

@interface ActionItemContentViewController()
@property (strong, nonatomic) DatePickerViewController *datePickerViewController;
@property (strong, nonatomic) IBOutlet UIButton *dueDateButton;
@property (strong, nonatomic) IBOutlet UIButton *clearDueDateButton;
@property (strong, nonatomic) IBOutlet UIButton *responsibilityButton;
@property (strong, nonatomic) IBOutlet UIButton *clearResponsibilityButton;

@end

@implementation ActionItemContentViewController
@synthesize datePickerViewController = _datePickerViewController;
@synthesize dueDateButton = _dueDateButton;
@synthesize clearDueDateButton = _clearDueDateButton;
@synthesize responsibilityButton = _responsibilityButton;
@synthesize clearResponsibilityButton = _clearResponsibilityButton;

static NSString *responsibility = @"Responsibility";
static NSString *clearResponsibility = @"Clear Responsibility";
static NSString *dueDate = @"Due Date";
static NSString *clearDueDate = @"Clear Due Date";
static NSString *markComplete = @"Mark Complete";
static NSString *markInComplete = @"Mark Not Complete";

- (NSString *)localNibName
{
    return @"ActionItemContentView";
}

- (ActionItem *)actionItem
{
    return (ActionItem *) [self entry];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self dueDateButton] setBackgroundColor:[BNoteConstants appHighlightColor1]];
    [[[self dueDateButton] titleLabel] setFont:[BNoteConstants font:RobotoRegular andSize:12]];
    [LayerFormater roundCornersForView:[self dueDateButton]];
    [LayerFormater setBorderWidth:0 forView:[self dueDateButton]];

    [[self responsibilityButton] setBackgroundColor:[BNoteConstants appHighlightColor1]];
    [[[self responsibilityButton] titleLabel] setFont:[BNoteConstants font:RobotoRegular andSize:12]];
    [LayerFormater roundCornersForView:[self responsibilityButton]];
    [LayerFormater setBorderWidth:0 forView:[self responsibilityButton]];

    [self updateDueDate];
    [self updateResponsibility];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setDueDateButton:nil];
    [self setClearDueDateButton:nil];
}

- (float)height
{
    return MAX(90, [super height]);
}

- (IBAction)showResponsibilityPicker:(id)sender
{
    ResponsibilityTableViewController *tableController =
        [[ResponsibilityTableViewController alloc] initWithNote:[[self actionItem] note]];
    [tableController setDelegate:self];
    
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:tableController];
    [[BNoteSessionData instance] setPopup:popup];
    
    UIView *view = [self responsibilityButton];
    CGRect rect = [view bounds];
    
    [popup presentPopoverFromRect:rect inView:view
         permittedArrowDirections:UIPopoverArrowDirectionAny
                         animated:YES];

    [popup setPopoverContentSize:CGSizeMake(367, 300)];
}

- (IBAction)clearResponsibilityDate:(id)sender
{
    [[self actionItem] setResponsibility:nil];
    [self updateResponsibility];
}

- (void)selectedAttendant:(Attendant *)attendant
{
    NSString *name = [BNoteStringUtils append:[attendant firstName], @" ", [attendant lastName], nil];
    [[self actionItem] setResponsibility:name];
    
    [[[BNoteSessionData instance] popup] dismissPopoverAnimated:YES];
    [[BNoteSessionData instance] setPopup:nil];

    [self updateResponsibility];
}

- (IBAction)clearDueDate:(id)sender
{
    [[self actionItem] setDueDate:0];
    [self updateDueDate];
}

- (IBAction)showDatePicker:(id)sender
{    
    ActionItem *actionItem = [self actionItem];
    
    NSTimeInterval interval = [actionItem dueDate];
    NSDate *date;
    if (interval) {
        date = [NSDate dateWithTimeIntervalSinceReferenceDate:interval];
    } else {
        date = [[NSDate alloc] init];
    }
    
    [actionItem setDueDate:[NSDate timeIntervalSinceReferenceDate]];
    [self updateDueDate];

    DatePickerViewController *controller =
    [[DatePickerViewController alloc] initWithDate:date andMode:UIDatePickerModeDate];
    [controller setListener:self];
    [controller setTitleText:@"Due Date"];
    [[controller datePicker] setDatePickerMode:UIDatePickerModeDate];
    [self setDatePickerViewController:controller];
    
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
    [[BNoteSessionData instance] setPopup:popup];
    [popup setDelegate:self];
    
    [[[BNoteSessionData instance] popup] setPopoverContentSize:[[controller view] bounds].size];
    
    UIView *view = [self dueDateButton];
    CGRect rect = [view bounds];
    
    [popup presentPopoverFromRect:rect inView:view
         permittedArrowDirections:UIPopoverArrowDirectionAny 
                         animated:YES];
}

- (void)dateTimeUpdated:(NSDate *)date
{
    ActionItem *actionItem = [self actionItem];
    [actionItem setDueDate:[date timeIntervalSinceReferenceDate]];
    
    [self updateDueDate];
}

- (void)updateDueDate
{
    if ([[self actionItem] dueDate]) {
        NSDate *dueDate = [NSDate dateWithTimeIntervalSinceReferenceDate:[[self actionItem] dueDate]]; 
        NSString *date = [BNoteStringUtils dateToString:dueDate];
        [[self dueDateButton] setTitle:date forState:UIControlStateNormal];
        [[self clearDueDateButton] setHidden:NO];
    } else {
        [[self dueDateButton] setTitle:@"Due Date" forState:UIControlStateNormal];
        [[self clearDueDateButton] setHidden:YES];
    }
}

- (void)updateResponsibility
{
    if ([[self actionItem] responsibility]) {
        [[self responsibilityButton] setTitle:[[self actionItem] responsibility] forState:UIControlStateNormal];
        [[self clearResponsibilityButton] setHidden:NO];
    } else {
        [[self responsibilityButton] setTitle:@"Responsibility" forState:UIControlStateNormal];
        [[self clearResponsibilityButton] setHidden:YES];
    }
}

- (void)selectedDatePickerViewDone
{
    [[[BNoteSessionData instance] popup] dismissPopoverAnimated:YES];
    [[BNoteSessionData instance] setPopup:nil];
    [self setDatePickerViewController:nil];
    [self handleImageIcon:NO];
}

@end
