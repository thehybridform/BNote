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
#import "BNoteEntryUtils.h"
#import "EmailViewController.h"
#import "TopicSelectTableViewController.h"
#import "AssociatedTopicsTableViewController.h"

@interface NoteEditorViewController ()
@property (strong, nonatomic) Note *note;
@property (strong, nonatomic) UIColor *toolbarEditColor;
@property (strong, nonatomic) ABPeoplePickerNavigationController *contactPicker; 
@property (strong, nonatomic) Attendant *selectedAttendant;
@property (strong, nonatomic) UIPopoverController *popup;
@property (strong, nonatomic) IBOutlet UIView *dateView;
@property (strong, nonatomic) IBOutlet UIView *subjectView;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UITextView *subjectTextView;
@property (strong, nonatomic) IBOutlet UILabel *subjectLable;
@property (strong, nonatomic) IBOutlet UIToolbar *entityToolbar;
@property (strong, nonatomic) IBOutlet UIToolbar *entityWithAttendantToolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *keyPointButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *questionButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *decisionButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *actionItemButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *reviewButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *trashButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *emailButton;
@property (strong, nonatomic) IBOutlet UIImageView *attendantsImageView;

@property (strong, nonatomic) IBOutlet UIView *mainTopicView;
@property (strong, nonatomic) IBOutlet UILabel *mainTopicLabel;

@property (strong, nonatomic) UIActionSheet *actionSheet;

@property (strong, nonatomic) IBOutlet EntriesViewController *entriesViewController;
@property (strong, nonatomic) IBOutlet AssociatedTopicsTableViewController *associatedTopicsTableViewController;

@end

@implementation NoteEditorViewController

@synthesize dateView = _dateView;
@synthesize subjectView = _subjectView;
@synthesize date = _date;
@synthesize time = _time;
@synthesize subjectTextView = _subjectTextView;
@synthesize note = _note;
@synthesize toolbarEditColor = _toolbarEditColor;
@synthesize subjectLable = _subjectLable;
@synthesize entityToolbar = _entityToolbar;
@synthesize keyPointButton = _keyPointButton;
@synthesize questionButton= _questionButton;
@synthesize decisionButton = _decisionButton;
@synthesize actionItemButton = _actionItemButton;
@synthesize reviewButton = _reviewButton;
@synthesize trashButton = _trashButton;
@synthesize entriesViewController = _entriesViewController;
@synthesize attendantsImageView = _attendantsImageView;
@synthesize contactPicker = _contactPicker;
@synthesize selectedAttendant = _selectedAttendant;
@synthesize popup = _popup;
@synthesize entityWithAttendantToolbar = _entityWithAttendantToolbar;
@synthesize emailButton = _emailButton;
@synthesize mainTopicView = _mainTopicView;
@synthesize mainTopicLabel = _mainTopicLabel;
@synthesize actionSheet = _actionSheet;
@synthesize associatedTopicsTableViewController = _associatedTopicsTableViewController;

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setNote:nil];
    [self setToolbarEditColor:nil];
    [self setDateView:nil];
    [self setSubjectView:nil];
    [self setDate:nil];
    [self setTime:nil];
    [self setSubjectTextView:nil];
    [self setSubjectLable:nil];
    [self setEntityToolbar:nil];
    [self setKeyPointButton:nil];
    [self setQuestionButton:nil];
    [self setDecisionButton:nil];
    [self setActionItemButton:nil];
    [self setReviewButton:nil];
    [self setTrashButton:nil];
    [self setEntriesViewController:nil];
    [self setAttendantsImageView:nil];
    [self setContactPicker:nil];
    [self setSelectedAttendant:nil];
    [self setPopup:nil];
    [self setEntityWithAttendantToolbar:nil];
    [self setEmailButton:nil];
    [self setMainTopicView:nil];
    [self setMainTopicLabel:nil];
    [self setActionSheet:nil];
    [self setAssociatedTopicsTableViewController:nil];
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
        [[self subjectTextView] setText:[note subject]];
    }

    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[note created]];
    [self setupDateTime:date];
    
    [[self view] setBackgroundColor:UIColorFromRGB([note color])];
                                    
    [LayerFormater roundCornersForView:[self dateView]];
    [LayerFormater roundCornersForView:[self subjectView]];
    [LayerFormater roundCornersForView:[self mainTopicView]];
    [LayerFormater roundCornersForView:[self mainTopicLabel]];
    [LayerFormater roundCornersForView:[self subjectTextView]];
    
    [[self subjectLable] setHidden:YES];
    
    [[self reviewButton] setTitle:@"Review"];
    
    [[self entriesViewController] setNote:note];
    [[self entriesViewController] setParentController:self];
    
    UITapGestureRecognizer *normalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDatePicker:)];
    [[self dateView] addGestureRecognizer:normalTap];
    
    if ([BNoteEntryUtils containsAttendants:note]) {
        [[self entityWithAttendantToolbar] setHidden:YES];
        [[self attendantsImageView] setHidden:YES];
    } else {
        [[self entityToolbar] setHidden:YES];
    }
    
    [[self mainTopicLabel] setText:[[note topic] title]];
    normalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMainTopicPicker:)];
    [[self mainTopicView] addGestureRecognizer:normalTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:)
                                                 name:TopicUpdated object:nil];
    
    [[self associatedTopicsTableViewController] setNote:note];
}

- (IBAction)done:(id)sender
{
    [[self note] setSubject:[[self subjectTextView] text]];
    [self dismissModalViewControllerAnimated:YES];
    [[self entriesViewController] cleanupEntries];    
    [[BNoteWriter instance] update];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NoteUpdated object:[self note]];
}

