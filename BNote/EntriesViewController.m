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
#import "EntryCell.h"
#import "Entry.h"
#import "BNoteWriter.h"
#import "BNoteSessionData.h"
#import "BNoteFactory.h"
#import "Attendant.h"

@interface EntriesViewController ()
@property (assign, nonatomic) id<EntryCell> selectEntryCell;
@property (strong, nonatomic) QuickWordsViewController *quickWordsViewController;
@property (strong, nonatomic) NSMutableArray *filteredEntries;
@property (strong, nonatomic) NSMutableArray *deletedEntries;
@property (assign, nonatomic) UITextView *textView;

@end

@implementation EntriesViewController
@synthesize note = _note;
@synthesize entryCell = _entryCell;
@synthesize quickWordsViewController = _quickWordsViewController;
@synthesize filter = _filter;
@synthesize filteredEntries = _filteredEntries;
@synthesize keepQuickViewAlive = _keepQuickViewAlive;
@synthesize parentController = _parentController;
@synthesize deletedEntries = _deletedEntries;
@synthesize textView = _textView;
@synthesize selectEntryCell = _selectEntryCell;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[self view] setBackgroundColor:[BNoteConstants appColor1]];
     
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification object:[[self view] window]];

    UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"Add Key Word" action:@selector(addQuickWord:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:menuItem, nil]];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startedEditing:)
                                                 name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedEditing:)
                                                 name:UITextViewTextDidEndEditingNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setNote:nil];
    [self setEntryCell:nil];
    [self setQuickWordsViewController:nil];
    [self setFilter:nil];
    [self setFilteredEntries:nil];
    [self setParentController:nil];
    [self setDeletedEntries:nil];
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
    static NSString *cellIdentifier = @"EntryTableViewCell";
    
    Entry *entry = [[self filteredEntries] objectAtIndex:[indexPath row]]; 

    id<EntryCell> cell = [BNoteFactory createEntryTableViewCellForEntry:entry andCellIdentifier:cellIdentifier];
    [cell setEntry:entry];
    [cell setParentController:self];
        
    [LayerFormater setBorderWidth:1 forView:[cell view]];
    
    return (UITableViewCell *) cell;
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
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Entry *entry = [[self filteredEntries] objectAtIndex:[indexPath row]];
    
    return [EntryTableViewCell cellHieght:entry];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[BNoteSessionData instance] canEditEntry]) {
        id<EntryCell> cell = (id<EntryCell>) [tableView cellForRowAtIndexPath:indexPath];
    
        [self setSelectEntryCell:cell];
        
        [cell focus];
    
//        [self showQuickView:cell];
    }
}

- (void)showQuickView:(EntryTableViewCell *)cell
{
    QuickWordsViewController *currentQuick = [self quickWordsViewController];
    
    QuickWordsViewController *quick = [[QuickWordsViewController alloc] initWithEntry:[cell entry]];
    [self setQuickWordsViewController:quick];
    [quick setListener:self];
    
    [quick setEntryViewCell:cell];
    
    float x = 0;
    float width = [[quick view] bounds].size.width;
    float height = [[quick view] bounds].size.height;
    float y = 205 - height + 50;
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
    if (![self keepQuickViewAlive]) {
        [self clearModalViews];
    }
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
                if (![[self deletedEntries] containsObject:entry]) {
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
    [[self tableView] scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
