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

@interface EntriesViewController ()
@property (strong, nonatomic) NSMutableArray *filteredControllers;
@property (strong, nonatomic) UITextView *textView;

@end

@implementation EntriesViewController
@synthesize note = _note;
@synthesize filter = _filter;
@synthesize filteredControllers = _filteredControllers;
@synthesize parentController = _parentController;
@synthesize textView = _textView;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startedEditing:)
                                                     name:UITextViewTextDidBeginEditingNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stoppedEditingText:)
                                                     name:UITextViewTextDidEndEditingNotification object:nil];        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setFilteredControllers:[[NSMutableArray alloc] init]];
    [self setFilter:[[BNoteFilterFactory instance] create:ItdentityType]];

    [[self view] setBackgroundColor:[BNoteConstants appColor1]];
     
    UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"Add Key Word" action:@selector(addQuickWord:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:menuItem, nil]];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setNote:nil];
    [self setFilter:nil];
    [self setFilteredControllers:nil];
    [self setParentController:nil];
    [self setTextView:nil];
}

- (void)setFilter:(id<BNoteFilter>)filter
{
    _filter = filter;
    [self reload];
}

- (void)setNote:(Note *)note
{
    _note = note;
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
    [controller setParentController:[self parentController]];

    return [controller cell];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([BNoteEntryUtils noteContainsAttendants:[self note]]) {
        return [indexPath row] > 0;
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
        
        Entry *entry = [controller entry];
        BOOL isAttendants = [entry isKindOfClass:[Attendants class]];

        [[BNoteWriter instance] removeEntry:entry];
        if (isAttendants) {
            [[NSNotificationCenter defaultCenter] postNotificationName:AttendantsEntryDeleted object:nil];
        }
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if ([[BNoteEntryUtils attendants:[self note]] count]) {
        if ([proposedDestinationIndexPath row] == 0) {
            return [NSIndexPath indexPathForRow:1 inSection:0];
        }
    }
    
    return proposedDestinationIndexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<EntryContent> controller = [[self filteredControllers] objectAtIndex:[indexPath row]]; 
    
    return [controller height];
}

- (void)reload
{
    [[self filteredControllers] removeAllObjects];
    for (Entry *entry in [[self note] entries]) {
        if ([[self filter] accept:entry]) {
            if (![entry isKindOfClass:[Attendants class]]) {
                id<EntryContent> controller = [BNoteFactory createEntryContent:entry];
                [[self filteredControllers] addObject:controller];
            }
        }
    }
    
    NSArray *attendants = [BNoteEntryUtils attendants:[self note]];
    if (attendants && [attendants count] > 0) {
        id<EntryContent> controller = [BNoteFactory createEntryContent:[attendants objectAtIndex:0]];
        [[self filteredControllers] insertObject:controller atIndex:0];
    }
    
    [[self tableView] reloadData];
}

- (void)selectLastCell
{
    int index = [[self filteredControllers] count] - 1;
    id<EntryContent> controller = [[self filteredControllers] objectAtIndex:index];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [[self tableView] scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];

    [[controller mainTextView] becomeFirstResponder];
}

- (void)selectFirstCell
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [[self tableView] scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)selectEntry:(Entry *)entry
{
    for (id<EntryContent> controller in [self filteredControllers]) {
        if ([controller entry] == entry) {
            [[controller mainTextView] becomeFirstResponder];
            return;
        }
    }
}

- (void)addQuickWord:(id)sender
{
    UITextView *textView = [self textView];
    UITextRange *range = [textView selectedTextRange];
    NSString *keyWord = [textView textInRange:range];
    
    [BNoteFactory createKeyWord:keyWord];
    [[NSNotificationCenter defaultCenter] postNotificationName:KeyWordsUpdated object:nil];
}

- (void)startedEditing:(NSNotification *)notification
{
    [self setTextView:[notification object]];
}

- (void)stoppedEditingText:(NSNotification *)notification
{
    [self reload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)resignControll
{
    [[self textView] resignFirstResponder];
}


@end
