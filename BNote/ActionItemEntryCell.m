//
//  ActionItemEntryCell.m
//  BeNote
//
//  Created by Young Kristin on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActionItemEntryCell.h"

@interface ActionItemEntryCell()
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) UIPopoverController *popup;
@property (strong, nonatomic) DatePickerViewController *datePickerViewController;

@end

@implementation ActionItemEntryCell
@synthesize actionSheet = _actionSheet;
@synthesize popup = _popup;
@synthesize datePickerViewController = _datePickerViewController;

static NSString *responsibility = @"Responsibility";
static NSString *clearResponsibility = @"Clear Responsibility";
static NSString *dueDate = @"Due Date";
static NSString *clearDueDate = @"Clear Due Date";
static NSString *markComplete = @"Mark Complete";
static NSString *markInComplete = @"Mark In Complete";

- (ActionItem *)actionItem
{
    return (ActionItem *) [self entry];
}

- (void)setup
{
    [super setup];
    
    UITapGestureRecognizer *tap =
     [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showActionItemOptions:)];
    [self addGestureRecognizer:tap];
}


- (void)showActionItemOptions:(UITapGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self];
    if (location.x < 120) {
        [self handleImageIcon:YES];
        
        ActionItem *actionItem = [self actionItem];
            
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        [actionSheet setDelegate:self];

        if ([actionItem responsibility]) {
            [actionSheet addButtonWithTitle:clearResponsibility];
        } else {
            [actionSheet addButtonWithTitle:responsibility];
        }
            
        if ([actionItem dueDate]) {
            [actionSheet addButtonWithTitle:clearDueDate];
        } else {
            [actionSheet addButtonWithTitle:dueDate];
        }
            
        if ([actionItem completed]) {
            [actionSheet addButtonWithTitle:markInComplete];
        } else {
            [actionSheet addButtonWithTitle:markComplete];
        }            
        
        [actionSheet setTitle:@"Action Item"];
        [self setActionSheet:actionSheet];
        
        CGRect rect = [[self imageView] bounds];
        [actionSheet showFromRect:rect inView:[self imageView] animated:YES];

    } else {
        [[self textView] becomeFirstResponder];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0) {
        ActionItem *actionItem = [self actionItem];
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if (title == clearResponsibility) {
            [actionItem setResponsibility:nil];
        } else if (title == responsibility) {
            [self presentResponsibilityPicker];
        } else if (title == dueDate) {
            [self showDatePicker];
        } else if (title == clearDueDate) {
            [actionItem setDueDate:0];
        } else if (title == markComplete) {
            [actionItem setCompleted:[NSDate timeIntervalSinceReferenceDate]]; 
        } else if (title == markInComplete) {
            [actionItem setCompleted:0]; 
        }
    }
}

- (void)presentResponsibilityPicker
{
    ResponsibilityTableViewController *tableController = [[ResponsibilityTableViewController alloc] initWithNote:[[self actionItem] note]];
    [tableController setDelegate:self];
    
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:tableController];
    [self setPopup:popup];
    
    UIView *view = self;
    CGRect rect = [view bounds];
    
    [popup presentPopoverFromRect:rect inView:view
         permittedArrowDirections:UIPopoverArrowDirectionUp 
                         animated:YES];
}

- (void)selectedAttendant:(Attendant *)attendant
{
    NSString *name = [BNoteStringUtils append:[attendant firstName], @" ", [attendant lastName], nil];
    [[self actionItem] setResponsibility:name];
    
    [[self popup] dismissPopoverAnimated:YES];
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
        
    DatePickerViewController *controller =
        [[DatePickerViewController alloc] initWithDate:date andMode:UIDatePickerModeDate];
    [controller setListener:self];
    [controller setTitleText:@"Due Date"];
    [[controller datePicker] setDatePickerMode:UIDatePickerModeDate];
    [self setDatePickerViewController:controller];
        
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
    [self setPopup:popup];
    [popup setDelegate:self];
        
    [popup setPopoverContentSize:[[controller view] bounds].size];
        
    UIView *view = self;
    CGRect rect = [view bounds];
        
    [popup presentPopoverFromRect:rect inView:self
        permittedArrowDirections:UIPopoverArrowDirectionAny 
        animated:YES];
}

- (void)dateTimeUpdated:(NSDate *)date
{
    ActionItem *actionItem = [self actionItem];
    [actionItem setDueDate:[date timeIntervalSinceReferenceDate]];
    [self updateDetail];
}

- (void)updateDetail
{
    ActionItem *actionItem = [self actionItem];
    NSString *detail = [BNoteEntryUtils formatDetailTextForActionItem:actionItem];
        
    if ([BNoteStringUtils nilOrEmpty:detail]) {
        [[self detail] setText:nil];
    } else {
        [[self detail] setText:detail];
    }
}

- (void)selectedDatePickerViewDone
{
    [[self popup] dismissPopoverAnimated:YES];
    [self setPopup:nil];
    [self setDatePickerViewController:nil];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self setPopup:nil];
    [self setDatePickerViewController:nil];
}


@end
