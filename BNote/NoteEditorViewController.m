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
#import "EditNoteView.h"
#import "InformationViewController.h"

@interface NoteEditorViewController ()
@property (strong, nonatomic) Note *note;
@property (strong, nonatomic) UIColor *toolbarEditColor;
@property (strong, nonatomic) Attendant *selectedAttendant;
@property (strong, nonatomic) UIPopoverController *popup;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIView *dateView;
@property (strong, nonatomic) IBOutlet UILabel *year;
@property (strong, nonatomic) IBOutlet UILabel *day;
@property (strong, nonatomic) IBOutlet UILabel *month;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *entryLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextView *subjectTextView;
@property (strong, nonatomic) IBOutlet BNoteButton *attendantsButton;
@property (strong, nonatomic) IBOutlet BNoteButton *keyPointButton;
@property (strong, nonatomic) IBOutlet BNoteButton *questionButton;
@property (strong, nonatomic) IBOutlet BNoteButton *decisionButton;
@property (strong, nonatomic) IBOutlet BNoteButton *actionItemButton;
@property (strong, nonatomic) IBOutlet BNoteButton *reviewButton;
@property (strong, nonatomic) IBOutlet BNoteButton *trashButton;
@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet EditNoteView *infoView;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;

@property (strong, nonatomic) IBOutlet EntriesViewController *entriesViewController;
@property (strong, nonatomic) IBOutlet AssociatedTopicsTableViewController *associatedTopicsTableViewController;

@property (assign, nonatomic) BOOL isEditing;

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
@synthesize footerView = _footerView;
@synthesize entryLabel = _entryLabel;
@synthesize isEditing = _isEditing;
@synthesize titleLabel = _titleLabel;

static NSString *REVIEW = @"REVIEW";
static NSString *DONE = @"DONE";

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
    [self setEntryLabel:nil];
    [self setTitleLabel:nil];
}


- (id)initWithNote:(Note *)note
{
    self = [super initWithNibName:@"NoteEditorViewController" bundle:nil];
    if (self) {
        [self setNote:note];
        [self setIsEditing:YES];
        UITapGestureRecognizer *normalTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDatePicker:)];
        [[self dateView] addGestureRecognizer:normalTap];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:)
                                                     name:TopicUpdated object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateToolBar:)
                                                     name:AttendantsEntryDeleted object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Note *note = [self note];
    BOOL empty = [BNoteStringUtils nilOrEmpty:[note subject]];
    if (empty) {
        [[self subjectTextView] setText:@"Enter Subject"];
    } else {
        [[self subjectTextView] setText:[note subject]];
    }
                                       
    [LayerFormater roundCornersForView:[self dateView]];
    [LayerFormater setBorderColor:[BNoteConstants colorFor:BNoteColorHighlight] forView:[self menuView]];
    [LayerFormater setBorderWidth:1 forView:[self menuView]];
    
    [LayerFormater setBorderColor:[UIColor lightGrayColor] forView:[self menuView]];
    [LayerFormater setBorderColor:[UIColor lightGrayColor] forView:[self footerView]];
    [LayerFormater setBorderColor:[UIColor lightGrayColor] forView:[self infoView]];
    
    [[self entriesViewController] setNote:note];
    [[self entriesViewController] setParentController:self];
    
    [[self associatedTopicsTableViewController] setNote:note];
    
    [[self entriesViewController] setParentController:self];
    
    [self normalIcons];
    
    [LayerFormater setBorderWidth:1 forView:[self footerView]];
    [LayerFormater setBorderWidth:1 forView:[self menuView]];
    [LayerFormater setBorderWidth:1 forView:[self infoView]];
    
    [[self titleLabel] setFont:[BNoteConstants font:RobotoBold andSize:18]];
    [[self titleLabel] setTextColor:[BNoteConstants appHighlightColor1]];
    [[self titleLabel] setText:[[note topic] title]];
    
    [[[self keyPointButton] titleLabel] setFont:[BNoteConstants font:RobotoRegular andSize:12]];
    [[[self actionItemButton] titleLabel] setFont:[BNoteConstants font:RobotoRegular andSize:12]];
    [[[self attendantsButton] titleLabel] setFont:[BNoteConstants font:RobotoRegular andSize:12]];
    [[[self decisionButton] titleLabel] setFont:[BNoteConstants font:RobotoRegular andSize:12]];
    [[[self questionButton] titleLabel] setFont:[BNoteConstants font:RobotoRegular andSize:12]];
    [[self entryLabel] setFont:[BNoteConstants font:RobotoBold andSize:14]];
    [[self entryLabel] setTextColor:[BNoteConstants appHighlightColor1]];
    
    [[self year] setFont:[BNoteConstants font:RobotoRegular andSize:17]];
    [[self month] setFont:[BNoteConstants font:RobotoBold andSize:11]];
    [[self day] setFont:[BNoteConstants font:RobotoRegular andSize:34]];
    [[self time] setFont:[BNoteConstants font:RobotoRegular andSize:15]];
    [[self subjectTextView] setFont:[BNoteConstants font:RobotoRegular andSize:20]];
    [[self subjectTextView] setTextColor:UIColorFromRGB(0x444444)];

    [self setupDate];
    
    [[self attendantsButton] setHidden:[BNoteEntryUtils noteContainsAttendants:note]];

    [LayerFormater roundCornersForView:[self infoView]];
    [LayerFormater setBorderWidth:2 forView:[self infoView]];
    [LayerFormater setBorderColor:[BNoteConstants appHighlightColor1] forView:[self infoView]];
    [[self infoView] setNote:note];
    [[self infoView] setNeedsDisplay];
}

