//
//  MainViewViewController.m
//  BeNote
//
//  Created by Young Kristin on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewViewController.h"
#import "LayerFormater.h"
#import "BNoteLiteViewController.h"
#import "EntrySummariesTableViewController.h"
#import "PeopleViewController.h"
#import "NotesViewController.h"
#import "EmailViewController.h"
#import "BNoteSessionData.h"
#import "BNoteReader.h"
#import "BNoteFactory.h"
#import "BNoteWriter.h"
#import "TopicGroupsViewController.h"
#import "BNoteButton.h"
#import "TopicGroupManagementViewController.h"
#import "BNoteUnarshallingManager.h"
#import "ContactMailController.h"
#import "HelpViewController.h"

@interface MainViewViewController ()
@property (strong, nonatomic) IBOutlet BNoteButton *topicsButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
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
@property (assign, nonatomic) int firstRunStep;


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
@synthesize footer = _footer;
@synthesize topicsButton = _topicsButton;
@synthesize searchTopic = _searchTopic;
@synthesize topicGroup = _topicGroup;
@synthesize searchBar = _searchBar;
@synthesize liteLable = _liteLable;
@synthesize firstRunStep = _firstRunStep;

static NSString *emailTopicText;
static NSString *exportText;
static NSString *notesText;
static NSString *peopleText;
static NSString *contactUs;

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
    
    self.searchBar.placeholder = NSLocalizedString(@"Search All Topics", @"Search all topics.");
    self.notesLabel.text = NSLocalizedString(@"Notes", @"The notes section title.");
    self.peopleLabel.text = NSLocalizedString(@"People", @"The attendees section title.");
    
    emailTopicText = NSLocalizedString(@"Email Selected Topic", nil);
    exportText = NSLocalizedString(@"Archive Options", nil);
    notesText = NSLocalizedString(@"Notes", nil);
    peopleText = NSLocalizedString(@"People", nil);
    
    contactUs = NSLocalizedString(@"Contact Us", nil);

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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
    
    self.notesLabel.text = notesText;
    self.peopleLabel.text = peopleText;

    [[self detailView] setHidden:YES];
    [[self detailView] setBackgroundColor:[BNoteConstants appColor1]];
    
    self.topicsTable.listener = self;

    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(selectedNote:) name:kNoteSelected object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(presentTopicManagement:) name:kTopicGroupManage object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateReceived:)
                                                 name:kRefetchAllDatabaseData
                                               object:nil];
    

#ifdef LITE
    [[self liteLable] setFont:[BNoteConstants font:RobotoBold andSize:20]];
    [[self liteLable] setTextColor:[BNoteConstants appHighlightColor1]];
#else
    [[self liteLable] setHidden:YES];
#endif

}

- (void)updateReceived:(NSNotification *)notification
{
    [[BNoteWriter instance] cleanup];
    
    NSString *groupName = [BNoteSessionData stringForKey:kTopicGroupSelected];
    if (!groupName) {
        groupName = kAllTopicGroupName;
        [BNoteSessionData setString:groupName forKey:kTopicGroupSelected];
    }
    
    TopicGroup *group = [[BNoteReader instance] getTopicGroup:groupName];
    
    if (!group) {
        group = [BNoteFactory createTopicGroup:groupName];
    }
    
    [self selectTopicGroup:group];
}


- (void)selectedTopic:(Topic *)topic
{
    if ([[self detailView] isHidden]) {
        [[self detailView] setHidden:NO];
    }
    
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
    [self presentViewController:noteController animated:YES completion:^{}];
    [BNoteSessionData instance].mainViewController = noteController;

    [noteController setNote:note];
}

- (void)updateNoteCount:(NSNotification *)notification
{
    Topic *topic = [notification object];
    [self setNoteCountForTopic:topic];
}

- (void)setNoteCountForTopic:(Topic *)topic
{
    int count = [[topic notes] count] + [[topic associatedNotes] count];
    
    NSString *s = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:count] numberStyle:NSNumberFormatterNoStyle];
    [[self countLabel] setText:s];
}

