//
//  ConfigurationTableViewController.m
//  BNote
//
//  Created by Young Kristin on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConfigurationTableViewController.h"

@interface ConfigurationTableViewController ()
@property (strong, nonatomic) NSArray *aboutArray;
@property (strong, nonatomic) NSArray *storageArray;

@end

@implementation ConfigurationTableViewController
@synthesize aboutArray = _aboutArray;
@synthesize storageArray = _storageArray;

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray *aboutArray =
        [NSArray arrayWithObjects:@"Version 1.0", @"Copyright", @"License", @"Contact", nil];
    [self setAboutArray:aboutArray];
    
    NSArray *storageArray =
    [NSArray arrayWithObjects:@"iCloud", @"Dropbox", @"Google Drive", nil];
    [self setStorageArray:storageArray];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setAboutArray:nil];
    [self setStorageArray:nil];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [[self aboutArray] count];
    } else {
        return [[self storageArray] count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"About";
    } else {
        return @"Storage";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        if ([indexPath section] == 0) {
            [[cell textLabel] setText:[[self aboutArray] objectAtIndex:[indexPath row]]];
        } else {
            [[cell textLabel] setText:[[self storageArray] objectAtIndex:[indexPath row]]];
        }
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
