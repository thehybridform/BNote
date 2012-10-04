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
#import "Decision.h"
#import "BNoteFactory.h"
#import "BNoteSessionData.h"
#import "BNoteWriter.h"
#import "EmailViewController.h"
#import "BNoteButton.h"
#import "EditNoteView.h"
#import "BNoteFilterHelper.h"
#import "BNoteAnimation.h"
#import "BNoteLiteViewController.h"
#import "ContactMailController.h"

@interface NoteEditorViewController ()
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
@property (strong, nonatomic) IBOutlet UIView *shadowView;
@property (strong, nonatomic) IBOutlet UIView *entryTableView;

@property (assign, nonatomic) BOOL isEditing;

@end

@implementation NoteEditorViewController

@synthesize dateView = _dateView;
@synthesize day = _day;
@synthesize year = _year;
@synthesize time = _time;
@synthesize subjectTextView = _subjectTextView;
@synthesize note = _note;
@synthesize keyPointButton = _keyPointButton;
@synthesize questionButton= _questionButton;
@synthesize decisionButton = _decisionButton;
@synthesize actionItemButton = _actionItemButton;
@synthesize reviewButton = _reviewButton;
@synthesize trashButton = _trashButton;
@synthesize entriesViewController = _entriesViewController;
@synthesize attendantsButton = _attendantsButton;
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
@synthesize shadowView = _shadowView;
@synthesize entryTableView = _entryTableView;

static NSString *closeText;
static NSString *reviewText;
static NSString *reviewButtonText;
static NSString *kDoneText;
static NSString *filteringText;
static NSString *entryText;
static NSString *addSummaryText;

static NSString *keyPointText;
static NSString *questionText;
static NSString *decisionText;
static NSString *actionItemText;
static NSString *attendeesText;

static NSString *emailNoteText;
static NSString *exportText;
static NSString *changeTopicText;
static NSString *topicAssociationsText;

static NSString *contactUs;

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
    self.shadowView = nil;
    self.entryTableView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    self = [super initWithNibName:@"NoteEditorViewController" bundle:nil];
    if (self) {

    }
    
    closeText = NSLocalizedString(@"Close", @"Close window");
    reviewText = NSLocalizedString(@"REVIEW", @"Review");
    reviewButtonText = NSLocalizedString(@"Review", @"Review");
    kDoneText = NSLocalizedString(@"Done", @"Done");
    filteringText = NSLocalizedString(@"REVIEW", @"Note entry filtering lable");
    entryText = NSLocalizedString(@"ENTRY", @"Note entry lable");
    addSummaryText = NSLocalizedString(@"Add Summary", @"Add summary entry to this note");

    keyPointText = NSLocalizedString(@"Key Point", @"Add key point button title");
    questionText = NSLocalizedString(@"Question", @"Add quetion button title");
    decisionText = NSLocalizedString(@"Decision", @"Add decision button title");
    actionItemText = NSLocalizedString(@"Action Item", @"Add action item button title");
    attendeesText = NSLocalizedString(@"Attendees", @"Add attendees button title");

    emailNoteText = NSLocalizedString(@"Email Selected Note", nil);
    exportText = NSLocalizedString(@"Archive Options", nil);
    changeTopicText = NSLocalizedString(@"Change Topic", nil);
    topicAssociationsText = NSLocalizedString(@"Associated Topics", nil);

    contactUs = NSLocalizedString(@"Contact Us", nil);

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
    
    [self.closeButton setTitle:closeText forState:UIControlStateNormal];
    [self.reviewButton setTitle:reviewButtonText forState:UIControlStateNormal];
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

    [LayerFormater setBorderColor:[UIColor lightGrayColor] forView:[self infoView]];
    [LayerFormater roundCornersForView:self.dateView];
    [LayerFormater addShadowToView:self.shadowView];
    
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
    [[self year] setFont:[BNoteConstants font:RobotoRegular andSize:13]];
    [[self month] setFont:[BNoteConstants font:RobotoBold andSize:11]];
    [[self day] setFont:[BNoteConstants font:RobotoRegular andSize:26]];
    [[self time] setFont:[BNoteConstants font:RobotoRegular andSize:13]];
    [[self subjectTextView] setFont:[BNoteConstants font:RobotoRegular andSize:18]];

    self.subjectTextView.delegate = self;
    self.subjectTextView.placeholder = NSLocalizedString(@"Enter Subject", @"note subject place holder.");

    [LayerFormater setBorderWidth:1 forView:[self normalEntryButtonsView]];
    [LayerFormater setBorderColor:[BNoteConstants darkGray2] forView:[self normalEntryButtonsView]];
    [LayerFormater setBorderWidth:1 forView:[self reviewEntryButtonsView]];
    [LayerFormater setBorderColor:[BNoteConstants darkGray2] forView:[self reviewEntryButtonsView]];
    [LayerFormater addShadowToView:[self normalEntryButtonsView]];
    [LayerFormater addShadowToView:[self reviewEntryButtonsView]];

    [[self reviewEntryButtonsView] setHidden:YES];

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
    [numberFormatter setNumberStyle:(NSNumberFormatterStyle) NSNumberFormatterBehaviorDefault];
    
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
    str = [[format stringFromDate:date] lowercaseString];
    [[self time] setText:str];
    
    [format setDateFormat:@"yyyy"];
    str = [format stringFromDate:date];
    [[self year] setText:str];
}

