//
//  DetailViewController.m
//  BNote
//
//  Created by Young Kristin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "BNoteFactory.h"
#import "BNoteWriter.h"
#import "Entry.h"
#import "Note.h"
#import "EntrySummariesTableViewController.h"
#import "NoteEditorViewController.h"
#import "BNoteSessionData.h"
#import "LayerFormater.h"
#import "EmailViewController.h"
#import "InformationViewController.h"
#import "EditNoteViewPresenter.h"


@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) IBOutlet UIButton *addNewNoteButton;
@property (strong, nonatomic) IBOutlet EntrySummariesTableViewController *tableViewController;
@property (strong, nonatomic) IBOutlet NotesViewController *notesViewController;
@property (strong, nonatomic) IBOutlet UIToolbar *entriesToolbar;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIView *noteCountView;
@property (strong, nonatomic) IBOutlet UILabel *noteCountLabel;
@property (strong, nonatomic) InformationViewController *informationViewController;

@end

@implementation DetailViewController

@synthesize topic = _topic;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize addNewNoteButton = _addNewNoteButton;
@synthesize tableViewController = _tableViewController;
@synthesize notesViewController = notesViewController;
@synthesize entriesToolbar = _entriesToolbar;
@synthesize navBar = _navBar;
@synthesize informationViewController = _informationViewController;
@synthesize searchBar = _searchBar;
@synthesize noteCountView = _noteCountView;
@synthesize noteCountLabel = _noteCountLabel;

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setMasterPopoverController:nil];
    [self setTableViewController:nil];
    [self setTopic:nil];
    [self setMasterPopoverController:nil];
    [self setAddNewNoteButton:nil];
    [self setNotesViewController:nil];
    [self setEntriesToolbar:nil];
    [self setInformationViewController:nil];
    [self setNoteCountView:nil];
    [self setNoteCountLabel:nil];
}

- (void)setTopic:(Topic *)topic
{
    _topic = topic;
    
    [[self tableViewController] setTopic:[self topic]];
    [[self notesViewController] setTopic:[self topic]];
    
    [self reload:nil];
}

- (void)reload:(id)sender
{
    [[BNoteWriter instance] update];

    [[self addNewNoteButton] setHidden:NO];
    [[[self tableViewController] view] setHidden:NO];
    [[[self notesViewController] view] setHidden:NO];
    [[self entriesToolbar] setHidden:NO];

    [[self tableViewController] reload];
    [[self notesViewController] reload];
    
    int count = [[[self topic] notes] count] + [[[self topic] associatedNotes] count];
    NSString *s = [NSString stringWithFormat:@"%d", count];
    [[self noteCountLabel] setText:s];
}

- (void)viewDidLoad
{
    [super viewDidLoad];       
    
    [[self view] setBackgroundColor:[BNoteConstants appColor1]];
    
    if (![self topic]) {
        [[self addNewNoteButton] setHidden:YES];
        [[[self tableViewController] view] setHidden:YES];
        [[[self notesViewController] view] setHidden:YES];
        [[self entriesToolbar] setHidden:YES];
        
        [[self tableViewController] setDetailViewController:self];
        [[self notesViewController] setDetailViewController:self];
    }
    
    [LayerFormater roundCornersForView:[self noteCountView]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:)
                                                 name:TopicUpdated object:nil];
    
}

- (IBAction)createNewNote:(id)sender
{
    Note *note = [BNoteFactory createNote:[self topic]];
    [[self notesViewController] reload];
    
    [EditNoteViewPresenter presentNote:note in:self];
}

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Topics", @"Topics");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)sendEmail:(id)sender
{
    EmailViewController *controller = [[EmailViewController alloc] initWithTopic:[self topic]];
    [controller setModalPresentationStyle:UIModalPresentationPageSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self presentModalViewController:controller animated:YES];
}

- (IBAction)help:(id)sender
{
    
}

- (IBAction)configure:(id)sender
{
    InformationViewController *controller = [[InformationViewController alloc] initWithDefault];
    [controller setModalPresentationStyle:UIModalPresentationFullScreen];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self presentModalViewController:controller animated:YES];
}

@end