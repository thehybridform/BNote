//
//  EntriesViewController.m
//  BNote
//
//  Created by Young Kristin on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntriesViewController.h"
#import "LayerFormater.h"
#import "BNoteStringUtils.h"
#import "EntryContent.h"
#import "Entry.h"
#import "BNoteWriter.h"
#import "BNoteSessionData.h"
#import "BNoteFactory.h"
#import "Attendant.h"
#import "KeyPoint.h"
#import "BNoteEntryUtils.h"
#import "QuickWordsViewController.h"
#import "BNoteQuickWordUtils.h"
#import "AttendantsContentViewController.h"
#import "NoteSummaryViewController.h"
#import "BNoteAnimation.h"

@interface EntriesViewController ()
@property (strong, nonatomic) NSMutableArray *filteredControllers;
@property (strong, nonatomic) UITextView *textView;
@property (assign, nonatomic) BOOL showSummary;

@end

@implementation EntriesViewController
@synthesize note = _note;
@synthesize filter = _filter;
@synthesize filteredControllers = _filteredControllers;
@synthesize textView = _textView;
@synthesize showSummary = _showSummary;

static NSString *addKeyWordText;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {

    }

    addKeyWordText = NSLocalizedString(@"Add Key Word", @"Add key word menu item");

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setFilteredControllers:[[NSMutableArray alloc] init]];

    [[self view] setBackgroundColor:[BNoteConstants appColor1]];
     
    UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:addKeyWordText action:@selector(addQuickWord:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:menuItem, nil]];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startedEditing:)
                                                 name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stoppedEditingText:)
                                                 name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noteUpdated:)
                                                 name:kNoteUpdated object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setFilter:(id<BNoteFilter>)filter
{
    _filter = filter;
    [self reload];
}

- (void)setNote:(Note *)note
{
    _note = note;
    
    [self setShowSummary:![BNoteStringUtils nilOrEmpty:[note summary]]];
    [self setFilter:[[BNoteFilterFactory instance] create:ItdentityType]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self filteredControllers] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<EntryContent> controller = [[self filteredControllers] objectAtIndex:[indexPath row]];
    
    [BNoteAnimation winkInView:[controller iconView] withDuration:0.2 andDelay:0.5];

    return [controller cell];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<EntryContent> controller = [[self filteredControllers] objectAtIndex:[indexPath row]];
    
    if ([controller isKindOfClass:[AttendantsContentViewController class]]) {
        return NO;
    }
    
    if ([controller isKindOfClass:[NoteSummaryViewController class]]) {
        return NO;
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    id<EntryContent> sourceController = [[self filteredControllers] objectAtIndex:[sourceIndexPath row]]; 
   
    Entry *entry = [sourceController entry];
    [[BNoteWriter instance] moveEntry:entry toIndex:[destinationIndexPath row]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [[NSNotificationCenter defaultCenter] removeObserver:cell];
        
        id<EntryContent> controller = [[self filteredControllers] objectAtIndex:[indexPath row]]; 

        [[self filteredControllers] removeObject:controller];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                         withRowAnimation:UITableViewRowAnimationFade];
        

        if ([controller isKindOfClass:[NoteSummaryViewController class]]) {
            [[self note] setSummary:nil];
        } else {
            Entry *entry = [controller entry];
            BOOL isAttendants = [entry isKindOfClass:[Attendants class]];

            [[BNoteWriter instance] removeEntry:entry];
            if (isAttendants) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kAttendantsEntryDeleted object:nil];
            }
        }
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    id<EntryContent> controller = [[self filteredControllers] objectAtIndex:[proposedDestinationIndexPath row]];
    
    if ([controller isKindOfClass:[AttendantsContentViewController class]]) {
        return sourceIndexPath;
    }
    
    if ([controller isKindOfClass:[NoteSummaryViewController class]]) {
        return sourceIndexPath;
    }

    return proposedDestinationIndexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<EntryContent> controller = [[self filteredControllers] objectAtIndex:[indexPath row]]; 
    
    return [controller height];
}

- (void)noteUpdated:(NSNotification *)notificaiton
{
    [self reload];
}

- (void)reload
{
    for (id<EntryContent> ec in self.filteredControllers) {
        [ec detatchFromNotificationCenter];
    }
    
    [[self filteredControllers] removeAllObjects];
    
    for (Entry *entry in [[self note] entries]) {
        if ([[self filter] accept:entry]) {
            if (![entry isKindOfClass:[Attendants class]]) {
                EntryContentViewController *controller = [BNoteFactory createEntryContent:entry];
                [[self filteredControllers] addObject:controller];
            }
        }
    }
    
    NSArray *attendants = [BNoteEntryUtils attendants:[self note]];
    if (attendants && [attendants count] > 0) {
        id<EntryContent> controller = [BNoteFactory createEntryContent:[attendants objectAtIndex:0]];
        [[self filteredControllers] insertObject:controller atIndex:0];
    }
    
    if ([self showSummary]) {
        id<EntryContent> controller = [BNoteFactory createSummaryEntry:[self note]];
        [[self filteredControllers] addObject:controller];
    }
    
    [[self tableView] reloadData];
}

- (void)selectSummaryCell
{
    if ([self showingSummary]) {
        [self selectEntryCell:[[self filteredControllers] count] - 1];
    }
}

- (void)addAndSelectLastEntry:(Entry *)entry
{
    int index;
    if ([self showingSummary]) {
        index = [self.filteredControllers count] - 1;
    } else {
        index = [self.filteredControllers count];
    }
    
    EntryContentViewController *controller = [BNoteFactory createEntryContent:entry];
    [self.filteredControllers insertObject:controller atIndex:index];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [[self tableView] scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    [controller.mainTextView becomeFirstResponder];
}

- (void)selectFirstCell
{
    [self selectEntryCell:0];
}

- (void)selectEntryCell:(int)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [[self tableView] scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

    EntryContentViewController *controller = [[self filteredControllers] objectAtIndex:index];
    [controller.selectedTextView becomeFirstResponder];
}

- (void)selectEntry:(Entry *)entry
{
    for (id<EntryContent> controller in [self filteredControllers]) {
        if ([controller entry] == entry) {
            int index = [self.filteredControllers indexOfObject:controller];
            [self selectEntryCell:index];
            return;
        }
    }
}

- (void)addQuickWord:(id)sender
{
    NSString *word = [BNoteQuickWordUtils extractKeyWordFromTextView:[self textView]];
    
    if (word) {
        [BNoteFactory createKeyWord:word];
        [[NSNotificationCenter defaultCenter] postNotificationName:kKeyWordsUpdated object:nil];
    }
}

- (void)startedEditing:(NSNotification *)notification
{
    if ([[notification object] isKindOfClass:[UITextView class]]) {
        [self setTextView:[notification object]];
    }
}

- (void)stoppedEditingText:(NSNotification *)notification
{
    [self setTextView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)resignControll
{
    [[self textView] resignFirstResponder];
}

- (void)displaySummary
{
    [self setShowSummary:YES];
    [self reload];
}

- (BOOL)showingSummary
{
    id<EntryContent> controller = [[self filteredControllers] lastObject];
    return [controller isKindOfClass:[NoteSummaryViewController class]];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
