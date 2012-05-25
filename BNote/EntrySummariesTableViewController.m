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

@interface EntrySummariesTableViewController ()
@property (strong, nonatomic) Topic *topic;
@property (strong, nonatomic) NSMutableArray *entries;

@end

@implementation EntrySummariesTableViewController
@synthesize topic = _topic;
@synthesize entries = _entries;

- (id)initWithTopic:(Topic *)topic
{
    self = [super initWithNibName:@"EntrySummariesTableViewController" bundle:nil];
    if (self) {
        [self setTopic:topic];
        [self setEntries:[[NSMutableArray alloc] init]];

        NSEnumerator *notes = [[[self topic] notes] objectEnumerator];
        Note *note;
        while (note = [notes nextObject]) {
            NSEnumerator *entries = [[note entries] objectEnumerator];
            Entry *entry;
            while (entry = [entries nextObject]) {
                [[self entries] addObject:entry];
            }
        }
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
    return [[self entries] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setEditingAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
        [cell setShowsReorderControl:YES];
        
    }
    
    Entry *entry = [[self entries] objectAtIndex:[indexPath row]];
    
    NSString *text = @"     ";
    if ([entry text]) {
        [[cell textLabel] setText:[text stringByAppendingString:[entry text]]];
    }
    [cell addSubview:[BNoteFactory createIcon:entry active:NO]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
