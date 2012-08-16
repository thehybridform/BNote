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
#import "BNoteAnimation.h"

@interface ActionItemContentViewController()
@property (strong, nonatomic) DatePickerViewController *datePickerViewController;
@property (strong, nonatomic) IBOutlet UILabel *dueDateLabel;
@property (strong, nonatomic) IBOutlet UIView *dueDateView;
@property (strong, nonatomic) IBOutlet UILabel *responsibilityLabel;
@property (strong, nonatomic) IBOutlet UIView *responsibilityView;
@property (strong, nonatomic) IBOutlet UIView *caledarBlankView;
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
@synthesize caledarBlankView = _caledarBlankView;

static NSString *responsibilityOptionsText;
static NSString *setResponsibilityText;
static NSString *clearResponsibilityText;
static NSString *noResponsibilityText;

static NSString *dueDateOptionsText;
static NSString *setDueDateText;
static NSString *clearDueDateText;
static NSString *dueDateText;
static NSString *noDueDateText;
static NSString *dueOnText;

static NSString *notCompleteText;
static NSString *completedOnDateText;

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
    [self setCaledarBlankView:nil];
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
    
    notCompleteText = NSLocalizedString(@"Not Complete", @"This action item is not complete");
    completedOnDateText = NSLocalizedString(@"Completed on", @"As in 'This action item was ompleted On 12/1/1970'");
    
    noResponsibilityText = NSLocalizedString(@"No Responsibility", @"This action item has no resposibility assigned");
    responsibilityOptionsText = NSLocalizedString(@"Responsibility Options", @"Responsibility options menu title");
    setResponsibilityText = NSLocalizedString(@"Set Responsibility", @"Set the responsibility for this action item");
    clearResponsibilityText = NSLocalizedString(@"Clear Responsibility", @"Clear the responsibility for this action item");
    
    noDueDateText = NSLocalizedString(@"No Due Date", @"This action item has no due date");
    dueDateText = NSLocalizedString(@"Due Date", @"Due date label");
    dueDateOptionsText = NSLocalizedString(@"Due Date Options", @"Due date options menu title");
    setDueDateText = NSLocalizedString(@"Set Due Date", @"Set the due date for this action item");
    clearDueDateText = NSLocalizedString(@"Clear Due Date", @"Clear the due date for this action item");
    dueOnText = NSLocalizedString(@"Due On", @"As in 'This action item is due on 12/1/1970'");

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

    [self updateDueDate];
    [self updateResponsibility];
    [self updateComplete];
}

- (float)height
{
    UITextView *view = [[UITextView alloc] init];
    [view setText:[[self entry] text]];
    [view setFont:[BNoteConstants font:RobotoRegular andSize:16]];
    [view setFrame:CGRectMake(0, 0, [self width] - 200, 90)];
    
    return MAX(90, [view contentSize].height + 10);
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
                         animated:NO];

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
    [controller setTitleText:dueDateText];
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
                         animated:NO];
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
        [[self dueDateLabel] setText:[BNoteStringUtils append:dueOnText, @"\r\n", date, nil]];
        [[self caledarBlankView] setHidden:YES];
    } else {
        [[self dueDateLabel] setText:noDueDateText];
        [[self caledarBlankView] setHidden:NO];
    }
}

- (void)updateResponsibility
{
    if ([[self actionItem] responsibility]) {
        [[self responsibilityLabel] setText:[[self actionItem] responsibility]];
    } else {
        [[self responsibilityLabel] setText:noResponsibilityText];
    }
}

- (void)updateComplete
{
    if ([[self actionItem] completed]) {
        [[self circleBlankView] setHidden:YES];
        [[self circleCheckView] setHidden:NO];
        NSDate *dueDate = [NSDate dateWithTimeIntervalSinceReferenceDate:[[self actionItem] completed]]; 
        NSString *date = [BNoteStringUtils dateToString:dueDate];
        [[self completionLabel] setText:[BNoteStringUtils append:completedOnDateText, @"\r\n", date, nil]];
    } else {
        [[self circleBlankView] setHidden:NO];
        [[self circleCheckView] setHidden:YES];
        [[self completionLabel] setText:notCompleteText];
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
        
        [actionSheet setTitle:responsibilityOptionsText];
        [actionSheet addButtonWithTitle:setResponsibilityText];
        int index = [actionSheet addButtonWithTitle:clearResponsibilityText];
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
        
        [actionSheet setTitle:dueDateOptionsText];
        [actionSheet addButtonWithTitle:setDueDateText];
        int index = [actionSheet addButtonWithTitle:clearDueDateText];
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
        if (title == setResponsibilityText) {
            [self showResponsibilityPicker];
        } else if (title == clearResponsibilityText) {
            [self clearResponsibility];
        } else if (title == setDueDateText) {
            [self showDatePicker];
        } else if (title == clearDueDateText) {
            [self clearDueDate];
        }
    }
    
    [[BNoteSessionData instance] setActionSheet:nil];
}

- (void)showControls
{
    NSArray *views = [[NSArray alloc]
                      initWithObjects:
                      [self responsibilityView],
                      [self dueDateView],
                      [self completionView],
                      [self circleBlankView],
                      [self circleCheckView],
                      [self caledarBlankView],
                      [self completionLabel],
                      [self dueDateLabel],
                      [self responsibilityLabel],
                      nil];
    [BNoteAnimation winkInView:views withDuration:0.1 andDelay:0.5 andDelayIncrement:0.08 spark:NO];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
