//
//  EntrySummariesTableViewController.m
//  BNote
//
//  Created by Young Kristin on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntrySummariesTableViewController.h"
#import "BNoteFactory.h"
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
@synthesize groupEntries = _groupEntries;
@synthesize entries = _entries;
@synthesize data = _data;
@synthesize dataHeaderView = _dataHeaderView;
@synthesize searchText = _searchText;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[BNoteConstants appColor1]];
    
    [self setClearsSelectionOnViewWillAppear:NO];
    [self setGroupEntries:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNote:)
                                                 name:kTopicUpdated object:nil];
    
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        [data setObject:[self questionsUnanswered] forKey:questionUnansweredEntryHeader];
        [dataHeaderView setObject:[BNoteFactory createEntrySummaryHeaderView:QuestionUnansweredHeader] forKey:questionUnansweredEntryHeader];
    }
    
    [self setEntries:[self filterEntries:[[BNoteFilterFactory instance] create:ItdentityType]]];
        
    [[self tableView] reloadData];
    
    UIView *view = [self view];
    CGRect frame = [view frame];
    CGRect initalFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
    [view setFrame:initalFrame];
    [view setAlpha:0];
    
    [UIView animateWithDuration:0.3
                          delay:0.25
                        options:(UIViewAnimationOptionCurveEaseOut)
                     animations:^(void) {
                         [view setFrame:frame];
                     }
                     completion:^(BOOL finished) {
                     }
     ];
    
    [UIView animateWithDuration:0.2
                          delay:0.25
                        options:(UIViewAnimationOptionCurveEaseOut)
                     animations:^(void) {
                         [view setAlpha:1];
                     }
                     completion:^(BOOL finished) {
                     }
     ];
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
    
    NSString *key = [[self data] keyAtIndex:(NSUInteger) section];
    return [[self data] objectForKey:key];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Entry *entry = [[self entriesForSection:[indexPath section]] objectAtIndex:(NSUInteger) [indexPath row]];

    EntrySummaryTableViewCellController *controller =
            [[EntrySummaryTableViewCellController alloc] initWithEntry:entry];

    
    return [controller cell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Entry *entry = [[self entriesForSection:[indexPath section]] objectAtIndex:(NSUInteger) [indexPath row]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoteSelected object:entry];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (![self groupEntries]) {
        return [BNoteFactory createEntrySummaryHeaderView:AllHeader];
    }
    
    NSString *key = [[self dataHeaderView] keyAtIndex:(NSUInteger) section];
    return [[self dataHeaderView] objectForKey:key];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
