//
//  EntrySummariesTableViewController.m
//  BNote
//
//  Created by Young Kristin on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntrySummariesTableViewController.h"
#import "Note.h"
#import "Entry.h"
#import "BNoteFactory.h"
#import "LayerFormater.h"
#import "NoteEditorViewController.h"
#import "EntrySummaryTableViewCell.h"
#import "EditNoteViewPresenter.h"

@interface EntrySummariesTableViewController ()
@property (strong, nonatomic) NSArray *questionsAnswered;
@property (strong, nonatomic) NSArray *questionsUnanswered;
@property (strong, nonatomic) NSArray *actionItemsUncomplete;
@property (strong, nonatomic) NSArray *actionItemsComplete;
@property (strong, nonatomic) NSArray *keyPoints;
@property (strong, nonatomic) NSArray *decisions;
@property (strong, nonatomic) NSArray *entries;
@property (assign, nonatomic) BOOL groupEntries;
@property (assign, nonatomic) SortType sortType;
@property (strong, nonatomic) NSString *searchText;

@end

@implementation EntrySummariesTableViewController
@synthesize topic = _topic;
@synthesize questionsAnswered = _questionsAnswered;
@synthesize questionsUnanswered = _questionsUnanswered;
@synthesize keyPoints = _keyPoints;
@synthesize decisions = _decisions;
@synthesize actionItemsComplete = _actionItemsComplete;
@synthesize actionItemsUncomplete = _actionItemsUncomplete;
@synthesize sorting = _sorting;
@synthesize grouping = _grouping;
@synthesize groupEntries = _groupEntries;
@synthesize entries = _entries;
@synthesize sortType = _sortType;
@synthesize searchText = _searchText;
@synthesize detailViewController = _detailViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[BNoteConstants appColor1]];
    
    [self setClearsSelectionOnViewWillAppear:NO];
    [self setGroupEntries:YES];
    [[self sorting] setTitle:@"No Sorting"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNote:)
                                                 name:TopicUpdated object:nil];
    
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setTopic:nil];
    [self setQuestionsAnswered:nil];
    [self setQuestionsUnanswered:nil];
    [self setKeyPoints:nil];
    [self setDecisions:nil];
    [self setActionItemsComplete:nil];
    [self setActionItemsUncomplete:nil];
    [self setGrouping:nil];
    [self setSorting:nil];
    [self setSearchText:nil];
}

- (void)updateNote:(id)sender
{
    [self reload];
}

- (NSArray *)filterEntries:(id<BNoteFilter>)filter
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSEnumerator *notes = [[[self topic] notes] objectEnumerator];
    Note *note;
    while (note = [notes nextObject]) {
        NSEnumerator *entries = [[note entries] objectEnumerator];
        Entry *entry;
        while (entry = [entries nextObject]) {
            if ([filter accept:entry]) {
                [array addObject:entry];
            }
        }
    }
    
    notes = [[[self topic] associatedNotes] objectEnumerator];
    while (note = [notes nextObject]) {
        NSEnumerator *entries = [[note entries] objectEnumerator];
        Entry *entry;
        while (entry = [entries nextObject]) {
            if ([filter accept:entry]) {
                [array addObject:entry];
            }
        }
    }
    
    [array sortUsingComparator:^NSComparisonResult(id entry1, id entry2) {
        switch ([self sortType]) {
            case DateAcending:
                if ([entry1 created] > [entry2 created]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                if ([entry1 created] < [entry2 created]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                
                break;
            case DateDecending:
                if ([entry1 created] < [entry2 created]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                if ([entry1 created] > [entry2 created]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }

                break;
            default:
                break;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSArray *filtered;
    if ([BNoteStringUtils nilOrEmpty:[self searchText]]) {
        filtered = array;
    } else {
        NSPredicate *p = [NSPredicate predicateWithFormat:@"text CONTAINS[c] %@", [self searchText]];
        filtered = [array filteredArrayUsingPredicate:p];
    }
    
    return filtered;
}

- (void)reload
{
    [self setQuestionsAnswered:[self filterEntries:[BNoteFilterFactory create:QuestionAnsweredType]]];
    [self setQuestionsUnanswered:[self filterEntries:[BNoteFilterFactory create:QuestionUnansweredType]]];
    [self setActionItemsComplete:[self filterEntries:[BNoteFilterFactory create:ActionItemCompleteType]]];
    [self setActionItemsUncomplete:[self filterEntries:[BNoteFilterFactory create:ActionItemsIncompleteType]]];
    [self setDecisions:[self filterEntries:[BNoteFilterFactory create:DecistionType]]];
    [self setKeyPoints:[self filterEntries:[BNoteFilterFactory create:KeyPointType]]];
    [self setEntries:[self filterEntries:[BNoteFilterFactory create:ItdentityType]]];
    
    [[self tableView] reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self groupEntries]) {
        return 6;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self groupEntries]) {
        return [[self entriesForSection:section] count];
    } else {
        return [[self entries] count];
    }
}

- (NSArray *)entriesForSection:(int)section
{
    if (![self groupEntries]) {
        return [self entries];
    }
    
    switch (section) {
        case 0:
            return [self actionItemsComplete];
            break;
        case 1:
            return [self actionItemsUncomplete];
            break;
        case 2:
            return [self decisions];
            break;
        case 3:
            return [self keyPoints];
            break;
        case 4:
            return [self questionsAnswered];
            break;
        case 5:
            return [self questionsUnanswered];
            break;
        default:
            break;
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (![self groupEntries]) {
        return @"All";
    }

    switch (section) {
        case 0:
            return @"Action Items - Complete";
            break;
        case 1:
            return @"Action Items - Incomplete";
            break;
        case 2:
            return @"Decisions";
            break;
        case 3:
            return @"Key Points";
            break;
        case 4:
            return @"Questions - Answered";
            break;
        case 5:
            return @"Questions - Unswered";
            break;
        default:
            break;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"EntrySummaryTableViewCell";
 
    EntrySummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[EntrySummaryTableViewCell alloc] initWithIdentifier:cellIdentifier];
    }
        
    Entry *entry = [[self entriesForSection:[indexPath section]] objectAtIndex:[indexPath row]];
        
    [cell setEntry:entry];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Entry *entry = [[self entriesForSection:[indexPath section]] objectAtIndex:[indexPath row]];

    [EditNoteViewPresenter presentEntry:entry in:[self detailViewController]];
}

- (IBAction)group:(id)sender
{
    UISegmentedControl *control = (UISegmentedControl *)sender;
    
    if ([control selectedSegmentIndex] == 0) {
        [self setGroupEntries:YES];
    } else {
        [self setGroupEntries:NO];
    }

    [self reload];
}

- (IBAction)sort:(id)sender
{
    switch ([self sortType]) {
        case None:
            [self setSortType:DateAcending];
            [[self sorting] setTitle:@"Date Ascending"];
            break;
        case DateAcending:
            [self setSortType:DateDecending];
            [[self sorting] setTitle:@"Date Decending"];
            break;
        case DateDecending:
            [self setSortType:None];
            [[self sorting] setTitle:@"No Sorting"];
            break;
        default:
            break;
    }
    
    [self reload];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self setSearchText:[searchBar text]];
    [self reload];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self setSearchText:[searchBar text]];
    [self reload];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self setSearchText:[searchBar text]];
    [self reload];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
