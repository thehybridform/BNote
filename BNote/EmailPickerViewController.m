//
//  EmailPickerViewController.m
//  BNote
//
//  Created by Young Kristin on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EmailPickerViewController.h"

@interface EmailPickerViewController ()
@property (strong, nonatomic) NSArray *emails;
@property (strong, nonatomic) Attendant *attendant;

@end

@implementation EmailPickerViewController
@synthesize emails = _emails;
@synthesize attendant = _attendant;
@synthesize delegate = _delegate;

- (id)initWithEmails:(NSArray *)emails forAttendant:(Attendant *)attendant
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        [self setEmails:emails];
        [self setAttendant:attendant];
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
    [self setEmails:nil];
    [self setAttendant:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Choose Email";
    } 
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [[self emails] count];
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    if ([indexPath section] == 0) {
        NSString *email = [[self emails] objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:email];
    } else {
        [[cell textLabel] setText:@"None"];
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
    NSString *email = [[self emails] objectAtIndex:[indexPath row]];
    [[self attendant] setEmail:email];
    [[self delegate] didFinishEmailPicker];
}

@end
