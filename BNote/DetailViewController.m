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
@property (strong, nonatomic) NSMutableArray *noteViewControllers;
@property (strong, nonatomic) EntrySummariesTableViewController *tableViewController;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@end

@implementation DetailViewController

@synthesize topic = _topic;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize notesScrollView = _notesScrollView;
@synthesize entrySummariesView = _entrySummariesView;
@synthesize defaultNoteButton = _defaultNoteButton;
@synthesize noteViewControllers = _noteViewControllers;
@synthesize tableViewController = _tableViewController;
@synthesize actionSheet = _actionSheet;


- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setMasterPopoverController:nil];
    [self setNoteViewControllers:nil];
    [self setTableViewController:nil];
    [self setTopic:nil];
    [self setMasterPopoverController:nil];
    [self setNotesScrollView:nil];
    [self setEntrySummariesView:nil];
    [self setDefaultNoteButton:nil];
    [self setNoteViewControllers:nil];
    [self setActionSheet:nil];
}
     
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setNoteViewControllers:[[NSMutableArray alloc] init]];
    }
    return self;
}


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
    NoteViewController *controller = [[NoteViewController alloc] initWithNote:note];
    
    [controller setNoteViewControllerDelegate:self];
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
}

- (void)noteUpdated:(NoteViewController *)controller
{

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)presentActionSheetForController:(CGRect)rect
{
    NoteViewController *controller = [[BNoteSessionData instance] currentNoteViewController];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    [actionSheet setDelegate:self];
    [actionSheet addButtonWithTitle:@"Delete Note"];
    [actionSheet addButtonWithTitle:@"Cancel"];
    
    [actionSheet showFromRect:rect inView:[controller view] animated:YES];
    
    [LayerFormater setBorderWidth:5 forView:[controller view]];
    [LayerFormater setBorderColor:[UIColor redColor] forView:[controller view]];
}

#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NoteViewController *controller = [[BNoteSessionData instance] currentNoteViewController];
    UIView *view = [controller view];
    
    switch (buttonIndex) {
        case 0:
            [view removeFromSuperview];
            [[BNoteWriter instance] removeNote:[controller note]];
            [[self noteViewControllers] removeObject:controller];
            [self updateNoteScrollView];
            break;
        case 1:
            [LayerFormater setBorderWidth:1 forView:view];
            [LayerFormater setBorderColor:[UIColor blackColor] forView:view];
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NoteViewController *controller = [[BNoteSessionData instance] currentNoteViewController];
    UIView *view = [controller view];
    [LayerFormater setBorderWidth:1 forView:view];
    [LayerFormater setBorderColor:[UIColor blackColor] forView:view];
    [self setActionSheet:nil];
}

- (void)updateNoteScrollView
{
    
}

@end