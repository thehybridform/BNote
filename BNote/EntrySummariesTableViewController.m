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
#import "QuestionAnsweredFilter.h"
#import "QuestionUnansweredFilter.h"
#import "ActionItemCompleteFilter.h"
#import "ActionItemInCompleteFilter.h"
#import "DecisionFilter.h"
#import "KeyPointFilter.h"
#import "IdentityFillter.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setClearsSelectionOnViewWillAppear:NO];
    [self setGroupEntries:YES];
    [[self sorting] setTitle:@"No Sorting"];
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
}

- (void)setTopic:(Topic *)topic
{
    _topic = topic;
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
    
    return array;
}

- (void)reload
{
    [self setQuestionsAnswered:[self filterEntries:[[QuestionAnsweredFilter alloc] init]]];
    [self setQuestionsUnanswered:[self filterEntries:[[QuestionUnansweredFilter alloc] init]]];
    [self setActionItemsComplete:[self filterEntries:[[ActionItemCompleteFilter alloc] init]]];
    [self setActionItemsUncomplete:[self filterEntries:[[ActionItemInCompleteFilter alloc] init]]];
    [self setDecisions:[self filterEntries:[[DecisionFilter alloc] init]]];
    [self setKeyPoints:[self filterEntries:[[KeyPointFilter alloc] init]]];
    [self setEntries:[self filterEntries:[[IdentityFillter alloc] init]]];
    
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
 
    EntrySummaryTableViewCell *cell =
        cell = [[EntrySummaryTableViewCell alloc] initWithIdentifier:cellIdentifier];
        [LayerFormater roundCornersForView:cell];
        
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
    NoteEditorViewController *controller = [[NoteEditorViewController alloc] initWithNote:[entry note]];
    [controller setModalPresentationStyle:UIModalPresentationPageSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:controller animated:YES];

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
