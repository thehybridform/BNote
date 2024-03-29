//
//  ResponsibilityTableViewController.m
//  BNote
//
//  Created by Young Kristin on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResponsibilityTableViewController.h"

@interface ResponsibilityTableViewController ()
@property (strong, nonatomic) NSMutableArray *data;
@end

@implementation ResponsibilityTableViewController
@synthesize data = _data;
@synthesize delegate = _delegate;

- (id)initWithNote:(Note *)note
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        [self setData:[BNoteEntryUtils attendees:note]];

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
        cell.textLabel.font = [BNoteConstants font:RobotoRegular andSize:15];
        cell.textLabel.textColor = [BNoteConstants appHighlightColor1];
    }
    
    Attendant *attendant = [[self data] objectAtIndex:(NSUInteger) [indexPath row]];
    NSString *name = [BNoteStringUtils append:[attendant firstName], @" ", [attendant lastName], nil];
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
    Attendant *attendant = [[self data] objectAtIndex:(NSUInteger) [indexPath row]];
    [[self delegate] selectedAttendant:attendant];
}

@end
