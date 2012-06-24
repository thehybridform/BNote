//
//  AttendantTableViewCell.m
//  BeNote
//
//  Created by Young Kristin on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AttendantTableViewCell.h"
#import "LayerFormater.h"
#import "AttendantsViewController.h"
#import "EntriesViewController.h"
#import "BNoteFactory.h"
#import "BNoteWriter.h"
#import "BNoteEntryUtils.h"
#import "AttendeeDetailViewController.h"

@interface AttendantTableViewCell()
@property (strong, nonatomic) AttendantsViewController *attendantsViewController;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) ABPeoplePickerNavigationController *peoplePicker; 
@property (strong, nonatomic) Attendant *selectedAttendant;
@property (strong, nonatomic) UIPopoverController *popup;
@end

@implementation AttendantTableViewCell
@synthesize attendantsViewController = _attendantsViewController;
@synthesize actionSheet = _actionSheet;
@synthesize peoplePicker = _peoplePicker;
@synthesize selectedAttendant = _selectedAttendant;
@synthesize popup = _popup;

- (void)setup
{
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAttendatsOptions:)];
    [self addGestureRecognizer:tap];

    [[self textLabel] removeFromSuperview];
    [[self detailTextLabel] removeFromSuperview];
    
    [self handleImageIcon:NO];

    CGRect rect = CGRectMake(100, 5, 200, 90);
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:rect];
    
    [[self contentView] addSubview:view];
    [view setAutoresizingMask:(UIViewAutoresizingFlexibleRightMargin |
                               UIViewAutoresizingFlexibleBottomMargin |
                               UIViewAutoresizingFlexibleWidth)];
    
    AttendantsViewController *controller = [[AttendantsViewController alloc] init];
    [controller setView:view];
    [controller setAttendants:[self attendants]];
    [self setAttendantsViewController:controller];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardDidHideNotification object:nil];

    [controller update];
}

- (Attendants *)attendants
{
    return (Attendants *) [self entry];
}

- (void)showAttendatsOptions:(UITapGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self];
    if (location.x < 120) {
        [self handleImageIcon:YES];

        if (![self actionSheet]) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Attendees" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add Attendee", @"Create Attendee", nil];
            [self setActionSheet:actionSheet];
        
            CGRect rect = [[self imageView] bounds];
            [actionSheet showFromRect:rect inView:self animated:YES];
        }
    }
}

- (void)unfocus
{
    [self handleImageIcon:NO];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self presentAttendeePicker];
            break;
            
        case 1:
            [self presentAttendeeAdder];
            break;
            
        default:
            break;
    }
    
    [self setActionSheet:nil];
}

- (void)presentAttendeePicker
{
    if ([self peoplePicker]) {
        [self finishedContactPicker];
    } else {
        ABPeoplePickerNavigationController *controller = [[ABPeoplePickerNavigationController alloc] init];
        [self setPeoplePicker:controller];
        
        [controller setPeoplePickerDelegate:self];
        [controller setModalPresentationStyle:UIModalPresentationPageSheet];
        [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [[self parentController] presentModalViewController:controller animated:YES];
    }
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    if ([self selectedAttendant]) {
        [self setSelectedAttendant:nil];
    }
    
    NSString *firstname = (__bridge NSString *) ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastname = (__bridge NSString *) ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSData *image = (__bridge NSData *) ABPersonCopyImageData(person);
    
    Attendants *attendants = [self attendants];
    Attendant *attendant = [BNoteEntryUtils findMatch:attendants withFirstName:firstname andLastName:lastname];
    if (!attendant) {
        attendant = [BNoteFactory createAttendant:attendants];
        [attendant setFirstName:firstname];
        [attendant setLastName:lastname];
        [attendant setImage:image];
    }
    
    [self setSelectedAttendant:attendant];
    
    [peoplePicker setDisplayedProperties:[NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonEmailProperty]]];
    
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    ABMultiValueRef emails = ABRecordCopyValue(person, property);
    int idx = ABMultiValueGetIndexForIdentifier(emails, identifier);
    
    [[self selectedAttendant] setEmail:(__bridge NSString *)ABMultiValueCopyValueAtIndex(emails, idx)];
    
    [self finishedContactPicker];
    
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    if ([self selectedAttendant]) {
        [[BNoteWriter instance] removeAttendant:[self selectedAttendant]];
    }
    
    [self finishedContactPicker];
}
- (void)finishedContactPicker
{
    [self unfocus];

    [self setSelectedAttendant:nil];
    [self setPeoplePicker:nil];
    [[self parentController] dismissModalViewControllerAnimated:YES];
    
    [[self attendantsViewController] update];
}

- (void)presentAttendeeAdder
{
    if ([self popup]) {
        [self setPopup:nil];
    }

    Attendant *attendant = [BNoteFactory createAttendant:[self attendants]];
    [self setSelectedAttendant:attendant];
    AttendeeDetailViewController *controller = [[AttendeeDetailViewController alloc] initWithAttendant:attendant];
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
    
    [popup setDelegate:self];
    [popup presentPopoverFromRect:[[self imageView] frame]
                           inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    [popup setPopoverContentSize:CGSizeMake(367, 171)];
    [self setPopup:popup];
    
    [controller focus];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [[BNoteWriter instance] updateAttendee:[self selectedAttendant]];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if ([self popup]) {
        [[self popup] dismissPopoverAnimated:YES];
        [[BNoteWriter instance] updateAttendee:[self selectedAttendant]];
        [self setPopup:nil];
    }
}

@end
