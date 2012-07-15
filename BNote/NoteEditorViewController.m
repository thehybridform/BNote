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
#import "AssociatedTopicsTableViewController.h"
#import "BNoteButton.h"

@interface NoteEditorViewController ()
@property (strong, nonatomic) Note *note;
@property (strong, nonatomic) UIColor *toolbarEditColor;
@property (strong, nonatomic) Attendant *selectedAttendant;
@property (strong, nonatomic) UIPopoverController *popup;
@property (strong, nonatomic) IBOutlet UIView *dateView;
@property (strong, nonatomic) IBOutlet UILabel *year;
@property (strong, nonatomic) IBOutlet UILabel *day;
@property (strong, nonatomic) IBOutlet UILabel *month;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UITextView *subjectTextView;
@property (strong, nonatomic) IBOutlet BNoteButton *attendantsButton;
@property (strong, nonatomic) IBOutlet BNoteButton *keyPointButton;
@property (strong, nonatomic) IBOutlet BNoteButton *questionButton;
@property (strong, nonatomic) IBOutlet BNoteButton *decisionButton;
@property (strong, nonatomic) IBOutlet BNoteButton *actionItemButton;
@property (strong, nonatomic) IBOutlet BNoteButton *reviewButton;
@property (strong, nonatomic) IBOutlet BNoteButton *trashButton;
@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet UIView *filterView;
@property (strong, nonatomic) IBOutlet UIButton *filterButton;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;

@property (strong, nonatomic) IBOutlet EntriesViewController *entriesViewController;
@property (strong, nonatomic) IBOutlet AssociatedTopicsTableViewController *associatedTopicsTableViewController;

@end

@implementation NoteEditorViewController

@synthesize dateView = _dateView;
@synthesize day = _day;
@synthesize year = _year;
@synthesize time = _time;
@synthesize subjectTextView = _subjectTextView;
@synthesize note = _note;
@synthesize toolbarEditColor = _toolbarEditColor;
@synthesize keyPointButton = _keyPointButton;
@synthesize questionButton= _questionButton;
@synthesize decisionButton = _decisionButton;
@synthesize actionItemButton = _actionItemButton;
@synthesize reviewButton = _reviewButton;
@synthesize trashButton = _trashButton;
@synthesize entriesViewController = _entriesViewController;
@synthesize attendantsButton = _attendantsButton;
@synthesize selectedAttendant = _selectedAttendant;
@synthesize popup = _popup;
@synthesize associatedTopicsTableViewController = _associatedTopicsTableViewController;
@synthesize menuView = _menuView;
@synthesize infoView = _infoView;
@synthesize month = _month;
@synthesize shareButton = _shareButton;
@synthesize filterView = _filterView;
@synthesize filterButton = _filterButton;

