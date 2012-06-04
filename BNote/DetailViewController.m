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
#import "HelpViewController.h"

@class Note;

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
}

- (void)setTopic:(Topic *)topic
{
    _topic = topic;
    
    [[self addNewNoteButton] setHidden:NO];
    [[[self tableViewController] view] setHidden:NO];
    [[[self notesViewController] view] setHidden:NO];
    [[self toolbar] setHidden:NO];

    [[self tableViewController] setTopic:topic];
    [[self notesViewController] configureView:[self topic]];
    [[self notesViewController] setListener:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];       
    
    if (![self topic]) {
        [[self addNewNoteButton] setHidden:YES];
        [[[self tableViewController] view] setHidden:YES];
        [[[self notesViewController] view] setHidden:YES];
        [[self toolbar] setHidden:YES];
        
        HelpViewController *help = [[HelpViewController alloc] initWith:self];
        [help setModalPresentationStyle:UIModalPresentationFormSheet];
        [help setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentModalViewController:help animated:YES];
    }
    
    UIBarButtonItem *addButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(add:)];
    
//    self.navigationItem.rightBarButtonItem = addButton;

}

- (void)didFinish
{
    [self setTopic:[self topic]];
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

- (void)dismissHelp:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end