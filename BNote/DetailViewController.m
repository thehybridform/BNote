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
#import "NoteViewController.h"
#import "Entry.h"
#import "EntrySummariesTableViewController.h"
#import "NoteViewController.h"
#import "NoteEditorViewController.h"
#import "BNoteSessionData.h"
#import "LayerFormater.h"

@class Note;

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) EntrySummariesTableViewController *tableViewController;

@end

@implementation DetailViewController

@synthesize topic = _topic;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize entrySummariesView = _entrySummariesView;
@synthesize addNewNoteButton = _addNewNoteButton;
@synthesize tableViewController = _tableViewController;
@synthesize notesViewController = notesViewController;

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setMasterPopoverController:nil];
    [self setTableViewController:nil];
    [self setTopic:nil];
    [self setMasterPopoverController:nil];
    [self setEntrySummariesView:nil];
    [self setAddNewNoteButton:nil];
    [self setNotesViewController:nil];
    
}
     
- (void)configureView:(int)indexPath
{
    [[[self tableViewController] view] removeFromSuperview];
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }

    [self setTitle:[[self topic] title]];
    if (indexPath > 0) {
        [[self view] setHidden:NO];
        [self addEntriesToView];
        [[self notesViewController] configureView:[self topic]];
        [[self notesViewController] setListener:self];
    } else {
        [[self view] setHidden:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];        
}

- (void)didFinish
{
    [self addEntriesToView];
}

- (void)addEntriesToView
{
    [[[self tableViewController] tableView] removeFromSuperview];

    EntrySummariesTableViewController *controller =
        [[EntrySummariesTableViewController alloc] initWithTopic:[self topic]];
    [[self entrySummariesView] addSubview:[controller tableView]];
    [self setTableViewController:controller];
}

- (IBAction)createNewNote:(id)sender
{
    Note *note = [BNoteFactory createNote:[self topic]];
    [[self notesViewController] addNote:note];
}

#pragma mark - Split view

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



@end