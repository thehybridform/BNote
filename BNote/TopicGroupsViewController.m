//
//  TopicGroupsViewController.m
//  BeNote
//
//  Created by Young Kristin on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopicGroupsViewController.h"
#import "BNoteSessionData.h"
#import "LayerFormater.h"
#import "BNoteReader.h"
#import "TopicGroup.h"
#import "Topic.h"

@interface TopicGroupsViewController ()
@property (strong, nonatomic) IBOutlet UIView *footer;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (assign, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TopicGroupsViewController
@synthesize footer = _footer;
@synthesize data = _data;
@synthesize popup = _popup;
@synthesize addButton = _addButton;
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [self setData:[[BNoteReader instance] allTopicGroups]];
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

    [self setFooter:nil];
    [self setData:nil];
    [self setAddButton:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self data] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"GroupCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setEditingAccessoryType:UITableViewCellAccessoryNone];
        [cell setShowsReorderControl:NO];
        [LayerFormater setBorderWidth:1 forView:cell];

        [LayerFormater setBorderColor:[UIColor clearColor] forView:cell];
        
        UIFont *font = [BNoteConstants font:RobotoLight andSize:15.0];
        [[cell textLabel] setFont:font];
        [[cell textLabel] setTextColor:[BNoteConstants appHighlightColor1]];
    }

    TopicGroup *topicGroup = [[self data] objectAtIndex:[indexPath row]];
    NSString *text = @"   ";
    [[cell textLabel] setText:[text stringByAppendingString:[topicGroup name]]];

    NSString *name = [BNoteSessionData stringForKey:TopicGroupSelected];
    
    if ([[topicGroup name] isEqualToString:name]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    [[self popup] dismissPopoverAnimated:YES];
    TopicGroup *topicGroup = [[self data] objectAtIndex:[indexPath row]];
    
    NSString *currentGroup = [BNoteSessionData stringForKey:TopicGroupSelected];
    if (![[topicGroup name] isEqualToString:currentGroup]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TopicGroupSelected object:topicGroup];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [indexPath row] > 0;
}

- (IBAction)newGroup:(id)sender
{
    [[self popup] dismissPopoverAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:TopicGroupManage object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
