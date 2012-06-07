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
#import "HelpViewController.h"


@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end

@implementation DetailViewController

@synthesize topic = _topic;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize addNewNoteButton = _addNewNoteButton;
@synthesize tableViewController = _tableViewController;
@synthesize notesViewController = notesViewController;
@synthesize toolbar = _toolbar;

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setMasterPopoverController:nil];
    [self setTableViewController:nil];
    [self setTopic:nil];
    [self setMasterPopoverController:nil];
    [self setAddNewNoteButton:nil];
    [self setNotesViewController:nil];
    [self setToolbar:nil];
}

- (void)setTopic:(Topic *)topic
{
    _topic = topic;
    
    [[self tableViewController] setTopic:[self topic]];
    [[self notesViewController] setTopic:[self topic]];

    [self reload];
}

- (void)reload
{
    [[BNoteWriter instance] update];

    [[self addNewNoteButton] setHidden:NO];
    [[[self tableViewController] view] setHidden:NO];
    [[[self notesViewController] view] setHidden:NO];
    [[self toolbar] setHidden:NO];

    [[self tableViewController] reload];
    [[self notesViewController] reload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];       
    
    [[self notesViewController] setParentController:self];
    [[self view] setBackgroundColor:[BNoteConstants appColor1]];
    
    if (![self topic]) {
        [[self addNewNoteButton] setHidden:YES];
        [[[self tableViewController] view] setHidden:YES];
        [[[self notesViewController] view] setHidden:YES];
        [[self toolbar] setHidden:YES];
    }
}

- (IBAction)createNewNote:(id)sender
{
    Note *note = [BNoteFactory createNote:[self topic]];
    [[self notesViewController] reload];
    
    NoteEditorViewController *controller = [[NoteEditorViewController alloc] initWithNote:note];
    [controller setDelegate:(id<NoteEditorViewControllerDelegate>) [self notesViewController]];
    [controller setModalPresentationStyle:UIModalPresentationPageSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentModalViewController:controller animated:YES];
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

- (void)dismissHelp:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end