static NSString *email = @"E-mail";

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setNote:nil];
    [self setToolbarEditColor:nil];
    [self setDateView:nil];
    [self setTime:nil];
    [self setYear:nil];
    [self setDay:nil];
    [self setSubjectTextView:nil];
    [self setKeyPointButton:nil];
    [self setQuestionButton:nil];
    [self setDecisionButton:nil];
    [self setActionItemButton:nil];
    [self setReviewButton:nil];
    [self setTrashButton:nil];
    [self setEntriesViewController:nil];
    [self setAttendantsButton:nil];
    [self setSelectedAttendant:nil];
    [self setPopup:nil];
    [self setAssociatedTopicsTableViewController:nil];
    [self setMenuView:nil];
    [self setInfoView:nil];
    [self setMonth:nil];
    [self setShareButton:nil];
    [self setFilterView:nil];
    [self setFilterButton:nil];
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
   
    [[self infoView] setBackgroundColor:UIColorFromRGB([note color])];
                                    
    [LayerFormater roundCornersForView:[self dateView]];
    [LayerFormater roundCornersForView:[self subjectTextView]];
    [LayerFormater setBorderColor:[BNoteConstants colorFor:BNoteColorHighlight] forView:[self menuView]];
    [LayerFormater setBorderWidth:1 forView:[self menuView]];
    
    [[self entriesViewController] setNote:note];
    [[self entriesViewController] setParentController:self];
    
    UITapGestureRecognizer *normalTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDatePicker:)];
    [[self dateView] addGestureRecognizer:normalTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:)
                                                 name:TopicUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateToolBar:)
                                                 name:AttendantsEntryDeleted object:nil];
    
    [[self associatedTopicsTableViewController] setNote:note];
    
    [[self entriesViewController] setParentController:self];
    
    [[self keyPointButton] setIcon:[BNoteFactory createIcon:KeyPointIcon]];
    [[self actionItemButton] setIcon:[BNoteFactory createIcon:ActionItemIcon]];
    [[self decisionButton] setIcon:[BNoteFactory createIcon:DecisionIcon]];
    [[self questionButton] setIcon:[BNoteFactory createIcon:QuestionIcon]];
    [[self attendantsButton] setIcon:[BNoteFactory createIcon:AttentiesIcon]];
    
    [LayerFormater addShadowToView:[self menuView]];
    [LayerFormater addShadowToView:[self infoView]];
    
    [[self filterView] setHidden:YES];
    [LayerFormater roundCornersForView:[self filterView]];
    [LayerFormater setBorderWidth:2 forView:[self filterView]];
    [LayerFormater setBorderColor:[BNoteConstants appHighlightColor1] forView:[self filterView]];
    [[self filterView] setBackgroundColor:[UIColor clearColor]];

    [self setupDate];
    
    [[self attendantsButton] setHidden:[BNoteEntryUtils noteContainsAttendants:note]];
}

- (void)setupDate
{
    NSString *title = [[self note] subject];
    if ([BNoteStringUtils nilOrEmpty:title]) {
        [[self subjectTextView] setText:nil];
    } else {
        [[self subjectTextView] setText:title];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[[self note] created]];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterBehaviorDefault];
    
    [format setDateFormat:@"MM"];
    NSString *str = [format stringFromDate:date];
    NSNumber *num = [numberFormatter numberFromString:str];
    str = [BNoteStringUtils monthFor:[num intValue]];
    [[self month] setText:str];
    
    [format setDateFormat:@"dd"];
    str = [format stringFromDate:date];
    
    num = [numberFormatter numberFromString:str];
    str = [BNoteStringUtils ordinalNumberFormat:[num intValue]];
    [[self day] setText:str];
    
    [format setDateFormat:@"h:mm aaa"];
    str = [format stringFromDate:date];
    [[self time] setText:str];
    
    [format setDateFormat:@"yyyy"];
    str = [format stringFromDate:date];
    [[self year] setText:str];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];            
}

- (IBAction)done:(id)sender
{
    [[self note] setSubject:[[self subjectTextView] text]];
    [self dismissModalViewControllerAnimated:YES];

    [BNoteEntryUtils cleanUpEntriesForNote:[self note]];
    
    [[BNoteWriter instance] update];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TopicUpdated object:[[self note] topic]];
}

- (IBAction)resetFilter:(id)sender
{
    [[self entriesViewController] setFilter:[[BNoteFilterFactory instance] create:ItdentityType]];
}

- (IBAction)editMode:(id)sender
{
    if ([[BNoteSessionData instance] phase] == Reviewing) {
        [self editing];
    } else {
        [self setupTableViewAddingEntries];
        [self reviewing];
    }
}

- (void)editing
{
    [[self filterView] setHidden:YES];
    [[self trashButton] setHidden:NO];
    [[self reviewButton] setTitle:@"Review" forState:UIControlStateNormal];
    [[self entriesViewController] setFilter:[[BNoteFilterFactory instance] create:ItdentityType]];

    [[BNoteSessionData instance] setPhase:Editing];
}

- (void)reviewing
{
    [[self filterView] setHidden:NO];
    [[self trashButton] setHidden:YES];
    [[self reviewButton] setTitle:@"Done" forState:UIControlStateNormal];

    [[BNoteSessionData instance] setPhase:Reviewing];
}

