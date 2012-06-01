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

@interface EntrySummariesTableViewController ()
@property (strong, nonatomic) NSArray *questionsAnswered;
@property (strong, nonatomic) NSArray *questionsUnanswered;
@property (strong, nonatomic) NSArray *actionItemsUncomplete;
@property (strong, nonatomic) NSArray *actionItemsComplete;
@property (strong, nonatomic) NSArray *keyPoints;
@property (strong, nonatomic) NSArray *decisions;

@end

@implementation EntrySummariesTableViewController
@synthesize topic = _topic;
@synthesize questionsAnswered = _questionsAnswered;
@synthesize questionsUnanswered = _questionsUnanswered;
@synthesize keyPoints = _keyPoints;
@synthesize decisions = _decisions;
@synthesize actionItemsComplete = _actionItemsComplete;
@synthesize actionItemsUncomplete = _actionItemsUncomplete;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setClearsSelectionOnViewWillAppear:NO];
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
    
    return [NSArray arrayWithArray:array];
}

- (void)reload
{
    [self setQuestionsAnswered:[self filterEntries:[[QuestionAnsweredFilter alloc] init]]];
    [self setQuestionsUnanswered:[self filterEntries:[[QuestionUnansweredFilter alloc] init]]];
    [self setActionItemsComplete:[self filterEntries:[[ActionItemCompleteFilter alloc] init]]];
    [self setActionItemsUncomplete:[self filterEntries:[[ActionItemInCompleteFilter alloc] init]]];
    [self setDecisions:[self filterEntries:[[DecisionFilter alloc] init]]];
    [self setKeyPoints:[self filterEntries:[[KeyPointFilter alloc] init]]];
    
    [[self tableView] reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self entriesForSection:section] count];
}

- (NSArray *)entriesForSection:(int)section
{
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
            return @"Questions - Unnswered";
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
