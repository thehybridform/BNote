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

@property (strong, nonatomic) TopicGroup *topicGroup;

@end

@implementation MainViewViewController
@synthesize menu = _menu;
@synthesize topicsTable = _topicsTable;
@synthesize entriesTable = _entriesTable;
@synthesize detailView = _detailView;
@synthesize notesViewController = _notesViewController;
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

static NSString *email = @"E-mail";

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
        addObserver:[self topicsButton] selector:@selector(updateTitle:) name:TopicGroupSelected object:nil];

    [LayerFormater setBorderWidth:1 forView:[self footer]];
    [LayerFormater setBorderWidth:1 forView:[self menu]];
    [LayerFormater setBorderColor:[UIColor lightGrayColor] forView:[self footer]];
    [LayerFormater setBorderColor:[UIColor lightGrayColor] forView:[self menu]];
    [LayerFormater setBorderColor:[UIColor lightGrayColor] forView:[self detailView]];
    
    [LayerFormater addShadowToView:[self footer]];
    [LayerFormater addShadowToView:[self menu]];
    
    [[self notesLabel] setTextColor:[BNoteConstants appHighlightColor1]];
    [[self peopleLabel] setTextColor:[BNoteConstants appHighlightColor1]];
    
    [[self notesLabel] setFont:[BNoteConstants font:RobotoRegular andSize:18.0]];
    [[self peopleLabel] setFont:[BNoteConstants font:RobotoRegular andSize:18.0]];
    [[self countLabel] setFont:[BNoteConstants font:RobotoRegular andSize:28.0]];

    [[self detailView] setHidden:YES];
    [[self detailView] setBackgroundColor:[BNoteConstants appColor1]];

    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(selectedTopic:) name:TopicSelected object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(selectedNote:) name:NoteSelected object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(presentTopicManagement:) name:TopicGroupManage object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(selectedTopicGroup:) name:TopicGroupSelected object:nil];
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
                                                 name:TopicUpdated object:topic];
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
   
    NoteEditorViewController *noteController = [[NoteEditorViewController alloc] initWithNote:note];
    [noteController setModalPresentationStyle:UIModalPresentationFullScreen];
    [noteController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    [self presentModalViewController:noteController animated:YES];
    
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
    
    NSString *s = [NSString stringWithFormat:@"%d", count];
    [[self countLabel] setText:s];
}

- (IBAction)addTopic:(id)sender
{
    TopicGroup *topicGroup = [self topicGroup];
    TopicEditorViewController *controller = [[TopicEditorViewController alloc] initWithTopicGroup:topicGroup];
    
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
    [[BNoteSessionData instance] setPopup:popup];
    [popup setDelegate:self];
    [controller setPopup:popup];
    
    [popup setPopoverContentSize:[[controller view] bounds].size];
    
    UIView *view = [self addTopicButton];
    CGRect rect = [view bounds];
    
    [popup presentPopoverFromRect:rect inView:view
         permittedArrowDirections:UIPopoverArrowDirectionAny 
                         animated:YES];
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
    [self presentEmailer];
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

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
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

        [[NSNotificationCenter defaultCenter] postNotificationName:RefetchAllDatabaseData object:nil];
    } else {
        Topic *topic = [BNoteFactory createTopic:kFilteredTopicName forGroup:[self topicGroup] withSearch:searchText];
        [topic setColor:FilterColor];
        [self setSearchTopic:topic];
        [[self entriesTable] setSearchText:searchText];
    
        [[NSNotificationCenter defaultCenter] postNotificationName:TopicCreated object:topic];
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
                         animated:YES];
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
                         animated:YES];
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

@end
