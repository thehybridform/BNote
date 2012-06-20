//
//  ActionItemEntryCell.m
//  BeNote
//
//  Created by Young Kristin on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActionItemEntryCell.h"

@interface ActionItemEntryCell()
@property (strong, nonatomic) UIPopoverController *popup;
@property (strong, nonatomic) DatePickerViewController *datePickerViewController;

@end

@implementation ActionItemEntryCell
@synthesize popup = _popup;
@synthesize datePickerViewController = _datePickerViewController;

- (void)showDatePicker
{    
    ActionItem *actionItem = (ActionItem *) [self entry];
        
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
    ActionItem *actionItem = (ActionItem *) [self entry];
    [actionItem setDueDate:[date timeIntervalSinceReferenceDate]];
    [self updateDetail];
}

- (void)updateDetail
{
    ActionItem *actionItem = (ActionItem *) [self entry];
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
