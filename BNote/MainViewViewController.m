//
//  MainViewViewController.m
//  BeNote
//
//  Created by Young Kristin on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewViewController.h"
#import "LayerFormater.h"
#import "InformationViewController.h"
#import "EntrySummariesTableViewController.h"
#import "MasterViewController.h"
#import "PeopleViewController.h"
#import "Topic.h"
#import "NotesViewController.h"
#import "Entry.h"
#import "Note.h"
#import "EmailViewController.h"
#import "TopicEditorViewController.h"
#import "BNoteSessionData.h"
#import "BNoteReader.h"
#import "BNoteFactory.h"
#import "BNoteWriter.h"
#import "TopicGroupsViewController.h"
#import "TopicGroupManagementViewController.h"
#import "BNoteButton.h"
#import "BNoteExporterViewController.h"

@interface MainViewViewController ()
@property (strong, nonatomic) IBOutlet BNoteButton *topicsButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *addTopicButton;
@property (strong, nonatomic) IBOutlet UILabel *notesLabel;
@property (strong, nonatomic) IBOutlet UILabel *peopleLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UIView *menu;
@property (strong, nonatomic) IBOutlet UIView *footer;
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet MasterViewController *topicsTable;
@property (strong, nonatomic) IBOutlet EntrySummariesTableViewController *entriesTable;
@property (strong, nonatomic) IBOutlet NotesViewController *notesViewController;
@property (strong, nonatomic) IBOutlet PeopleViewController *peopleViewController;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UILabel *liteLable;

@property (strong, nonatomic) TopicGroup *topicGroup;

@end

@implementation MainViewViewController
@synthesize menu = _menu;
@synthesize topicsTable = _topicsTable;
@synthesize entriesTable = _entriesTable;
@synthesize detailView = _detailView;
@synthesize peopleViewController = _peopleViewController;
@synthesize countLabel = _countLabel;
@synthesize notesLabel = _notesLabel;
@synthesize peopleLabel = _peopleLabel;
@synthesize shareButton = _shareButton;
@synthesize addTopicButton = _addTopicButton;
@synthesize footer = _footer;
@synthesize topicsButton = _topicsButton;
@synthesize searchTopic = _searchTopic;
@synthesize topicGroup = _topicGroup;
@synthesize searchBar = _searchBar;
@synthesize liteLable = _liteLable;

static NSString *emailTopicText;
static NSString *exportText;

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setMenu:nil];
    [self setTopicsTable:nil];
    [self setEntriesTable:nil];
    [self setDetailView:nil];
    [self setNotesViewController:nil];
    [self setPeopleViewController:nil];
    [self setCountLabel:nil];
    [self setNotesLabel:nil];
    [self setPeopleLabel:nil];
    [self setShareButton:nil];
    [self setAddTopicButton:nil];
    [self setFooter:nil];
    [self setTopicsButton:nil];
    [self setLiteLable:nil];
    
    if ([self searchTopic]) {
        [[BNoteWriter instance] removeTopic:[self searchTopic]];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithDefault
{
    self = [super initWithNibName:@"MainViewViewController" bundle:nil];
    
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]
        addObserver:[self topicsButton] selector:@selector(updateTitle:) name:kTopicGroupSelected object:nil];

    [LayerFormater setBorderWidth:1 forView:[self footer]];
    [LayerFormater setBorderColor:[BNoteConstants darkGray2] forView:[self footer]];

    [LayerFormater setBorderWidth:1 forView:[self menu]];
    [LayerFormater setBorderColor:[BNoteConstants darkGray] forView:[self menu]];
    
    [LayerFormater addShadowToView:[self footer]];
    [LayerFormater addShadowToView:[self menu]];
    
    [[self notesLabel] setTextColor:[BNoteConstants appHighlightColor1]];
    [[self peopleLabel] setTextColor:[BNoteConstants appHighlightColor1]];
    
    [[self notesLabel] setFont:[BNoteConstants font:RobotoRegular andSize:18.0]];
    [[self peopleLabel] setFont:[BNoteConstants font:RobotoRegular andSize:14.0]];
    [[self countLabel] setFont:[BNoteConstants font:RobotoRegular andSize:24.0]];

    [[self detailView] setHidden:YES];
    [[self detailView] setBackgroundColor:[BNoteConstants appColor1]];

    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(selectedTopic:) name:kTopicSelected object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(selectedNote:) name:kNoteSelected object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(presentTopicManagement:) name:kTopicGroupManage object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(selectedTopicGroup:) name:kTopicGroupSelected object:nil];
    
