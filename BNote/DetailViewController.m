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

@class Note;

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) NSMutableArray *noteViewControllers;
@property (strong, nonatomic) EntrySummariesTableViewController *tableViewController;

@end

@implementation DetailViewController

@synthesize topic = _topic;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize notesScrollView = _notesScrollView;
@synthesize entrySummariesView = _entrySummariesView;
@synthesize defaultNoteButton = _defaultNoteButton;
@synthesize noteViewControllers = _noteViewControllers;
@synthesize tableViewController = _tableViewController;

#pragma mark - Managing the detail item

- (void)configureView
{
    NSEnumerator *notes = [[self noteViewControllers] objectEnumerator];
    NoteViewController *note;
    while (note = [notes nextObject]) {
        [[note view] removeFromSuperview]; 
    }
    
    [[[self tableViewController] view] removeFromSuperview];
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }

    [self setTitle:[[self topic] title]];
    [self addNotesToView];
    [self addEntriesToView];
    
    float height = [[self notesScrollView] contentSize].height;
    [[self notesScrollView] setContentSize:CGSizeMake([[[self topic] notes] count] * 155, height)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];        
    [self configureView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setNoteViewControllers:[[NSMutableArray alloc] init]];
    }
    return self;
}

- (void)addNotesToView
{
    NSEnumerator *notes = [[[self topic] notes] objectEnumerator];
    Note *note;
    while (note = [notes nextObject]) {
        [self addNoteToView:note];
    }
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
    [BNoteFactory createNote:[self topic]];
    [self configureView];
}

- (void)addNoteToView:(Note *)note
{
    NoteViewController *controller = [[NoteViewController alloc] initWithNote:note andDelegate:self];
    
    [[self notesScrollView] addSubview:[controller view]];
    [[self noteViewControllers] addObject:controller];
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

#pragma mark NoteViewControllerDelegate

- (void)noteDeleted:(NoteViewController *)controller
{
    [self configureView];
}

- (void)noteUpdated:(NoteViewController *)controller
{
    [self configureView];
}

@end