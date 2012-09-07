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
#import "BNoteFactory.h"

@interface ActionItemContentViewController()
@property (strong, nonatomic) DatePickerViewController *datePickerViewController;
@property (strong, nonatomic) UIButton *responsibilityButton;
@property (strong, nonatomic) UIButton *dueDateButton;
@property (strong, nonatomic) UIButton *completedButton;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation ActionItemContentViewController
@synthesize datePickerViewController = _datePickerViewController;
@synthesize detailLabel = _detailLabel;

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
    
    self.detailLabel = nil;
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
    completedOnDateText = NSLocalizedString(@"Completed On", @"As in 'This action item was ompleted On 12/1/1970'");
    
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

    self.detailLabel.font = [BNoteConstants font:RobotoItalic andSize:14];
    self.detailLabel.textColor = [BNoteConstants appHighlightColor1];
    
    [self updateDetail];
}

- (NSArray *)quickActionButtons
{
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    UIButton *button = [BNoteFactory buttonForImage:@"bnote-calendar.png"];
    self.dueDateButton = button;
    [button addTarget:self action:@selector(handleDueDate:) forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:button];
    
    button = [BNoteFactory buttonForImage:@"bnote-contact.png"];
    self.responsibilityButton = button;
    [button addTarget:self action:@selector(handleResponsibility:) forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:button];
    
    if ([[self actionItem] completed]) {
        button = [BNoteFactory buttonForImage:@"bnote-complete.png"];
    } else {
        button = [BNoteFactory buttonForImage:@"bnote-incomplete.png"];
    }
    
    self.completedButton = button;
    [button addTarget:self action:@selector(handleCompleted:) forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:button];
    
    return buttons;
}

- (float)height
{
    if ([BNoteStringUtils nilOrEmpty:self.detailLabel.text]) {
        return [super height];
    } else {
        UITextView *view = [[UITextView alloc] init];
        [view setText:[[self entry] text]];
        [view setFont:[BNoteConstants font:RobotoRegular andSize:16]];
        [view setFrame:CGRectMake(0, 0, [self width] - 100, 40)];
        return MAX(60, [view contentSize].height + 60);
    }
}

- (void)showResponsibilityPicker
{
    ResponsibilityTableViewController *tableController =
        [[ResponsibilityTableViewController alloc] initWithNote:[[self actionItem] note]];
    [tableController setDelegate:self];
    
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:tableController];
    [[BNoteSessionData instance] setPopup:popup];
    
    UIView *view = self.responsibilityButton;
    CGRect rect = [view bounds];
    
    [popup presentPopoverFromRect:rect inView:view
         permittedArrowDirections:UIPopoverArrowDirectionAny
                         animated:NO];

    [popup setPopoverContentSize:CGSizeMake(367, 300)];
}

- (void)clearResponsibility
{
    [self actionItem].attendant = nil;
    [self updateDetail];
}

- (void)selectedAttendant:(Attendant *)attendant
{
    [self actionItem].attendant = attendant;
    
    [[[BNoteSessionData instance] popup] dismissPopoverAnimated:YES];
    [[BNoteSessionData instance] setPopup:nil];

    [self updateDetail];
}

- (void)clearDueDate
{
    [[self actionItem] setDueDate:0];
    [self updateDetail];
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
    [self updateDetail];

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
    
    UIView *view = self.dueDateButton;
    CGRect rect = [view bounds];
    
    [popup presentPopoverFromRect:rect inView:view
         permittedArrowDirections:UIPopoverArrowDirectionAny 
                         animated:NO];
}

- (void)dateTimeUpdated:(NSDate *)date
{
    ActionItem *actionItem = [self actionItem];
    [actionItem setDueDate:[date timeIntervalSinceReferenceDate]];
    
    [self updateDetail];
}

- (void)updateDetail
{
    NSString *detail = @"";
    
    if ([[self actionItem] completed]) {
        NSDate *completedDate = [NSDate dateWithTimeIntervalSinceReferenceDate:[[self actionItem] completed]];
        NSString *date = [BNoteStringUtils dateToString:completedDate];
        detail = [BNoteStringUtils append:detail, @" (", completedOnDateText, @": ", date, @") ", nil];
    }
    
    if ([[self actionItem] dueDate]) {
        NSDate *dueDate = [NSDate dateWithTimeIntervalSinceReferenceDate:[[self actionItem] dueDate]];
        NSString *date = [BNoteStringUtils dateToString:dueDate];
        detail = [BNoteStringUtils append:detail, @" (", dueOnText, @": ", date, @") ", nil];
    }

    if ([[self actionItem] attendant]) {
        Attendant *attendant = [self actionItem].attendant;
        NSString *name  = [BNoteStringUtils append:attendant.firstName, @" ", attendant.lastName, @") ", nil];
        detail = [BNoteStringUtils append:detail, @" (", name, nil];
    }

    self.detailLabel.text = detail;

    if ([BNoteStringUtils nilOrEmpty:detail]) {
        self.detailLabel.hidden = YES;
    } else {
        self.detailLabel.hidden = NO;
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
    if ([[self actionItem] attendant]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        [[BNoteSessionData instance] setActionSheet:actionSheet];
        [actionSheet setDelegate:[BNoteSessionData instance]];
        [[BNoteSessionData instance] setActionSheetDelegate:self];
        
        [actionSheet setTitle:responsibilityOptionsText];
        [actionSheet addButtonWithTitle:setResponsibilityText];
        int index = [actionSheet addButtonWithTitle:clearResponsibilityText];
        [actionSheet setDestructiveButtonIndex:index];
        
        UIView *view = self.responsibilityButton;
        CGRect rect = view.frame;
        [actionSheet showFromRect:rect inView:view animated:NO];
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
        
        UIView *view = self.dueDateButton;
        CGRect rect = view.frame;
        [actionSheet showFromRect:rect inView:view animated:NO];
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
    
    [self updateDetail];
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
