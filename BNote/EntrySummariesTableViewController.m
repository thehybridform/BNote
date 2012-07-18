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
#import "TableCellHeaderViewController.h"
#import "OrderedDictionary.h"
#import "EntrySummaryTableViewCellController.h"

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
@property (strong, nonatomic) OrderedDictionary *data;
@property (strong, nonatomic) OrderedDictionary *dataHeaderView;

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
@synthesize parentController = _parentController;
@synthesize data = _data;
@synthesize dataHeaderView = _dataHeaderView;

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
    [self setQuestionsAnswered:nil];
    [self setQuestionsUnanswered:nil];
    [self setKeyPoints:nil];
    [self setDecisions:nil];
    [self setActionItemsComplete:nil];
    [self setActionItemsUncomplete:nil];
    [self setGrouping:nil];
    [self setSorting:nil];
    [self setSearchText:nil];
    [self setData:nil];
    [self setDataHeaderView:nil];
}

- (void)setTopic:(Topic *)topic
{
    _topic = topic;
    [self reload];
}

- (void)updateNote:(NSNotification *)notification
{
    [self reload];
}

- (NSArray *)filterEntries:(id<BNoteFilter>)filter
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (Note *note in [[self topic] notes]) {
        for (Entry *entry in [note entries]) {
            if ([filter accept:entry]) {
                [array addObject:entry];
            }
        }
    }
    for (Note *note in [[self topic] associatedNotes]) {
        for (Entry *entry in [note entries]) {
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
    OrderedDictionary *data = [[OrderedDictionary alloc] init];
    [self setData:data];
    
    OrderedDictionary *dataHeaderView = [[OrderedDictionary alloc] init];
    [self setDataHeaderView:dataHeaderView];
    
    [self setActionItemsComplete:[self filterEntries:[[BNoteFilterFactory instance] create:ActionItemCompleteType]]];
    if ([[self actionItemsComplete] count]) {
        [data setObject:[self actionItemsComplete] forKey:actionItemsCompletedEntryHeader];
        [dataHeaderView setObject:[BNoteFactory createEntrySummaryHeaderView:ActionItemCompleteHeader] forKey:actionItemsCompletedEntryHeader];
    }
    
    [self setActionItemsUncomplete:[self filterEntries:[[BNoteFilterFactory instance] create:ActionItemsIncompleteType]]];
    if ([[self actionItemsUncomplete] count]) {
        [data setObject:[self actionItemsUncomplete] forKey:actionItemsIncompleteEntryHeader];
        [dataHeaderView setObject:[BNoteFactory createEntrySummaryHeaderView:ActionItemIncompleteHeader] forKey:actionItemsIncompleteEntryHeader];
    }
    
    [self setDecisions:[self filterEntries:[[BNoteFilterFactory instance] create:DecistionType]]];
    if ([[self decisions] count]) {
        [data setObject:[self decisions] forKey:decisionsEntryHeader];
        [dataHeaderView setObject:[BNoteFactory createEntrySummaryHeaderView:DecisionHeader] forKey:decisionsEntryHeader];
    }
    
    [self setKeyPoints:[self filterEntries:[[BNoteFilterFactory instance] create:KeyPointType]]];
    if ([[self keyPoints] count]) {
        [data setObject:[self keyPoints] forKey:keyPointsEntryHeader];
        [dataHeaderView setObject:[BNoteFactory createEntrySummaryHeaderView:KeyPointHeader] forKey:keyPointsEntryHeader];
    }
    
    [self setQuestionsAnswered:[self filterEntries:[[BNoteFilterFactory instance] create:QuestionAnsweredType]]];
    if ([[self questionsAnswered] count]) {
        [data setObject:[self questionsAnswered] forKey:questionAnsweredEntryHeader];
        [dataHeaderView setObject:[BNoteFactory createEntrySummaryHeaderView:QuestionAnsweredHeader] forKey:questionAnsweredEntryHeader];
    }
    
    [self setQuestionsUnanswered:[self filterEntries:[[BNoteFilterFactory instance] create:QuestionUnansweredType]]];
    if ([[self questionsUnanswered] count]) {
        [data setObject:[self questionsUnanswered] forKey:questionAnsweredEntryHeader];
        [dataHeaderView setObject:[BNoteFactory createEntrySummaryHeaderView:QuestionUnansweredHeader] forKey:questionAnsweredEntryHeader];
    }
    
    [self setEntries:[self filterEntries:[[BNoteFilterFactory instance] create:ItdentityType]]];
        
    [[self tableView] reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self groupEntries]) {
        return [[self data] count];
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
    
    NSString *key = [[self data] keyAtIndex:section];
    return [[self data] objectForKey:key];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Entry *entry = [[self entriesForSection:[indexPath section]] objectAtIndex:[indexPath row]];

    EntrySummaryTableViewCellController *controller =
            [[EntrySummaryTableViewCellController alloc] initWithEntry:entry];

    
    return [controller cell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Entry *entry = [[self entriesForSection:[indexPath section]] objectAtIndex:[indexPath row]];
    [[NSNotificationCenter defaultCenter] postNotificationName:NoteSelected object:entry];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (![self groupEntries]) {
        return [BNoteFactory createEntrySummaryHeaderView:AllHeader];
    }
    
    NSString *key = [[self dataHeaderView] keyAtIndex:section];
    return [[self dataHeaderView] objectForKey:key];
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
