//
//  ActionItemContentViewController.m
//  BeNote
//
//  Created by Young Kristin on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActionItemContentViewController.h"
#import "BNoteSessionData.h"

@interface ActionItemContentViewController()
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) UIPopoverController *popup;
@property (strong, nonatomic) DatePickerViewController *datePickerViewController;

@end

@implementation ActionItemContentViewController
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self scrollView] removeFromSuperview];
}

- (void)handleTap:(UITapGestureRecognizer *)gesture
{    
    CGPoint location = [gesture locationInView:[self view]];
    if (location.x < 120) {
        [self handleTouch];
    } else {
        [[self mainTextView] becomeFirstResponder];
    }
}

- (void)handleTouch
{
    if (![[BNoteSessionData instance] keyboardVisible]) {
        [self handleImageIcon:YES];
        
        ActionItem *actionItem = [self actionItem];
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        [actionSheet setDelegate:self];
        
        if ([actionItem responsibility]) {
            [actionSheet addButtonWithTitle:clearResponsibility];
        } else {
            [actionSheet addButtonWithTitle:responsibility];
        }
        
        [actionSheet addButtonWithTitle:dueDate];
        if ([actionItem dueDate]) {
            [actionSheet addButtonWithTitle:clearDueDate];
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
    
    [self setActionSheet:nil];
    [self handleImageIcon:NO];
}

- (void)presentResponsibilityPicker
{
    ResponsibilityTableViewController *tableController = [[ResponsibilityTableViewController alloc] initWithNote:[[self actionItem] note]];
    [tableController setDelegate:self];
    
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:tableController];
    [self setPopup:popup];
    
    CGRect rect = [[self imageView] bounds];
    
    [popup presentPopoverFromRect:rect inView:[self view]
         permittedArrowDirections:UIPopoverArrowDirectionAny
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
    
    CGRect rect = [[self imageView] bounds];
    
    [popup presentPopoverFromRect:rect inView:[self view]
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
//    ActionItem *actionItem = [self actionItem];
//    NSString *detail = [BNoteEntryUtils formatDetailTextForActionItem:actionItem];
    
//    if ([BNoteStringUtils nilOrEmpty:detail]) {
//        [[self detail] setText:nil];
//    } else {
//        [[self detail] setText:detail];
//    }
}

- (void)selectedDatePickerViewDone
{
    [[self popup] dismissPopoverAnimated:YES];
    [self setPopup:nil];
    [self setDatePickerViewController:nil];
    [self handleImageIcon:NO];
}


@end
