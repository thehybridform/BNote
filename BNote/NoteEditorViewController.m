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
#import "BNoteButton.h"
#import "EditNoteView.h"
#import "BNoteFilterHelper.h"
#import "BNoteAnimation.h"
#import "BNoteTextField.h"

@interface NoteEditorViewController ()
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
@property (strong, nonatomic) IBOutlet UILabel *filteringLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *subjectTextView;
@property (strong, nonatomic) IBOutlet BNoteButton *closeButton;
@property (strong, nonatomic) IBOutlet BNoteButton *attendantsButton;
@property (strong, nonatomic) IBOutlet BNoteButton *keyPointButton;
@property (strong, nonatomic) IBOutlet BNoteButton *questionButton;
@property (strong, nonatomic) IBOutlet BNoteButton *decisionButton;
@property (strong, nonatomic) IBOutlet BNoteButton *actionItemButton;
@property (strong, nonatomic) IBOutlet BNoteButton *reviewButton;
@property (strong, nonatomic) IBOutlet BNoteButton *trashButton;
@property (strong, nonatomic) IBOutlet BNoteButton *addSummaryButton;
@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet EditNoteView *infoView;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIView *normalEntryButtonsView;
@property (strong, nonatomic) IBOutlet UIView *reviewEntryButtonsView;
@property (strong, nonatomic) IBOutlet UIScrollView *reviewScrollView;
@property (strong, nonatomic) UIButton *selectedFilterButton;

@property (strong, nonatomic) IBOutlet EntriesViewController *entriesViewController;

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
@synthesize menuView = _menuView;
@synthesize infoView = _infoView;
@synthesize month = _month;
@synthesize shareButton = _shareButton;
@synthesize footerView = _footerView;
@synthesize entryLabel = _entryLabel;
@synthesize isEditing = _isEditing;
@synthesize titleLabel = _titleLabel;
@synthesize normalEntryButtonsView = _normalEntryButtonsView;
@synthesize reviewEntryButtonsView = _reviewEntryButtonsView;
@synthesize filteringLabel = _filteringLabel;
@synthesize reviewScrollView = _reviewScrollView;
@synthesize selectedFilterButton = _selectedFilterButton;
@synthesize addSummaryButton = _addSummaryButton;
@synthesize closeButton = _closeButton;

static NSString *closeText;
static NSString *reviewText;
static NSString *doneText;
static NSString *filteringText;
static NSString *entryText;
static NSString *addSummaryText;

static NSString *keyPointText;
static NSString *questionText;
static NSString *decisionText;
static NSString *actionItemText;
static NSString *attendeesText;

static NSString *spacing = @"   ";

