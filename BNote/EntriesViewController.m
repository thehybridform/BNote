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
#import "EntryTableViewCell.h"
#import "Entry.h"
#import "BNoteWriter.h"
#import "BNoteSessionData.h"

@interface EntriesViewController ()
@property (assign, nonatomic) EntryTableViewCell *selectedCell;
@property (strong, nonatomic) QuickWordsViewController *quickWordsViewController;
@property (strong, nonatomic) NSMutableArray *filteredEntries;
@end

@implementation EntriesViewController
@synthesize note = _note;
@synthesize entryCell = _entryCell;
@synthesize selectedCell = _selectedCell;
@synthesize quickWordsViewController = _quickWordsViewController;
@synthesize filter = _filter;
@synthesize filteredEntries = _filteredEntries;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification object:[[self view] window]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setNote:nil];
    [self setEntryCell:nil];
    [self setSelectedCell:nil];
    [self setQuickWordsViewController:nil];
    [self setFilter:nil];
    [self setFilteredEntries:nil];
}

- (void)setNote:(Note *)note
{
    if (_note != note) {
        _note = note;

        [self setFilter:nil];
        [self setFilteredEntries:[[[self note] entries] mutableCopy]];
    }
}

- (void)setFilter:(Class)filter
{
    if (filter != _filter) {
        _filter = filter;
        
        if (filter) {
            [self setFilteredEntries:[[NSMutableArray alloc] init]];
            NSEnumerator *items = [[[self note] entries] objectEnumerator];
            Entry *entry;
            while (entry = [items nextObject]) {
                if ([entry isKindOfClass:filter]) {
                    [[self filteredEntries] addObject:entry];
                }
            }
        } else {
            [self setFilteredEntries:[[[self note] entries] mutableCopy]];
        }
        
        [[self tableView] reloadData];
    }
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
    static NSString *cellIdentifier = @"EntryTableViewCell";
    EntryTableViewCell *cell;// = (EntryTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil) {
        cell = [[EntryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setEditingAccessoryType:UITableViewCellAccessoryNone];

        Entry *entry = [[self filteredEntries] objectAtIndex:[indexPath row]]; 
        [cell setEntry:entry];
        
        [LayerFormater roundCornersForView:cell];
//    }
    
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
        [[BNoteWriter instance] removeEntry:entry];

        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Entry *entry = [[self filteredEntries] objectAtIndex:[indexPath row]];
    int lineCount = [BNoteStringUtils lineCount:[entry text]];
    
    if (lineCount > 1) {
        return lineCount * 25;
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self filter] == nil) {
        BOOL shouldReload = [self clearSelectedCell];
        if (shouldReload) {
            [[self tableView] reloadData];
        }
    
        EntryTableViewCell *cell = (EntryTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
        [self setSelectedCell:cell];
        [cell edit];
    
        [self showQuickView:cell];
    }
}

- (BOOL)clearSelectedCell
{
    BOOL hadCell = NO;
    EntryTableViewCell *selectedCell = [self selectedCell];
    if (selectedCell) {
        [selectedCell finishedEdit];
        hadCell = YES;
    }
    
    [self setSelectedCell:nil];
    return hadCell;
}

- (void)showQuickView:(EntryTableViewCell *)cell
{
    QuickWordsViewController *currentQuick = [self quickWordsViewController];
    
    QuickWordsViewController *quick = [[QuickWordsViewController alloc] initWithEntry:[cell entry]];
    [self setQuickWordsViewController:quick];
    [quick setListener:self];
    
    [quick setTargetTextView:[cell textView]];
    
    float x = 0;
    float width = [[quick view] bounds].size.width;
    float height = [[quick view] bounds].size.height;
    float y = 150 - height + 50;
    [[quick view] setFrame:CGRectMake(x, y, width, height)];
    [[[self view] superview] addSubview:[quick view]];
    
    if (currentQuick) {
        [[currentQuick view] removeFromSuperview];
        [[[self view] superview] addSubview:[quick view]];
    } else {
        [quick presentView:[[self view] superview]];
    }
}

- (void)keyboardDidHide:(id)sender
{
    [self clearModalViews];
}

- (void)didFinishFromQuickWords
{
    [self clearModalViews];
}

- (void)clearModalViews
{
    [[self quickWordsViewController] hideView];
    [self setQuickWordsViewController:nil];
    [self clearSelectedCell];
    [[self tableView] reloadData];
}

- (void)reload
{
    [[self tableView] reloadData];
}

- (void)selectLastCell
{
    [self tableView:[self tableView] didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:([[[self note] entries] count] - 1) inSection:0]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