- (IBAction)done:(id)sender
{
    [[self note] setSubject:[[self subjectTextView] text]];
    [BNoteEntryUtils cleanUpEntriesForNote:[self note]];
    [[BNoteWriter instance] update];
    
    [self dismissViewControllerAnimated:YES completion:^{}];
    [self setupTableViewAddingEntries];

    [[BNoteSessionData instance] setMainViewController:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kClosedNoteEditor object:self.note];
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
    [[self reviewButton] setTitle:reviewButtonText forState:UIControlStateNormal];
    [[self attendantsButton] setHidden:[BNoteEntryUtils noteContainsAttendants:[self note]]];
    [self setIsEditing:YES];
    
    [[self reviewEntryButtonsView] setHidden:YES];
    [[self normalEntryButtonsView] setHidden:NO];
    [[self trashButton] setHidden:NO];
    [[self addSummaryButton] setHidden:YES];
    
    [self showNormalButtons];
}

- (void)reviewing
{
    [[self reviewButton] setTitle:kDoneText forState:UIControlStateNormal];
    [[self attendantsButton] setHidden:YES];
    [self setIsEditing:NO];
    
    [[self reviewEntryButtonsView] setHidden:NO];
    [[self normalEntryButtonsView] setHidden:YES];
    [[self trashButton] setHidden:YES];
    
    BOOL showingSummary = [[self entriesViewController] showingSummary];
    [[self addSummaryButton] setHidden:showingSummary];

    [BNoteFilterHelper setupFilterButtonsFor:self inView:[self reviewScrollView]];
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

    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
    [[BNoteSessionData instance] setPopup:popup];
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
    [[BNoteSessionData instance] setPopup:nil];
}

- (IBAction)presentShareOptions:(id)sender
{
    if (![[BNoteSessionData instance] actionSheet]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        [actionSheet setDelegate:[BNoteSessionData instance]];
        [[BNoteSessionData instance] setActionSheetDelegate:self];
        [[BNoteSessionData instance] setActionSheet:actionSheet];
        
        if ([[[self note] topic] color] != kFilterColor) {
            [actionSheet addButtonWithTitle:changeTopicText];
            [actionSheet addButtonWithTitle:topicAssociationsText];
        }

        if ([MFMailComposeViewController canSendMail]) {
            [actionSheet addButtonWithTitle:emailNoteText];
        }
        
        [actionSheet addButtonWithTitle:exportText];
        [actionSheet addButtonWithTitle:contactUs];
        
        UIView *view = self.shareButton;
        CGRect rect = view.bounds;
        [actionSheet showFromRect:rect inView:view animated:NO];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0) {
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([title isEqualToString:emailNoteText]) {
            UIViewController *controller = [[EmailViewController alloc] initWithNote:[self note]];
            [self showModal:controller style:UIModalPresentationPageSheet];
        } else if ([title isEqualToString:exportText]) {
            BNoteExporterViewController *controller = [[BNoteExporterViewController alloc] initWithDefault];
            controller.note = self.note;
            controller.delegate = self;
            [self showModal:controller style:UIModalPresentationFormSheet];
        } else if ([title isEqualToString:topicAssociationsText]) {
            TopicManagementViewController *controller = [[TopicManagementViewController alloc] initWithNote:[self note] forType:AssociateTopic];
            controller.delegate = self;
            [self showPopup:controller];
        } else if ([title isEqualToString:changeTopicText]) {
            TopicManagementViewController *controller = [[TopicManagementViewController alloc] initWithNote:[self note] forType:ChangeMainTopic];
            controller.delegate = self;
            [self showPopup:controller];
        } else if ([title isEqualToString:contactUs]) {
            ContactMailController *controller = [[ContactMailController alloc] init];
            [controller setModalInPopover:YES];
            [controller setModalPresentationStyle:UIModalPresentationPageSheet];
            [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];

            [self presentViewController:controller animated:YES completion:^{}];
        }
    }
    
    [BNoteSessionData instance].actionSheet = nil;
}