#ifdef LITE
    [[self liteLable] setFont:[BNoteConstants font:RobotoBold andSize:20]];
    [[self liteLable] setTextColor:[BNoteConstants appHighlightColor1]];
#else
    [[self liteLable] setHidden:YES];
#endif
    
    self.searchBar.placeholder = NSLocalizedString(@"Search All Topics", @"Search all topics.");
    self.notesLabel.text = NSLocalizedString(@"Notes", @"The notes section title.");
    self.peopleLabel.text = NSLocalizedString(@"People", @"The attendees section title.");
    
    emailTopicText = NSLocalizedString(@"Email Selected Topic", nil);
    exportText = NSLocalizedString(@"Archive Options", nil);
}

- (void)selectedTopic:(NSNotification *)notification
{
    if ([[self detailView] isHidden]) {
        [[self detailView] setHidden:NO];
    }
    
    Topic *topic = [notification object];
    if (!topic) {
        [[self detailView] setHidden:YES];
    }

    [[self entriesTable] setTopic:topic];
    [[self notesViewController] setTopic:topic];
    [[self peopleViewController] setTopic:topic];
    
    [[self peopleLabel] setHidden:![BNoteEntryUtils topicContainsAttendants:topic]];
    
    [self setNoteCountForTopic:topic];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNoteCount:)
                                                 name:kTopicUpdated object:topic];
}

- (void)selectedNote:(NSNotification *)notification
{
    Note *note;
    Entry *entry;
    
    NSObject *object = [notification object];
    if ([object isKindOfClass:[Entry class]]) {
        entry = (Entry *)object;
        note = [entry note];
    } else {
        note = (Note *)object;
    }
   
    NoteEditorViewController *noteController = [[NoteEditorViewController alloc] init];
    [noteController setModalPresentationStyle:UIModalPresentationFullScreen];
    [noteController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentModalViewController:noteController animated:YES];
    [BNoteSessionData instance].mainViewController = noteController;

    [noteController setNote:note];

    if (entry) {
        [noteController selectEntry:entry];
    }
}

- (void)updateNoteCount:(NSNotification *)notification
{
    Topic *topic = [notification object];
    [self setNoteCountForTopic:topic];
}

- (void)selectedTopicGroup:(NSNotification *)notification
{
    if ([self searchTopic]) {
        [[BNoteWriter instance] removeTopic:[self searchTopic]];
        [self setSearchTopic:nil];
    }
    
    [[self searchBar] setText:nil];
        
    [self setTopicGroup:[notification object]];
}

- (void)setNoteCountForTopic:(Topic *)topic
{
    int count = [[topic notes] count] + [[topic associatedNotes] count];
    
    NSString *s = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:count] numberStyle:NSNumberFormatterNoStyle];
    [[self countLabel] setText:s];
}

- (IBAction)addTopic:(id)sender
{
#ifdef LITE
    if ([[[self topicGroup] topics] count] > kMaxTopics) {
        UIAlertView *alert = [[UIAlertView alloc]
                                initWithTitle:NSLocalizedString(@"More Topics Not Supported", nil)
                                message:nil
                                delegate:self
                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                otherButtonTitles:nil];

        [alert show];
        return;
    }
    
#endif
    
    TopicGroup *topicGroup = [self topicGroup];
    TopicEditorViewController *controller = [[TopicEditorViewController alloc] initWithTopicGroup:topicGroup];
    
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
    [[BNoteSessionData instance] setPopup:popup];
    [popup setDelegate:self];
    [controller setPopup:popup];
    
    [popup setPopoverContentSize:[[controller view] bounds].size];
    
    UIView *view = [self addTopicButton];
    CGRect rect = [view bounds];
    
    [popup presentPopoverFromRect:rect inView:[self addTopicButton]
         permittedArrowDirections:UIPopoverArrowDirectionAny 
                         animated:NO];
}

