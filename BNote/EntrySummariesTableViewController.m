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

@interface EntrySummariesTableViewController ()
@property (strong, nonatomic) Topic *topic;
@property (strong, nonatomic) NSMutableArray *entries;
@property (strong, nonatomic) NSMutableArray *filteredEntries;

@end

@implementation EntrySummariesTableViewController
@synthesize topic = _topic;
@synthesize entries = _entries;
@synthesize filteredEntries = _filteredEntries;
@synthesize filter = _filter;

- (id)initWithTopic:(Topic *)topic
{
    self = [super initWithNibName:@"EntrySummariesTableViewController" bundle:nil];
    if (self) {
        [self setTopic:topic];
        [self setEntries:[[NSMutableArray alloc] init]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setClearsSelectionOnViewWillAppear:NO];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)setFilter:(id<BNoteFilter>)filter
{
    if (filter != _filter) {
        _filter = filter;
        [self reload];
    }
}

- (void)reload
{
    [self setFilteredEntries:[[NSMutableArray alloc] init]];
    NSEnumerator *notes = [[[self topic] notes] objectEnumerator];
    Note *note;
    while (note = [notes nextObject]) {
        NSEnumerator *entries = [[note entries] objectEnumerator];
        Entry *entry;
        while (entry = [entries nextObject]) {
            if ([[self filter] accept:entry]) {
                [[self filteredEntries] addObject:entry];
            }
        }
    }

    [[self tableView] reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
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