- (void)setupDate
{
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

- (IBAction)editMode:(id)sender
{
    if ([self isEditing]) {
        [self setupTableViewAddingEntries];
        [self reviewing];
    } else {
        [self editing];
    }
}

- (void)editing
{
    [[NSNotificationCenter defaultCenter] postNotificationName:EditingNote object:nil];

    [[self trashButton] setHidden:NO];
    [self normalIcons];
    [[self reviewButton] setTitle:REVIEW forState:UIControlStateNormal];
    [[self entriesViewController] setFilter:[[BNoteFilterFactory instance] create:ItdentityType]];
    [[self attendantsButton] setHidden:[BNoteEntryUtils noteContainsAttendants:[self note]]];
    [self setIsEditing:YES];
}

- (void)reviewing
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ReviewingNote object:nil];

    [[self trashButton] setHidden:YES];
    [self funnelIcons];
    [[self reviewButton] setTitle:DONE forState:UIControlStateNormal];
    [[self attendantsButton] setHidden:YES];
    [self setIsEditing:NO];
}

- (IBAction)addAttendies:(id)sender
{
    if ([self isEditing]) {
        [[self attendantsButton] setHidden:YES];
        [self addEntry:[BNoteFactory createAttendants:[self note]]];
    } else {
        [self setFilter:AttendantType];
    }
}

- (IBAction)addKeyPoint:(id)sender
{
    if ([self isEditing]) {
        [self addEntry:[BNoteFactory createKeyPoint:[self note]]];
    } else {
        [self setFilter:KeyPointType];
    }
}

- (IBAction)addQuestion:(id)sender
{
    if ([self isEditing]) {
        [self addEntry:[BNoteFactory createQuestion:[self note]]];
    } else {
        [self setFilter:QuestionType];
    }
}

- (IBAction)addDecision:(id)sender
{
    if ([self isEditing]) {
        [self addEntry:[BNoteFactory createDecision:[self note]]];
    } else {
        [self setFilter:DecistionType];
    }
}

- (IBAction)addActionItem:(id)sender
{
    if ([self isEditing]) {
        [self addEntry:[BNoteFactory createActionItem:[self note]]];
    } else {
        [self setFilter:ActionItemType];
    }
}

- (void)addEntry:(Entry *)entry
{
    [[self entriesViewController] reload];
    if (![entry isKindOfClass:[Attendants class]]) {
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
    [[self keyPointButton] setHidden:NO];
    [[self questionButton] setHidden:NO];
    [[self decisionButton] setHidden:NO];
    [[self actionItemButton] setHidden:NO];
    [[self attendantsButton] setHidden:[BNoteEntryUtils noteContainsAttendants:[self note]]];
    [[self reviewButton] setHidden:NO];
    [[self shareButton] setHidden:NO];
}

- (void)setupTableViewForDeletingRows
{
    [[self entriesViewController] setEditing:YES animated:YES]; 
    [[self keyPointButton] setHidden:YES];
    [[self questionButton] setHidden:YES];
    [[self decisionButton] setHidden:YES];
    [[self actionItemButton] setHidden:YES];
    [[self attendantsButton] setHidden:YES];
    [[self reviewButton] setHidden:YES];
    [[self shareButton] setHidden:YES];
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

- (IBAction)presentShareOptions:(id)sender
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

- (void)updateToolBar:(NSNotification *)notification
{
    [[self attendantsButton] setHidden:NO];
}

- (void)normalIcons
{
    [[self keyPointButton] setIcon:[BNoteFactory createIcon:KeyPointIcon]];
    [[self actionItemButton] setIcon:[BNoteFactory createIcon:ActionItemIcon]];
    [[self decisionButton] setIcon:[BNoteFactory createIcon:DecisionIcon]];
    [[self questionButton] setIcon:[BNoteFactory createIcon:QuestionIcon]];
    [[self attendantsButton] setIcon:[BNoteFactory createIcon:AttentiesIcon]];
}

- (void)funnelIcons
{
    [[self keyPointButton] setIcon:[BNoteFactory createIcon:FilterIcon]];
    [[self actionItemButton] setIcon:[BNoteFactory createIcon:FilterIcon]];
    [[self decisionButton] setIcon:[BNoteFactory createIcon:FilterIcon]];
    [[self questionButton] setIcon:[BNoteFactory createIcon:FilterIcon]];
    [[self attendantsButton] setIcon:[BNoteFactory createIcon:FilterIcon]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)setFilter:(BNoteFilterType)filterType
{
    id<BNoteFilter> currentFilter = [[self entriesViewController] filter];
    id<BNoteFilter> nextFilter = [[BNoteFilterFactory instance] create:filterType];
    
    if (currentFilter == nextFilter) {
        nextFilter = [[BNoteFilterFactory instance] create:ItdentityType];
    }
    
    [[self entriesViewController] setFilter:nextFilter];
}

- (IBAction)about:(id)sender
{
    InformationViewController *controller = [[InformationViewController alloc] initWithDefault];
    [controller setModalPresentationStyle:UIModalPresentationFullScreen];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self presentModalViewController:controller animated:YES];
}

@end

