//
//  TopicSelectTableViewController.m
//  BeNote
//
//  Created by Young Kristin on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopicSelectTableViewController.h"
#import "BNoteReader.h"
#import "BNoteWriter.h"
#import "Topic.h"

@interface TopicSelectTableViewController ()
@property (strong, nonatomic) NSArray *data;

@end

@implementation TopicSelectTableViewController
@synthesize data = _data;
@synthesize note = _note;

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

    NSMutableArray *data = [[BNoteReader instance] allTopics];
    NSPredicate *p = [NSPredicate predicateWithFormat:@"title != %@", [[[self note] topic] title]];
    NSArray *filtered = [data filteredArrayUsingPredicate:p];
    
    [self setData:filtered];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setData:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self data] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

        Topic *topic = [[self data] objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:[topic title]];
    }

    
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
    Topic *topic = [[self data] objectAtIndex:[indexPath row]];
    [[BNoteWriter instance] moveNote:[self note] toTopic:topic];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TopicUpdated object:nil];   
}

@end
