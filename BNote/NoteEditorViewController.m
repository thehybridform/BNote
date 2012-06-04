//
//  NoteEditorViewController.m
//  BNote
//
//  Created by Young Kristin on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NoteEditorViewController.h"
#import "LayerFormater.h"
#import "Topic.h"
#import "KeyPoint.h"
#import "Attendant.h"
#import "ActionItem.h"
#import "Question.h"
#import "Decision.h"
#import "BNoteFactory.h"
#import "BNoteSessionData.h"
#import "BNoteWriter.h"
#import "BNoteStringUtils.h"
#import "KeyPointFilter.h"
#import "ActionItemFilter.h"
#import "QuestionFilter.h"
#import "DecisionFilter.h"
#import "IdentityFillter.h"
#import "BNoteEntryUtils.h"

@interface NoteEditorViewController ()
@property (strong, nonatomic) Note *note;
@property (strong, nonatomic) UIColor *toolbarEditColor;
@property (strong, nonatomic) DatePickerViewController *datePickerViewController;
@property (strong, nonatomic) ABPeoplePickerNavigationController *contactPicker; 
@property (strong, nonatomic) Attendant *selectedAttendant;

@end

@implementation NoteEditorViewController

@synthesize dateView = _dateView;
@synthesize subjectView = _subjectView;
@synthesize date = _date;
@synthesize time = _time;
@synthesize subject = _subject;
@synthesize note = _note;
@synthesize listener = _listener;
@synthesize toolbar = _toolbar;
@synthesize toolbarEditColor = _toolbarEditColor;
@synthesize subjectLable = _subjectLable;
@synthesize entityToolbar = _entityToolbar;
@synthesize keyPointButton = _keyPointButton;
@synthesize questionButton= _questionButton;
@synthesize decisionButton = _decisionButton;
@synthesize actionItemButton = _actionItemButton;
@synthesize modeButton = _modeButton;
@synthesize trashButton = _trashButton;
@synthesize entriesViewController = _entriesViewController;
@synthesize datePickerViewController = _datePickerViewController;
@synthesize attendantsImageView = _attendantsImageView;
@synthesize attendantsScrollView = _attendantsScrollView;
@synthesize contactPicker = _contactPicker;
@synthesize attendantsViewController = _attendantsViewController;
@synthesize selectedAttendant = _selectedAttendant;

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setNote:nil];
    [self setToolbarEditColor:nil];
    [self setDateView:nil];
    [self setSubjectView:nil];
    [self setDate:nil];
    [self setTime:nil];
    [self setSubject:nil];
    [self setSubjectLable:nil];
    [self setToolbar:nil];
    [self setEntityToolbar:nil];
    [self setKeyPointButton:nil];
    [self setQuestionButton:nil];
    [self setDecisionButton:nil];
    [self setActionItemButton:nil];
    [self setModeButton:nil];
    [self setTrashButton:nil];
    [self setEntriesViewController:nil];
    [self setListener:nil];
    [self setDatePickerViewController:nil];
    [self setAttendantsImageView:nil];
    [self setContactPicker:nil];
    [self setAttendantsViewController:nil];
    [self setSelectedAttendant:nil];
}


- (id)initWithNote:(Note *)note
{
    self = [super initWithNibName:@"NoteEditorViewController" bundle:nil];
    if (self) {
        [self setNote:note];
        [[BNoteSessionData instance] setPhase:Editing];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Note *note = [self note];
    if ([note subject] && [[note subject] length] > 0) {
        [[self subject] setText:[note subject]];
    } else {
        [[self subject] becomeFirstResponder];
    }

    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[note created]];
    [self setupDateTime:date];
    
    [[self view] setBackgroundColor:UIColorFromRGB([[note topic] color])];
                                    
    [LayerFormater roundCornersForView:[self dateView]];
    [LayerFormater roundCornersForView:[self subjectView]];
    [LayerFormater roundCornersForView:[[self entriesViewController] view]];
    [LayerFormater roundCornersForView:[self entityToolbar]];
    [LayerFormater roundCornersForView:[self attendantsScrollView]];
    
    [self setToolbarEditColor:[[self toolbar] tintColor]];
    [[self subjectLable] setHidden:YES];
    
    [[self modeButton] setTitle:@"Add"];
    
    [[self entriesViewController] setNote:note];
    
    UITapGestureRecognizer *normalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDatePicker:)];
    [[self dateView] addGestureRecognizer:normalTap];
    
    normalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showContactPicker:)];
    [[self attendantsImageView] addGestureRecognizer:normalTap];
    
    [[self attendantsViewController] setNote:note];
    [[self attendantsViewController] update];
}

- (IBAction)done:(id)sender
{
    [[self note] setSubject:[[self subject] text]];
    [self dismissModalViewControllerAnimated:YES];
    
    [[BNoteWriter instance] update];
    
    [[self listener] didFinish];
}

- (IBAction)editMode:(id)sender
{
    UISegmentedControl *control = (UISegmentedControl *)sender;
    
    if ([control selectedSegmentIndex] == 0) {
        [self editing];
    } else {
        [self setupTableViewAddingEntries];
        [self reviewing];
    }
}

- (void)editing
{
    [[self toolbar] setTintColor:[self toolbarEditColor]];
    [[self entityToolbar] setTintColor:[self toolbarEditColor]];
    [[self subject] setHidden:NO];
    [[self subjectLable] setHidden:YES];
    [[self trashButton] setEnabled:YES];
    [[self entriesViewController] setFilter:[[IdentityFillter alloc] init]];
    
    [[BNoteSessionData instance] setPhase:Editing];
}

