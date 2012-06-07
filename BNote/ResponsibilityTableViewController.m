//
//  ResponsibilityTableViewController.m
//  BNote
//
//  Created by Young Kristin on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResponsibilityTableViewController.h"
#import "AttendantFilter.h"

@interface ResponsibilityTableViewController ()
@property (strong, nonatomic) NSMutableArray *data;
@end

@implementation ResponsibilityTableViewController
@synthesize data = _data;
@synthesize delegate = _delegate;

- (id)initWithEntries:(NSOrderedSet *)entries
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:[entries count]];
        [self setData:data];
        
        AttendantFilter *filter = [[AttendantFilter alloc] init];
        NSEnumerator *items = [entries objectEnumerator];
        Entry *entry;
        while (entry = [items nextObject]) {
            if ([filter accept:entry]) {
                [data addObject:entry];
            }
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setData:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    Attendant *attendant = [[self data] objectAtIndex:[indexPath row]];
    NSString *name = [BNoteStringUtils append:[NSArray arrayWithObjects:[attendant firstName], @" ", [attendant lastName], nil]];
    [[cell textLabel] setText:name];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Attendant *attendant = [[self data] objectAtIndex:[indexPath row]];
    [[self delegate] selectedAttendant:attendant];
}

@end