- (IBAction)editMode:(id)sender
{
    if ([[BNoteSessionData instance] phase] == Reviewing) {
        [self editing];
        [[self reviewButton] setTitle:@"Review"];
    } else {
        [self setupTableViewAddingEntries];
        [self reviewing];
        [[self reviewButton] setTitle:@"Edit"];
    }
}

- (void)editing
{
    [[self entityToolbar] setTintColor:[self toolbarEditColor]];
    [[self subjectTextView] setHidden:NO];
    [[self subjectLable] setHidden:YES];
    [[self trashButton] setEnabled:YES];
    [[self entriesViewController] setFilter:[BNoteFilterFactory create:ItdentityType]];
    
    [[BNoteSessionData instance] setPhase:Editing];
}

- (void)reviewing
{
    [[self entityToolbar] setTintColor:[UIColor lightGrayColor]];
    [[self subjectTextView] setHidden:YES];
    [[self subjectLable] setHidden:NO];
    [[self subjectLable] setText:[[self subjectTextView] text]];
    [[self trashButton] setEnabled:NO];
    
    [[BNoteSessionData instance] setPhase:Reviewing];
}

- (IBAction)addAttendies:(id)sender
{
    if ([[BNoteSessionData instance] phase] == Editing) {
        [self addEntry:[BNoteFactory createAttendants:[self note]]];
    } else {
        [[self entriesViewController] setFilter:[BNoteFilterFactory create:AttendantType]];
    }
}

- (IBAction)addKeyPoint:(id)sender
{
    if ([[BNoteSessionData instance] phase] == Editing) {
        [self addEntry:[BNoteFactory createKeyPoint:[self note]]];
    } else {
        [[self entriesViewController] setFilter:[BNoteFilterFactory create:KeyPointType]];
    }
}

- (IBAction)addQuestion:(id)sender
{
    if ([[BNoteSessionData instance] phase] == Editing) {
        [self addEntry:[BNoteFactory createQuestion:[self note]]];
    } else {
        [[self entriesViewController] setFilter:[BNoteFilterFactory create:QuestionType]];
    }
}

- (IBAction)addDecision:(id)sender
{
    if ([[BNoteSessionData instance] phase] == Editing) {
        [self addEntry:[BNoteFactory createDecision:[self note]]];
    } else {
        [[self entriesViewController] setFilter:[BNoteFilterFactory create:DecistionType]];
    }
}

- (IBAction)addActionItem:(id)sender
{
    if ([[BNoteSessionData instance] phase] == Editing) {
        [self addEntry:[BNoteFactory createActionItem:[self note]]];
    } else {
        [[self entriesViewController] setFilter:[BNoteFilterFactory create:ActionItemType]];
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
    [[self reviewButton] setEnabled:YES];
    [[self emailButton] setEnabled:YES];
}

- (void)setupTableViewForDeletingRows
{
    [[self entriesViewController] setEditing:YES animated:YES]; 
    [[self keyPointButton] setEnabled:NO];
    [[self questionButton] setEnabled:NO];
    [[self decisionButton] setEnabled:NO];
    [[self actionItemButton] setEnabled:NO];
    [[self reviewButton] setEnabled:NO];
    [[self emailButton] setEnabled:NO];
}

- (void)showDatePicker:(id)sender
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[[self note] created]];
    
    DatePickerViewController *controller = [[DatePickerViewController alloc] initWithDate:date];
    [controller setListener:self];
    [controller setTitleText:@"Created Date"];

    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
    [self setPopup:popup];
    [popup setDelegate:self];
    
    [popup setPopoverContentSize:[[controller view] bounds].size];
    
    UIView *view = [self dateView];
    CGRect rect = [view bounds];

    [popup presentPopoverFromRect:rect inView:view
                     permittedArrowDirections:UIPopoverArrowDirectionAny 
                                     animated:YES];
}

- (void)dateTimeUpdated:(NSDate *)date
{
    [[self note] setCreated:[date timeIntervalSinceReferenceDate]];
    [self setupDateTime:date];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self setPopup:nil];
}

- (void)selectedDatePickerViewDone
{
    [[self popup] dismissPopoverAnimated:YES];
    [self setPopup:nil];
}

- (void)setupDateTime:(NSDate *)date
{
    [[self date] setText:[BNoteStringUtils dateToString:date]];
    [[self time] setText:[BNoteStringUtils timeToString:date]];
}

- (IBAction)emailNote:(id)sender
{
    Note *note = [self note];
    EmailViewController *controller = [[EmailViewController alloc] initWithNote:note];
    [controller setModalPresentationStyle:UIModalPresentationPageSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self presentModalViewController:controller animated:YES];
}

- (void)selectEntry:(Entry *)entry
{
    [[self entriesViewController] selectEntry:entry];

}

- (void)showMainTopicPicker:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Main Topic" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Change", nil];
    [self setActionSheet:actionSheet];
    
    CGRect rect = [[self mainTopicView] frame];
    [actionSheet showFromRect:rect inView:[self view] animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self showTopicSelector];
            break;
            
        default:
            break;
    }
    [self setActionSheet:nil];
}

- (void)showTopicSelector
{
    TopicSelectTableViewController *topicTable = 
        [[TopicSelectTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [topicTable setNote:[self note]];
    
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:topicTable];
    [self setPopup:popup];
     
    [popup setPopoverContentSize:CGSizeMake(225, 400)];

    CGRect rect = [[self mainTopicView] frame];
    [popup presentPopoverFromRect:rect inView:[self view] 
                     permittedArrowDirections:UIPopoverArrowDirectionAny 
                                     animated:YES];
}

- (void)reload:(id)sender
{
    if ([self popup]) {
        [[self popup] dismissPopoverAnimated:YES];
    }
    
    [[self mainTopicLabel] setText:[[[self note] topic] title]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end