- (void)reviewing
{
    [[self toolbar] setTintColor:[UIColor lightGrayColor]];
    [[self entityToolbar] setTintColor:[UIColor lightGrayColor]];
    [[self subject] setHidden:YES];
    [[self subjectLable] setHidden:NO];
    [[self subjectLable] setText:[[self subject] text]];
    [[self trashButton] setEnabled:NO];
    
    [[BNoteSessionData instance] setPhase:Reviewing];
}

- (IBAction)addAttendee:(id)sender
{
    if ([[BNoteSessionData instance] phase] == Editing) {
        [self addEntry:[BNoteFactory createAttendant:[self note]]];
    }
}

- (IBAction)addKeyPoint:(id)sender
{
    if ([[BNoteSessionData instance] phase] == Editing) {
        [self addEntry:[BNoteFactory createKeyPoint:[self note]]];
    } else {
        [[self entriesViewController] setFilter:[[KeyPointFilter alloc] init]];
    }
}

- (IBAction)addQuestion:(id)sender
{
    if ([[BNoteSessionData instance] phase] == Editing) {
        [self addEntry:[BNoteFactory createQuestion:[self note]]];
    } else {
        [[self entriesViewController] setFilter:[[QuestionFilter alloc] init]];
    }
}

- (IBAction)addDecision:(id)sender
{
    if ([[BNoteSessionData instance] phase] == Editing) {
        [self addEntry:[BNoteFactory createDecision:[self note]]];
    } else {
        [[self entriesViewController] setFilter:[[DecisionFilter alloc] init]];
    }
}

- (IBAction)addActionItem:(id)sender
{
    if ([[BNoteSessionData instance] phase] == Editing) {
        [self addEntry:[BNoteFactory createActionItem:[self note]]];
    } else {
        [[self entriesViewController] setFilter:[[ActionItemFilter alloc] init]];
    }
}

- (void)addEntry:(Entry *)entry
{
    [[self entriesViewController] reload];
    [[self entriesViewController] selectLastCell];
}

- (IBAction)editEntries:(id)sender
{
    if ([[self entriesViewController] isEditing]) {
        [self setupTableViewAddingEntries];
    } else {
        [self setupTableViewForDeletingRows];
    }
}

- (void)setupTableViewAddingEntries
{
    [[self entriesViewController] setEditing:NO animated:YES]; 
    [[self keyPointButton] setEnabled:YES];
    [[self questionButton] setEnabled:YES];
    [[self decisionButton] setEnabled:YES];
    [[self actionItemButton] setEnabled:YES];
    [[self modeButton] setEnabled:YES];
}

- (void)setupTableViewForDeletingRows
{
    [[self entriesViewController] setEditing:YES animated:YES]; 
    [[self keyPointButton] setEnabled:NO];
    [[self questionButton] setEnabled:NO];
    [[self decisionButton] setEnabled:NO];
    [[self actionItemButton] setEnabled:NO];
    [[self modeButton] setEnabled:NO];
}

- (void)showDatePicker:(id)sender
{
    if ([self datePickerViewController]) {
        [[self datePickerViewController] didFinish:nil];
        [self setDatePickerViewController:nil];
    } else {
        NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[[self note] created]];

        DatePickerViewController *controller = [[DatePickerViewController alloc] initWithDate:date];
        [[controller view] setBackgroundColor:[[self view] backgroundColor]];
        [controller setListener:self];
        [controller setModalPresentationStyle:UIModalPresentationCurrentContext];
        [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [[self entriesViewController] presentModalViewController:controller animated:YES];
        [self setDatePickerViewController:controller];
    }
}

- (void)didFinishDatePicker
{
    [self setDatePickerViewController:nil];
}

- (void)dateTimeUpdated:(NSDate *)date
{
    [[self note] setCreated:[date timeIntervalSinceReferenceDate]];
    [self setupDateTime:date];
}

- (void)setupDateTime:(NSDate *)date
{
    [[self date] setText:[BNoteStringUtils dateToString:date]];
    [[self time] setText:[BNoteStringUtils timeToString:date]];
}

- (void)showContactPicker:(id)sender
{
    if ([self contactPicker]) {
        [self finishedContactPicker];
    } else {
        [[self attendantsImageView] setImage:[[BNoteFactory createIcon:AttentiesIconActive] image]];
        ABPeoplePickerNavigationController *controller = [[ABPeoplePickerNavigationController alloc] init];
        [self setContactPicker:controller];
        
        [controller setPeoplePickerDelegate:self];
        [controller setModalPresentationStyle:UIModalPresentationCurrentContext];
        [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [[self entriesViewController] presentModalViewController:controller animated:YES];
    }
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    if ([self selectedAttendant]) {
        [[BNoteWriter instance] removeEntry:[self selectedAttendant]];
    }

    [self finishedContactPicker];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    if ([self selectedAttendant]) {
        [[BNoteWriter instance] removeEntry:[self selectedAttendant]];
    }
    
    NSString *firstname = (__bridge NSString *) ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastname = (__bridge NSString *) ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    Attendant *attendant = [BNoteEntryUtils findMatch:[self note] withFirstName:firstname andLastName:lastname];
    if (!attendant) {
        attendant = [BNoteFactory createAttendant:[self note]];
        [attendant setFirstName:firstname];
        [attendant setLastName:lastname];
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

- (void)finishedContactPicker
{
    [self setContactPicker:nil];
    [[self attendantsImageView] setImage:[[BNoteFactory createIcon:AttentiesIcon] image]];
    [[self entriesViewController] dismissModalViewControllerAnimated:YES];
    [self setSelectedAttendant:nil];
    [[self attendantsViewController] update];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


@end

