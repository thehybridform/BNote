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
#import "EntryTableCellBasis.h"
#import "Entry.h"
#import "BNoteWriter.h"
#import "BNoteSessionData.h"
#import "BNoteFactory.h"
#import "Attendant.h"
#import "BNoteEntryUtils.h"

@interface EntriesViewController ()
@property (assign, nonatomic) EntryTableCellBasis *selectEntryCell;
@property (strong, nonatomic) NSMutableArray *filteredEntries;
@property (strong, nonatomic) NSMutableArray *deletedEntries;
@property (assign, nonatomic) UITextView *textView;

@end

@implementation EntriesViewController
@synthesize note = _note;
@synthesize entryCell = _entryCell;
@synthesize filter = _filter;
@synthesize filteredEntries = _filteredEntries;
@synthesize parentController = _parentController;
@synthesize deletedEntries = _deletedEntries;
@synthesize textView = _textView;
@synthesize selectEntryCell = _selectEntryCell;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setFilteredEntries:[[NSMutableArray alloc] init]];

    [[self view] setBackgroundColor:[BNoteConstants appColor1]];
     
    UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"Add Key Word" action:@selector(addQuickWord:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:menuItem, nil]];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startedEditing:)
                                                 name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedEditing:)
                                                 name:UITextViewTextDidEndEditingNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setNote:nil];
    [self setEntryCell:nil];
    [self setFilter:nil];
    [self setFilteredEntries:nil];
    [self setParentController:nil];
    [self setDeletedEntries:nil];
}

- (void)setFilter:(id<BNoteFilter>)filter
{
    _filter = filter;
    [self reload];
}

- (void)setNote:(Note *)note
{
    _note = note;
    [self setFilter:[BNoteFilterFactory create:ItdentityType]];
    [self setDeletedEntries:[[NSMutableArray alloc] init]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self filteredEntries] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"EntryTableCellBasis";
    
    Entry *entry = [[self filteredEntries] objectAtIndex:[indexPath row]]; 

    EntryTableCellBasis * cell = [BNoteFactory createEntryTableViewCellForEntry:entry andCellIdentifier:cellIdentifier];
    [LayerFormater setBorderWidth:1 forView:cell];
    
    [cell setEntry:entry];
    [cell setParentController:self];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Entry *entry = [[self filteredEntries] objectAtIndex:[indexPath row]]; 

        [[self deletedEntries] addObject:entry];
        [[self filteredEntries] removeObject:entry];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                         withRowAnimation:UITableViewRowAnimationFade];
        
        [[self filteredEntries] removeObject:entry];
        [[self deletedEntries] addObject:entry];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Entry *entry = [[self filteredEntries] objectAtIndex:[indexPath row]];
    return [self heightForEntry:entry];
}

- (CGFloat)heightForEntry:(Entry *)entry
{
    return MAX(100, [BNoteEntryUtils cellHeight:entry inView:[self tableView]]);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[BNoteSessionData instance] canEditEntry]) {
        EntryTableCellBasis *cell = (EntryTableCellBasis *) [tableView cellForRowAtIndexPath:indexPath];
    
        EntryTableCellBasis *selectEntryCell = [self selectEntryCell];
        if (selectEntryCell) {
            [selectEntryCell unfocus];
        }
        
        [self setSelectEntryCell:cell];
        
        [cell focus];
    }
}

- (void)reload
{
    [[self filteredEntries] removeAllObjects];
    NSEnumerator *entries = [[[self note] entries] objectEnumerator];
    Entry *entry;
    while (entry = [entries nextObject]) {
        if (![[self deletedEntries] containsObject:entry]) {
            if ([[self filter] accept:entry]) {
                if (![entry isKindOfClass:[Attendants class]]) {
                    [[self filteredEntries] addObject:entry];
                }
            }
        }
    }
    
    NSArray *attendants = [BNoteEntryUtils attendants:[self note]];
    
    NSRange range = NSMakeRange(0, [attendants count]);
    NSIndexSet *indexes = [[NSIndexSet alloc] initWithIndexesInRange:range];
    [[self filteredEntries] insertObjects:attendants atIndexes:indexes];
    
    [[self tableView] reloadData];
}

- (void)selectLastCell
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([[self filteredEntries] count] - 1) inSection:0];
    [[self tableView] scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [self tableView:[self tableView] didSelectRowAtIndexPath:indexPath];
}

- (void)selectEntry:(Entry *)entry
{
    int index = [[self filteredEntries] indexOfObject:entry];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [[self tableView] scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [self tableView:[self tableView] didSelectRowAtIndexPath:indexPath];
}

- (UIViewController *)controller
{
    return self;
}

- (void)cleanupEntries
{
    NSEnumerator *entries = [[self deletedEntries] objectEnumerator];
    Entry *entry;
    while (entry = [entries nextObject]) {
        [[BNoteWriter instance] removeEntry:entry];
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

- (void)startedEditing:(id)sender
{
    NSNotification *notification = sender;
    [self setTextView:[notification object]];
}

- (void)finishedEditing:(id)sender
{
    [self setTextView:nil];
}

- (void)keyboardWillHide:(id)sender
{
    [self setSelectEntryCell:nil];
    [[self tableView] reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
//    [[self tableView] reloadData];
}

@end