- (void)viewDidUnload
{
    [super viewDidUnload];
    
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
    [self setMenuView:nil];
    [self setInfoView:nil];
    [self setMonth:nil];
    [self setShareButton:nil];
    [self setEntryLabel:nil];
    [self setTitleLabel:nil];
    [self setReviewEntryButtonsView:nil];
    [self setNormalEntryButtonsView:nil];
    [self setFilteringLabel:nil];
    [self setReviewScrollView:nil];
    [self setAddSummaryButton:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    self = [super initWithNibName:@"NoteEditorViewController" bundle:nil];
    if (self) {

    }
    
    closeText = NSLocalizedString(@"Close", @"Close window");
    reviewText = NSLocalizedString(@"REVIEW", @"Review");
    doneText = NSLocalizedString(@"Done", @"Done");
    filteringText = NSLocalizedString(@"FILTERING", @"Note entry filtering lable");
    entryText = NSLocalizedString(@"ENTRY", @"Note entry lable");
    addSummaryText = NSLocalizedString(@"Add Summary", @"Add summary entry to this note");

    keyPointText = NSLocalizedString(@"Key Point", @"Add key point button title");
    questionText = NSLocalizedString(@"Question", @"Add quetion button title");
    decisionText = NSLocalizedString(@"Decision", @"Add decision button title");
    actionItemText = NSLocalizedString(@"Action Item", @"Add action item button title");
    attendeesText = NSLocalizedString(@"Attendees", @"Add attendees button title");

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.closeButton setTitle:closeText forState:UIControlStateNormal];
    [self.reviewButton setTitle:reviewText forState:UIControlStateNormal];
    [[self addSummaryButton] setTitle:addSummaryText forState:UIControlStateNormal];

    [[self keyPointButton] setTitle:[spacing stringByAppendingString:keyPointText] forState:UIControlStateNormal];
    [[self questionButton] setTitle:[spacing stringByAppendingString:questionText] forState:UIControlStateNormal];
    [[self decisionButton] setTitle:[spacing stringByAppendingString:decisionText] forState:UIControlStateNormal];
    [[self actionItemButton] setTitle:[spacing stringByAppendingString:actionItemText] forState:UIControlStateNormal];
    [[self attendantsButton] setTitle:[spacing stringByAppendingString:attendeesText] forState:UIControlStateNormal];

    self.filteringLabel.text = filteringText;
    self.entryLabel.text = entryText;
    
    [LayerFormater addShadowToView:[self footerView]];
    [LayerFormater addShadowToView:[self menuView]];

    [LayerFormater setBorderWidth:1 forView:[self footerView]];
    [LayerFormater setBorderWidth:1 forView:[self menuView]];
    [LayerFormater setBorderColor:[BNoteConstants darkGray2] forView:[self footerView]];
    [LayerFormater setBorderColor:[BNoteConstants darkGray] forView:[self menuView]];

    [LayerFormater roundCornersForView:[self dateView]];
    [LayerFormater setBorderColor:[BNoteConstants colorFor:BNoteColorHighlight] forView:[self menuView]];
    [LayerFormater setBorderWidth:1 forView:[self menuView]];
    
    [LayerFormater setBorderColor:[UIColor lightGrayColor] forView:[self infoView]];
    
    [[self keyPointButton] setIcon:[BNoteFactory createIcon:KeyPointIcon]];
    [[self actionItemButton] setIcon:[BNoteFactory createIcon:ActionItemIcon]];
    [[self decisionButton] setIcon:[BNoteFactory createIcon:DecisionIcon]];
    [[self questionButton] setIcon:[BNoteFactory createIcon:QuestionIcon]];
    [[self attendantsButton] setIcon:[BNoteFactory createIcon:AttentiesIcon]];

    [LayerFormater setBorderWidth:1 forView:[self infoView]];
    
    [[self year] setTextColor:[BNoteConstants appHighlightColor1]];
    [[self subjectTextView] setTextColor:[BNoteConstants appHighlightColor1]];

    [[self titleLabel] setFont:[BNoteConstants font:RobotoBold andSize:18]];
    [[self titleLabel] setTextColor:[BNoteConstants appHighlightColor1]];
    
    [[[self keyPointButton] titleLabel] setFont:[BNoteConstants font:RobotoRegular andSize:12]];
    [[[self actionItemButton] titleLabel] setFont:[BNoteConstants font:RobotoRegular andSize:12]];
    [[[self attendantsButton] titleLabel] setFont:[BNoteConstants font:RobotoRegular andSize:12]];
    [[[self decisionButton] titleLabel] setFont:[BNoteConstants font:RobotoRegular andSize:12]];
    [[[self questionButton] titleLabel] setFont:[BNoteConstants font:RobotoRegular andSize:12]];

    [[self entryLabel] setFont:[BNoteConstants font:RobotoBold andSize:14]];
    [[self entryLabel] setTextColor:[BNoteConstants appHighlightColor1]];
    [[self filteringLabel] setFont:[BNoteConstants font:RobotoBold andSize:14]];
    [[self filteringLabel] setTextColor:[BNoteConstants appHighlightColor1]];

    [[self dateView] setBackgroundColor:[BNoteConstants appHighlightColor1]];
    [[self year] setFont:[BNoteConstants font:RobotoRegular andSize:17]];
    [[self month] setFont:[BNoteConstants font:RobotoBold andSize:11]];
    [[self day] setFont:[BNoteConstants font:RobotoRegular andSize:34]];
    [[self time] setFont:[BNoteConstants font:RobotoRegular andSize:15]];
    [[self subjectTextView] setFont:[BNoteConstants font:RobotoRegular andSize:20]];
    [[self subjectTextView] setTextColor:UIColorFromRGB(0x444444)];
    self.subjectTextView.delegate = self;
    self.subjectTextView.placeholder = NSLocalizedString(@"Enter Subject", @"note subject place holder.");

    UITapGestureRecognizer *normalTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDatePicker:)];
    [[self dateView] addGestureRecognizer:normalTap];

    [LayerFormater roundCornersForView:[self infoView]];
    [LayerFormater setBorderWidth:2 forView:[self infoView]];
    [LayerFormater setBorderColor:[BNoteConstants appHighlightColor1] forView:[self infoView]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateToolBar:)
                                                 name:kAttendantsEntryDeleted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyWordsUpdated:)
                                                 name:kKeyWordsUpdated object:nil];
}

- (void)setNote:(Note *)note
{
    _note = note;
    
    [self setup];
}

- (void)setup
{
    [self setupDate];

    Note *note = [self note];
    if ([BNoteStringUtils nilOrEmpty:[note subject]]) {
        [[self subjectTextView] setText:nil];
    } else {
        [[self subjectTextView] setText:[note subject]];
    }
    
    [[self entriesViewController] setNote:note];
    [[self titleLabel] setText:[[note topic] title]];
    [[self attendantsButton] setHidden:[BNoteEntryUtils noteContainsAttendants:note]];
    [[self infoView] setNote:note];
    [[self infoView] setNeedsDisplay];
    
    [self editing];
}