- (IBAction)about:(id)sender
{
    InformationViewController *controller = [[InformationViewController alloc] initWithDefault];
    [controller setModalPresentationStyle:UIModalPresentationFullScreen];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self presentModalViewController:controller animated:YES];
}

- (IBAction)presentShareOptions:(id)sender
{
    if (![[BNoteSessionData instance] actionSheet]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        [actionSheet setDelegate:[BNoteSessionData instance]];
        [[BNoteSessionData instance] setActionSheetDelegate:self];
        [[BNoteSessionData instance] setActionSheet:actionSheet];
        
        if ([MFMailComposeViewController canSendMail]) {
            [actionSheet addButtonWithTitle:emailTopicText];
        }
        
        [actionSheet addButtonWithTitle:exportText];
        
        UIView *view = self.shareButton;
        CGRect rect = view.bounds;
        [actionSheet showFromRect:rect inView:view animated:NO];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0) {
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if (title == emailTopicText) {
            [self presentEmailer];
        } else if (title == exportText) {
            BNoteExporterViewController *controller = [[BNoteExporterViewController alloc] initWithDefault];
            [controller setModalPresentationStyle:UIModalPresentationFormSheet];
            [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            
            [self presentModalViewController:controller animated:YES];
        }
    }
}

- (void)presentEmailer
{
    EmailViewController *controller = [[EmailViewController alloc] initWithTopic:[[self entriesTable] topic]];
    [controller setModalPresentationStyle:UIModalPresentationPageSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self presentModalViewController:controller animated:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [[BNoteSessionData instance] setPopup:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self handleSearch:[searchBar text]];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self handleSearch:[searchBar text]];
}

- (void)handleSearch:(NSString *)searchText
{
    [[BNoteWriter instance] removeTopic:[self searchTopic]];

    if ([BNoteStringUtils nilOrEmpty:searchText]) {
        [self setSearchTopic:nil];
        [[self entriesTable] setSearchText:nil];

        [[NSNotificationCenter defaultCenter] postNotificationName:kRefetchAllDatabaseData object:nil];
    } else {
        Topic *topic = [BNoteFactory createTopic:kFilteredTopicName forGroup:[self topicGroup] withSearch:searchText];
        [topic setColor:kFilterColor];
        [self setSearchTopic:topic];
        [[self entriesTable] setSearchText:searchText];
    
        [[NSNotificationCenter defaultCenter] postNotificationName:kTopicCreated object:topic];
    }
}

- (IBAction)showTopicGroups:(id)sender
{
    TopicGroupsViewController *controller = [[TopicGroupsViewController alloc] init];
    
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
    [[BNoteSessionData instance] setPopup:popup];
    [popup setDelegate:self];
    [controller setPopup:popup];

    [popup setPopoverContentSize:[[controller view] bounds].size];
    
    UIView *view = [self topicsButton];
    CGRect rect = [view bounds];
    
    [popup presentPopoverFromRect:rect inView:view
         permittedArrowDirections:UIPopoverArrowDirectionAny 
                         animated:NO];
}

- (void)presentTopicManagement:(NSNotification *)notification
{
    TopicGroupManagementViewController *controller = [[TopicGroupManagementViewController alloc] init];
    
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
    [[BNoteSessionData instance] setPopup:popup];
    [popup setDelegate:controller];
    [controller setPopup:popup];
    
    [popup setPopoverContentSize:[[controller view] bounds].size];
    
    UIView *view = [self topicsButton];
    CGRect rect = [view bounds];
    
    [popup presentPopoverFromRect:rect inView:view
         permittedArrowDirections:UIPopoverArrowDirectionAny 
                         animated:NO];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [[[BNoteSessionData instance] actionSheet] dismissWithClickedButtonIndex:-1 animated:YES];
    [[[BNoteSessionData instance] popup] dismissPopoverAnimated:YES];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [[self notesViewController] reset];
    [[self notesViewController] reload];
    
    [[self peopleViewController] reset];
    [[self peopleViewController] reload];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
