//
//  AttendantsContentViewController.m
//  BeNote
//
//  Created by Young Kristin on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AttendantsContentViewController.h"
#import "AttendantsViewController.h"
#import "AttendeeDetailViewController.h"
#import "BNoteFactory.h"
#import "BNoteWriter.h"
#import "BNoteSessionData.h"

@interface AttendantsContentViewController()
@property (strong, nonatomic) IBOutlet AttendantsViewController *attendantsViewController;
@property (strong, nonatomic) ABPeoplePickerNavigationController *peoplePicker; 
@property (strong, nonatomic) Attendant *selectedAttendant;
@property (strong, nonatomic) IBOutlet UIView *addAttendantView;

@end

@implementation AttendantsContentViewController
@synthesize attendantsViewController = _attendantsViewController;
@synthesize peoplePicker = _peoplePicker;
@synthesize selectedAttendant = _selectedAttendant;
@synthesize addAttendantView = _addAttendantView;

static NSString *addressBook;
static NSString *createNew;
static NSString *attendants;

- (NSString *)localNibName
{
    return @"AttendantsContentView";
}

- (Attendants *)attendants
{
    return (Attendants *) [self entry];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    addressBook = NSLocalizedString(@"Address Book", @"ipad addres book");
    createNew = NSLocalizedString(@"Create New", @"Create new attendants");
    attendants = NSLocalizedString(@"Attendants", @"Attendants menu title");
    
    [[self addAttendantView] setBackgroundColor:[BNoteConstants appColor1]];
    
    AttendantsViewController *controller = [self attendantsViewController];
    [controller setAttendants:[self attendants]];
    
    [controller update];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOptions:)];
    [[self addAttendantView] addGestureRecognizer:tap];

    [[NSNotificationCenter defaultCenter]
     addObserver:self
        selector:@selector(keyboardDidHideAttendantsContentViewController:)
            name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setAttendantsViewController:nil];
    [self setAddAttendantView:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (float)height
{
    return 100;
}

- (void)presentAttendeePicker
{
    ABPeoplePickerNavigationController *controller = [[ABPeoplePickerNavigationController alloc] init];
    [self setPeoplePicker:controller];
        
    [controller setPeoplePickerDelegate:self];
    [controller setModalPresentationStyle:UIModalPresentationPageSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentModalViewController:controller animated:YES];
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
    if ([self selectedAttendant] != nil) {
        [[BNoteWriter instance] removeAttendant:[self selectedAttendant]];
    }
    
    [self finishedContactPicker];
}
- (void)finishedContactPicker
{
    [self setSelectedAttendant:nil];
    [self setPeoplePicker:nil];
    [self dismissModalViewControllerAnimated:YES];
    
    [[self attendantsViewController] update];
    [self handleImageIcon:NO];
}

- (void)presentAttendeeAdder
{
    Attendant *attendant = [BNoteFactory createAttendant:[self attendants]];
    [self setSelectedAttendant:attendant];
    AttendeeDetailViewController *controller = [[AttendeeDetailViewController alloc] initWithAttendant:attendant];
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
    [controller setPopup:popup];
    [[BNoteSessionData instance] setPopup:popup];

    [popup setDelegate:self];
    
    UIView *view = [self addAttendantView];
    [popup presentPopoverFromRect:[view frame]
                           inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
    
    [popup setPopoverContentSize:CGSizeMake(367, 224)];
    
    [controller focus];
}

- (void)keyboardDidHideAttendantsContentViewController:(NSNotification *)notification
{
    [[[BNoteSessionData instance] popup] dismissPopoverAnimated:YES];
    [[BNoteSessionData instance] setPopup:nil];

    [[BNoteWriter instance] updateAttendee:[self selectedAttendant]];

    [[NSNotificationCenter defaultCenter] postNotificationName:kAttendeeUpdated object:nil];    
}

- (void)showOptions:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    [[BNoteSessionData instance] setActionSheet:actionSheet];
    [actionSheet setDelegate:[BNoteSessionData instance]];
    [[BNoteSessionData instance] setActionSheetDelegate:self];
    
    [actionSheet setTitle:attendants];
    [actionSheet addButtonWithTitle:addressBook];
    [actionSheet addButtonWithTitle:createNew];
    
    CGRect rect = [[self addAttendantView] frame];
    [actionSheet showFromRect:rect inView:[self view] animated:NO];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0) {
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if (title == addressBook) {
            [self presentAttendeePicker];
        } else if (title == createNew) {
            [self presentAttendeeAdder];
        }
    }

    [[BNoteSessionData instance] setActionSheet:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