- (IBAction)addAttendies:(id)sender
{
    if ([[BNoteSessionData instance] phase] == Editing) {
        [[self attendantsButton] setHidden:YES];
        [self addEntry:[BNoteFactory createAttendants:[self note]]];
    } else {
        [[self entriesViewController] setFilter:[[BNoteFilterFactory instance] create:AttendantType]];
    }
}

- (IBAction)addKeyPoint:(id)sender
{
    if ([[BNoteSessionData instance] phase] == Editing) {
        [self addEntry:[BNoteFactory createKeyPoint:[self note]]];
    } else {
        [[self entriesViewController] setFilter:[[BNoteFilterFactory instance] create:KeyPointType]];
    }
}

- (IBAction)addQuestion:(id)sender
{
    if ([[BNoteSessionData instance] phase] == Editing) {
        [self addEntry:[BNoteFactory createQuestion:[self note]]];
    } else {
        [[self entriesViewController] setFilter:[[BNoteFilterFactory instance] create:QuestionType]];
    }
}

- (IBAction)addDecision:(id)sender
{
    if ([[BNoteSessionData instance] phase] == Editing) {
        [self addEntry:[BNoteFactory createDecision:[self note]]];
    } else {
        [[self entriesViewController] setFilter:[[BNoteFilterFactory instance] create:DecistionType]];
    }
}

- (IBAction)addActionItem:(id)sender
{
    if ([[BNoteSessionData instance] phase] == Editing) {
        [self addEntry:[BNoteFactory createActionItem:[self note]]];
    } else {
        [[self entriesViewController] setFilter:[[BNoteFilterFactory instance] create:ActionItemType]];
    }
}

- (void)addEntry:(Entry *)entry
{
    [[self entriesViewController] reload];
    if ([entry isKindOfClass:[Attendants class]]) {
        [[self entriesViewController] selectFirstCell];
    } else {
        [[self entriesViewController] selectLastCell];
    }
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
    [[self attendantsButton] setEnabled:YES];
    [[self actionItemButton] setEnabled:YES];
    [[self reviewButton] setEnabled:YES];
    [[self shareButton] setEnabled:YES];
    [[self trashButton] setTitle:@"Organize" forState:UIControlStateNormal];
}

- (void)setupTableViewForDeletingRows
{
    [[self entriesViewController] setEditing:YES animated:YES]; 
    [[self keyPointButton] setEnabled:NO];
    [[self questionButton] setEnabled:NO];
    [[self decisionButton] setEnabled:NO];
    [[self actionItemButton] setEnabled:NO];
    [[self attendantsButton] setEnabled:NO];
    [[self reviewButton] setEnabled:NO];
    [[self shareButton] setEnabled:NO];
    [[self trashButton] setTitle:@"Done" forState:UIControlStateNormal];
}

- (void)showDatePicker:(id)sender
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[[self note] created]];
    
    DatePickerViewController *controller = [[DatePickerViewController alloc] initWithDate:date];
    [controller setListener:self];
    [controller setTitleText:@"Created Date"];

    if ([self popup]) {
        [[self popup] dismissPopoverAnimated:YES];
    }

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
    [self setupDate];
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

- (void)emailNote
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

- (void)reload:(id)sender
{
    [[self view] setBackgroundColor:UIColorFromRGB([[self note] color])];
}

- (IBAction)presentShareOptions:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    [[BNoteSessionData instance] setActionSheet:actionSheet];
    [[BNoteSessionData instance] setActionSheetDelegate:self];
    [actionSheet setDelegate:[BNoteSessionData instance]];
    
    [actionSheet addButtonWithTitle:email];
    
    [actionSheet setTitle:@"Share Note"];
    
    UIView *view = [self shareButton];
    CGRect rect = [view bounds];
    [actionSheet showFromRect:rect inView:view animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0) {
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if (title == email) {
            [self emailNote];
        }
    }
}

- (void)updateToolBar:(NSNotification *)notification
{
    [[self attendantsButton] setHidden:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [[self entriesViewController] reload];
}


@end