- (void)showModal:(UIViewController *)controller style:(UIModalPresentationStyle)style
{
    [controller setModalPresentationStyle:style];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:controller animated:YES completion:^{}];
}

- (void)showPopup:(UIViewController *)controller
{
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
    [[BNoteSessionData instance] setPopup:popup];
    [popup setDelegate:self];
    
    [popup setPopoverContentSize:[[controller view] bounds].size];
    
    UIView *view = self.infoView;
    CGRect rect = [view bounds];
    
    [popup presentPopoverFromRect:rect inView:view
         permittedArrowDirections:UIPopoverArrowDirectionAny
                         animated:NO];
}

- (void)finishedWithTopic:(Topic *)topic
{
    [[BNoteSessionData instance].popup dismissPopoverAnimated:YES];
    [self.infoView setNeedsDisplay];
    self.titleLabel.text = topic.title;
}

- (void)finishedWithFile:(BNoteExportFileWrapper *)file
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^(void) {
        NSData *data = [NSData dataWithContentsOfFile:file.zipFile.fileName];
        
        EmailViewController *controller =
        [[EmailViewController alloc]
         initWithAttachment:data mimeType:@"application/zip" filename:kArchiveFilename];
        
        [controller setModalPresentationStyle:UIModalPresentationPageSheet];
        [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];

        [self presentViewController:controller animated:YES completion:^{}];
    }];
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
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

    [[self subjectTextView] resignFirstResponder];
    [[self entriesViewController] willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [[[BNoteSessionData instance] actionSheet] dismissWithClickedButtonIndex:-1 animated:YES];
    [[[BNoteSessionData instance] popup] dismissPopoverAnimated:YES];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    [self updateViewOrienation];
}

- (void)updateViewOrienation
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    BOOL portrait = UIInterfaceOrientationIsPortrait(orientation);

    [UIView animateWithDuration:0.3 animations:^{
        if (portrait) {
            self.infoView.frame = CGRectMake(50, 60, 666, 84);
            self.shadowView.frame = CGRectMake(54, 64, 658, 76);
            self.dateView.frame = CGRectMake(573, -7, 100, 60);
            self.year.frame = CGRectMake(615, 61, 45, 21);
            self.subjectTextView.frame = CGRectMake(95, 26, 477, 31);
            
            CGRect frame = self.entryTableView.frame;
            self.entryTableView.frame = CGRectMake(frame.origin.x, 199, 770, 783);
            
            self.normalEntryButtonsView.transform = CGAffineTransformIdentity;
            self.reviewEntryButtonsView.transform = CGAffineTransformIdentity;
        } else {
            self.infoView.frame = CGRectMake(20, 60, 210, 120);
            self.shadowView.frame = CGRectMake(22, 64, 206, 114);
            self.dateView.frame = CGRectMake(120, -7, 100, 60);
            self.year.frame = CGRectMake(160, 100, 45, 21);
            self.subjectTextView.frame = CGRectMake(4, 65, 206, 31);
            
            CGRect frame = self.entryTableView.frame;
            self.entryTableView.frame = CGRectMake(frame.origin.x, 85, 770, 620);
            
            CGAffineTransform translate = CGAffineTransformMakeTranslation(0, -114);
            self.normalEntryButtonsView.transform = translate;
            self.reviewEntryButtonsView.transform = translate;
        }
    } completion:^(BOOL finished) {
        
    }];
    
    [self.infoView setNeedsDisplay];
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

- (IBAction)about:(id)sender
{
    BNoteLiteViewController *controller = [[BNoteLiteViewController alloc] initWithDefault];
    controller.firstLoad = NO;
    
    [controller setModalPresentationStyle:UIModalPresentationFormSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];

    [self presentViewController:controller animated:YES completion:^{}];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateViewOrienation];
}

@end

