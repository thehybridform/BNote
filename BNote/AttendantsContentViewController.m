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
#import "LayerFormater.h"
#import "BNoteSessionData.h"

@interface AttendantsContentViewController()
@property (strong, nonatomic) IBOutlet AttendantsViewController *attendantsViewController;
@property (strong, nonatomic) ABPeoplePickerNavigationController *peoplePicker; 
@property (assign, nonatomic) Attendant *selectedAttendant;
@property (strong, nonatomic) IBOutlet UIButton *addAttendantButton;
@property (strong, nonatomic) IBOutlet UIButton *createAttendantButton;

@end

@implementation AttendantsContentViewController
@synthesize attendantsViewController = _attendantsViewController;
@synthesize peoplePicker = _peoplePicker;
@synthesize selectedAttendant = _selectedAttendant;
@synthesize addAttendantButton = _addAttendantButton;
@synthesize createAttendantButton = _createAttendantButton;

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
    
    AttendantsViewController *controller = [self attendantsViewController];
    [controller setAttendants:[self attendants]];
    
    [[self addAttendantButton] setBackgroundColor:[BNoteConstants appHighlightColor1]];
    [[[self addAttendantButton] titleLabel] setFont:[BNoteConstants font:RobotoRegular andSize:12]];
    [LayerFormater roundCornersForView:[self addAttendantButton]];
    [LayerFormater setBorderWidth:0 forView:[self addAttendantButton]];
    
    [[self createAttendantButton] setBackgroundColor:[BNoteConstants appHighlightColor1]];
    [[[self createAttendantButton] titleLabel] setFont:[BNoteConstants font:RobotoRegular andSize:12]];
    [LayerFormater roundCornersForView:[self createAttendantButton]];
    [LayerFormater setBorderWidth:0 forView:[self createAttendantButton]];
    
    [controller update];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideAttendantsContentViewController:)
                                                 name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setAttendantsViewController:nil];
    [self setPeoplePicker:nil];
    [self setAddAttendantButton:nil];
    [self setCreateAttendantButton:nil];
}

- (float)height
{
    return 100;
}

- (IBAction)presentAttendeePicker:(id)sender
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
    if ([self selectedAttendant]) {
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

- (IBAction)presentAttendeeAdder:(id)sender
{
    Attendant *attendant = [BNoteFactory createAttendant:[self attendants]];
    [self setSelectedAttendant:attendant];
    AttendeeDetailViewController *controller = [[AttendeeDetailViewController alloc] initWithAttendant:attendant];
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
    [controller setPopup:popup];
    [[BNoteSessionData instance] setPopup:popup];

    [popup setDelegate:self];
    
    UIView *view = [self createAttendantButton];
    [popup presentPopoverFromRect:[view frame]
                           inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    [popup setPopoverContentSize:CGSizeMake(367, 224)];
    
    [controller focus];
}

- (void)keyboardDidHideAttendantsContentViewController:(NSNotification *)notification
{
    [[[BNoteSessionData instance] popup] dismissPopoverAnimated:YES];
    [[BNoteSessionData instance] setPopup:nil];

    [[BNoteWriter instance] updateAttendee:[self selectedAttendant]];

    [[NSNotificationCenter defaultCenter] postNotificationName:AttendeeUpdated object:nil];    
}

@end
