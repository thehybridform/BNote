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
@property (strong, nonatomic) IBOutlet UILabel *dueDateLabel;
@property (strong, nonatomic) IBOutlet UIView *dueDateView;
@property (strong, nonatomic) IBOutlet UILabel *responsibilityLabel;
@property (strong, nonatomic) IBOutlet UIView *responsibilityView;
@property (strong, nonatomic) IBOutlet UIView *circleBlankView;
@property (strong, nonatomic) IBOutlet UIView *circleCheckView;
@property (strong, nonatomic) IBOutlet UIView *completionView;
@property (strong, nonatomic) IBOutlet UILabel *completionLabel;

@end

@implementation ActionItemContentViewController
@synthesize datePickerViewController = _datePickerViewController;
@synthesize dueDateLabel = _dueDateLabel;
@synthesize dueDateView = _dueDateView;
@synthesize responsibilityLabel = _responsibilityLabel;
@synthesize responsibilityView = _responsibilityView;
@synthesize circleCheckView = _circleCheckView;
@synthesize completionView = _completionViewView;
@synthesize circleBlankView = _circleBlankView;
@synthesize completionLabel = _completionLabel;

static NSString *responsibility = @"Set Responsibility";
static NSString *clearResponsibility = @"Clear Responsibility";
static NSString *dueDate = @"Due Date";
static NSString *clearDueDate = @"Clear Due Date";

- (id)initWithEntry:(Entry *)entry
{
    self = [super initWithEntry:entry];
    
    if (self) {
        [[self dueDateLabel] setFont:[BNoteConstants font:RobotoLight andSize:11]];
        [[self responsibilityLabel] setFont:[BNoteConstants font:RobotoLight andSize:11]];
        [[self completionLabel] setFont:[BNoteConstants font:RobotoLight andSize:11]];
        
        [[self responsibilityView] setBackgroundColor:[BNoteConstants appColor1]];
        [[self completionView] setBackgroundColor:[BNoteConstants appColor1]];
        [[self dueDateView] setBackgroundColor:[BNoteConstants appColor1]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleResponsibility:)];
        [[self responsibilityView] addGestureRecognizer:tap];
        
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDueDate:)];
        [[self dueDateView] addGestureRecognizer:tap];
        
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCompleted:)];
        [[self completionView] addGestureRecognizer:tap];
    }
    
    return self;
}
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
    
    [self updateDueDate];
    [self updateResponsibility];
    [self updateComplete];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setDueDateView:nil];
    [self setDueDateLabel:nil];
    [self setResponsibilityView:nil];
    [self setResponsibilityLabel:nil];
    [self setCircleCheckView:nil];
    [self setCompletionView:nil];
    [self setCircleBlankView:nil];
    [self setCompletionLabel:nil];
}

- (float)height
{
    return MAX(90, [super height]);
}

- (void)showResponsibilityPicker
{
    ResponsibilityTableViewController *tableController =
        [[ResponsibilityTableViewController alloc] initWithNote:[[self actionItem] note]];
    [tableController setDelegate:self];
    
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:tableController];
    [[BNoteSessionData instance] setPopup:popup];
    
    UIView *view = [self responsibilityView];
    CGRect rect = [view bounds];
    
    [popup presentPopoverFromRect:rect inView:view
         permittedArrowDirections:UIPopoverArrowDirectionAny
                         animated:YES];

    [popup setPopoverContentSize:CGSizeMake(367, 300)];
}

- (void)clearResponsibility
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

- (void)clearDueDate
{
    [[self actionItem] setDueDate:0];
    [self updateDueDate];
}

- (void)showDatePicker
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
    
    UIView *view = [self dueDateView];
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
        [[self dueDateLabel] setText:[BNoteStringUtils append:@"Due on \r\n", date, nil]];
    } else {
        [[self dueDateLabel] setText:@"No Due Date"];
    }
}

- (void)updateResponsibility
{
    if ([[self actionItem] responsibility]) {
        [[self responsibilityLabel] setText:[[self actionItem] responsibility]];
    } else {
        [[self responsibilityLabel] setText:@"Add Responsibility"];
    }
}

- (void)updateComplete
{
    if ([[self actionItem] completed]) {
        [[self circleBlankView] setHidden:YES];
        [[self circleCheckView] setHidden:NO];
        NSDate *dueDate = [NSDate dateWithTimeIntervalSinceReferenceDate:[[self actionItem] dueDate]]; 
        NSString *date = [BNoteStringUtils dateToString:dueDate];
        [[self completionLabel] setText:[BNoteStringUtils append:@"Completed on \r\n", date, nil]];
    } else {
        [[self circleBlankView] setHidden:NO];
        [[self circleCheckView] setHidden:YES];
        [[self completionLabel] setText:@"Not Complete"];
    }
}

- (void)selectedDatePickerViewDone
{
    [[[BNoteSessionData instance] popup] dismissPopoverAnimated:YES];
    [[BNoteSessionData instance] setPopup:nil];
    [self setDatePickerViewController:nil];
    [self handleImageIcon:NO];
}

- (void)handleResponsibility:(id)sender
{
    if ([[self actionItem] responsibility]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        [[BNoteSessionData instance] setActionSheet:actionSheet];
        [actionSheet setDelegate:[BNoteSessionData instance]];
        [[BNoteSessionData instance] setActionSheetDelegate:self];
        
        [actionSheet setTitle:@"Responsibility"];
        [actionSheet addButtonWithTitle:responsibility];
        int index = [actionSheet addButtonWithTitle:clearResponsibility];
        [actionSheet setDestructiveButtonIndex:index];
        
        CGRect rect = [[self responsibilityView] frame];
        [actionSheet showFromRect:rect inView:[self view] animated:YES];
    } else {
        [self showResponsibilityPicker];
    }
}

- (void)handleDueDate:(id)sender
{
    if ([[self actionItem] dueDate]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        [[BNoteSessionData instance] setActionSheet:actionSheet];
        [actionSheet setDelegate:[BNoteSessionData instance]];
        [[BNoteSessionData instance] setActionSheetDelegate:self];
        
        [actionSheet setTitle:@"Due Date"];
        [actionSheet addButtonWithTitle:dueDate];
        int index = [actionSheet addButtonWithTitle:clearDueDate];
        [actionSheet setDestructiveButtonIndex:index];
        
        CGRect rect = [[self dueDateView] frame];
        [actionSheet showFromRect:rect inView:[self view] animated:YES];
    } else {
        [self showDatePicker];
    }
}

- (void)handleCompleted:(id)sender
{
    if ([[self actionItem] completed]) {
        [[self actionItem] setCompleted:0];
    } else {
        [[self actionItem] setCompleted:[NSDate timeIntervalSinceReferenceDate]];
    }
    
    [self updateComplete];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0) {
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if (title == responsibility) {
            [self showResponsibilityPicker];
        } else if (title == clearResponsibility) {
            [self clearResponsibility];
        } else if (title == dueDate) {
            [self showDatePicker];
        } else if (title == clearDueDate) {
            [self clearDueDate];
        }
    }
    
    [[BNoteSessionData instance] setActionSheet:nil];
}


@end
