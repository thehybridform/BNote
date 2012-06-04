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
#import "IdentityFillter.h"
#import "BNoteFactory.h"
#import "Attendant.h"

@interface EntriesViewController ()
@property (strong, nonatomic) EntryTableViewCell *selectEntryTableViewCell;
@property (strong, nonatomic) QuickWordsViewController *quickWordsViewController;
@property (strong, nonatomic) NSMutableArray *filteredEntries;
@end

@implementation EntriesViewController
@synthesize note = _note;
@synthesize entryCell = _entryCell;
@synthesize quickWordsViewController = _quickWordsViewController;
@synthesize filter = _filter;
@synthesize filteredEntries = _filteredEntries;
@synthesize selectEntryTableViewCell = _selectEntryTableViewCell;

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
    [self setQuickWordsViewController:nil];
    [self setFilter:nil];
    [self setFilteredEntries:nil];
    [self setSelectEntryTableViewCell:nil];
}

- (void)setFilter:(id<BNoteFilter>)filter
{
    if (filter != _filter) {
        _filter = filter;
        [self reload];
    }
}

- (void)setNote:(Note *)note
{
    _note = note;
    [self setFilter:[[IdentityFillter alloc] init]];
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
    
    Entry *entry = [[self filteredEntries] objectAtIndex:[indexPath row]]; 

    EntryTableViewCell *cell = [BNoteFactory createEntryTableViewCellForEntry:entry andCellIdentifier:cellIdentifier];
    [cell setEditingAccessoryType:UITableViewCellAccessoryNone];
    [cell setEntry:entry];
        
    [LayerFormater roundCornersForView:cell];
    
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

        [[self filteredEntries] removeObject:entry];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Entry *entry = [[self filteredEntries] objectAtIndex:[indexPath row]];
    int lineCount = [BNoteStringUtils lineCount:[entry text]];
    
    return MAX(4, lineCount) * 25;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[BNoteSessionData instance] canEditEntry]) {
        EntryTableViewCell *cell = (EntryTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    
        EntryTableViewCell *selectedCell = [self selectEntryTableViewCell];
        if (selectedCell) {
            [selectedCell finishedEdit];
        }
        
        [self setSelectEntryTableViewCell:cell];
        
        [cell edit];
    
        [self showQuickView:cell];
    }
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
        [quick presentView:self];
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
    [self reload];
}

- (void)reload
{
    [self setFilteredEntries:[[NSMutableArray alloc] init]];
    NSEnumerator *entries = [[[self note] entries] objectEnumerator];
    Entry *entry;
    while (entry = [entries nextObject]) {
        if ([[self filter] accept:entry]) {
            if (![entry isKindOfClass:[Attendant class]]) {
                [[self filteredEntries] addObject:entry];
            }
        }
    }
    
    [[self tableView] reloadData];
}

- (void)selectLastCell
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([[self filteredEntries] count] - 1) inSection:0];
    [[self tableView] scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    [self tableView:[self tableView] didSelectRowAtIndexPath:indexPath];
}

- (UIViewController *)controller
{
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