- (IBAction)about:(id)sender
{
    BNoteLiteViewController *controller = [[BNoteLiteViewController alloc] initWithDefault];
    controller.topicGroupSelector = self;
    controller.firstLoad = NO;
    
    [controller setModalPresentationStyle:UIModalPresentationFormSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];

    [self presentViewController:controller animated:YES completion:^{}];
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
        [actionSheet addButtonWithTitle:contactUs];
        [actionSheet addButtonWithTitle:kUobia];

        UIView *view = self.shareButton;
        CGRect rect = view.bounds;
        [actionSheet showFromRect:rect inView:view animated:NO];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0) {
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([title isEqualToString:emailTopicText]) {
            [self presentEmailer];
        } else if ([title isEqualToString:exportText]) {
            BNoteExporterViewController *controller = [[BNoteExporterViewController alloc] initWithDefault];
            [controller setModalPresentationStyle:UIModalPresentationFormSheet];
            [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            controller.delegate = self;

            [self presentViewController:controller animated:YES completion:^{}];
        } else if ([title isEqualToString:contactUs]) {
            ContactMailController *controller = [[ContactMailController alloc] init];
            [controller setModalInPopover:YES];
            [controller setModalPresentationStyle:UIModalPresentationPageSheet];
            [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];

            [self presentViewController:controller animated:YES completion:^{}];
        } else if ([title isEqualToString:kUobia]) {
            NSURL *url = [NSURL URLWithString:kUobiaHomePage];
            [[UIApplication sharedApplication] openURL:url];
        }
    }

    [BNoteSessionData instance].actionSheet = nil;
}

- (void)presentEmailer
{
    EmailViewController *controller = [[EmailViewController alloc] initWithTopic:[[self entriesTable] topic]];
    [controller setModalPresentationStyle:UIModalPresentationPageSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];

    [self presentViewController:controller animated:YES completion:^{}];
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
    controller.delegate = self;
    
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
    [[BNoteSessionData instance] setPopup:popup];
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
    
    [controller setModalPresentationStyle:UIModalPresentationFormSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    controller.delegate = self;
    
    [self presentViewController:controller animated:YES completion:^{
        controller.currentTopicGroup = self.topicGroup;
    }];
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

- (void)selectTopicGroup:(TopicGroup *)topicGroup
{
    if ([self searchTopic]) {
        [[BNoteWriter instance] removeTopic:[self searchTopic]];
        [self setSearchTopic:nil];
    }
    
    [[self searchBar] setText:nil];
    
    [self setTopicGroup:topicGroup];
    
    if (topicGroup.topics.count) {
        self.detailView.hidden = NO;
    } else {
        self.detailView.hidden = YES;
    }
    
    [self.topicsButton updateTitle:[BNoteEntryUtils topicGroupName:topicGroup]];
    [self.topicsTable selectTopicGroup:topicGroup];
    
    [BNoteSessionData instance].selectedTopicGroup = topicGroup;
    [BNoteSessionData setString:[topicGroup name] forKey:kTopicGroupSelected];
}

- (void)presentImportController:(NSURL *)url
{
    [[BNoteUnarshallingManager instance] delegate:nil unmarshallUrl:url];
}

- (void)showHelp
{
    if (![BNoteSessionData booleanForKey:kFirstMainView]) {
        [self popoverControllerDidDismissPopover:nil];
        [BNoteSessionData setBoolean:YES forKey:kFirstMainView];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    HelpViewController *controller;
    UIView *view;

    switch (self.firstRunStep) {
        case 0:
            controller = [[HelpViewController alloc] initWithKey:kFirstMainView];
            view = self.topicsTable.addTopicButton;
            break;
        case 1:
            controller = [[HelpViewController alloc] initWithKey:kFirstMainViewStep2];
            view = self.topicsTable.editButton;
            break;
        case 2:
            controller = [[HelpViewController alloc] initWithKey:kFirstMainViewStep3];
            view = self.topicsButton;
            break;
        case 3:
            controller = [[HelpViewController alloc] initWithKey:kFirstMainViewStep4];
            view = self.shareButton;
            break;
        default:
            return;
    }

    self.firstRunStep++;

    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
    [[BNoteSessionData instance] setPopup:popup];
    popup.delegate = self;

    CGRect rect = [view bounds];

    [popup setPopoverContentSize:CGSizeMake(300, 50)];
    [popup presentPopoverFromRect:rect inView:view
         permittedArrowDirections:UIPopoverArrowDirectionAny
                         animated:NO];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