- (void)showNormalButtons
{
    NSArray *views = [[NSArray alloc]
                      initWithObjects:
                      [self attendantsButton],
                      [self actionItemButton],
                      [self decisionButton],
                      [self questionButton],
                      [self keyPointButton],
                      nil];
    
    [BNoteAnimation winkInView:views withDuration:0.15 andDelay:0.6 andDelayIncrement:0.1 spark:YES];
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

- (IBAction)done:(id)sender
{
    [BNoteEntryUtils cleanUpEntriesForNote:[self note]];
    [[self note] setSubject:[[self subjectTextView] text]];
    [[BNoteWriter instance] update];
    
    [self dismissModalViewControllerAnimated:YES];
    [self setupTableViewAddingEntries];

    [[BNoteSessionData instance] setMainViewController:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kClosedNoteEditor object:[[self note] topic]];
}

- (IBAction)editMode:(id)sender
{
    if ([self isEditing]) {
        [self reviewing];
    } else {
        [self editing];
        [[self entriesViewController] setFilter:[[BNoteFilterFactory instance] create:ItdentityType]];
    }
}

- (void)editing
{
    [[self reviewButton] setTitle:reviewText forState:UIControlStateNormal];
    [[self attendantsButton] setHidden:[BNoteEntryUtils noteContainsAttendants:[self note]]];
    [self setIsEditing:YES];
    
    [[self reviewEntryButtonsView] setHidden:YES];
    [[self normalEntryButtonsView] setHidden:NO];
    [[self trashButton] setHidden:NO];
    [[self addSummaryButton] setHidden:YES];
    
    [self showNormalButtons];

    [[NSNotificationCenter defaultCenter] postNotificationName:kEditingNote object:nil];
}

- (void)reviewing
{
    [[self reviewButton] setTitle:doneText forState:UIControlStateNormal];
    [[self attendantsButton] setHidden:YES];
    [self setIsEditing:NO];
    
    [[self reviewEntryButtonsView] setHidden:NO];
    [[self normalEntryButtonsView] setHidden:YES];
    [[self trashButton] setHidden:YES];
    
    BOOL showingSummary = [[self entriesViewController] showingSummary];
    [[self addSummaryButton] setHidden:showingSummary];

    [BNoteFilterHelper setupFilterButtonsFor:self inView:[self reviewScrollView]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kReviewingNote object:nil];
}

- (void)keyWordsUpdated:(NSNotification *)notification
{
    if (![self isEditing]) {
        [BNoteFilterHelper setupFilterButtonsFor:self inView:[self reviewScrollView]];
    }
}

- (IBAction)addAttendies:(id)sender
{
    [[self attendantsButton] setHidden:YES];
    [self addEntry:[BNoteFactory createAttendants:[self note]]];
}

- (IBAction)addKeyPoint:(id)sender
{
    [self addEntry:[BNoteFactory createKeyPoint:[self note]]];
}

- (IBAction)addQuestion:(id)sender
{
    [self addEntry:[BNoteFactory createQuestion:[self note]]];
}

- (IBAction)addDecision:(id)sender
{
    [self addEntry:[BNoteFactory createDecision:[self note]]];
}

- (IBAction)addActionItem:(id)sender
{
    [self addEntry:[BNoteFactory createActionItem:[self note]]];
}

- (void)addEntry:(Entry *)entry
{
#ifdef LITE
    if ([[[self note] entries] count] > kMaxEntries) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"More Notes Entries Not Supported", nil)
                              message:nil
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                              otherButtonTitles:nil];

        [alert show];
        
        [[BNoteWriter instance] removeEntry:entry];
        
        return;
    }
    
#endif

    [[self entriesViewController] addAndSelectLastEntry:entry];
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
    [[self subjectTextView] resignFirstResponder];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[[self note] created]];
    
    DatePickerViewController *controller = [[DatePickerViewController alloc] initWithDate:date];
    [controller setListener:self];
    [controller setTitleText:NSLocalizedString(@"Created Date", nil)];

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
                                     animated:NO];
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

- (void)updateToolBar:(NSNotification *)notification
{
    [[self attendantsButton] setHidden:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)useFilter:(id<BNoteFilter>)filter sender:(UIButton *)button
{

    [[self selectedFilterButton] setSelected:NO];

    id<BNoteFilter> currentFilter = [[self entriesViewController] filter];
    
    if (currentFilter == filter) {
        currentFilter = [[BNoteFilterFactory instance] create:ItdentityType];
    } else {
        [button setSelected:YES];
        currentFilter = filter;
    }
    
    [self setSelectedFilterButton:button];

    [[self entriesViewController] setFilter:currentFilter];
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [[self subjectTextView] resignFirstResponder];
    [[self entriesViewController] resignControll];
    [[[BNoteSessionData instance] actionSheet] dismissWithClickedButtonIndex:-1 animated:YES];
    [[[BNoteSessionData instance] popup] dismissPopoverAnimated:YES];
}

- (IBAction)addSummary:(id)sender
{
    [[self entriesViewController] displaySummary];
    self.addSummaryButton.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.subjectTextView resignFirstResponder];
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [((BNoteTextField *)textField) showFrame:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [((BNoteTextField *)textField) showFrame:NO];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

