//
//  ActionItemResponabiltyButton.m
//  BNote
//
//  Created by Young Kristin on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActionItemResponabiltyButton.h"
#import "EntriesViewController.h"
#import "ResponsibilityTableViewController.h"
#import "BNoteStringUtils.h"

@interface ActionItemResponabiltyButton()
@property (strong, nonatomic) UIPopoverController *popup;

@end

@implementation ActionItemResponabiltyButton
@synthesize popup = _popup;

- (void)execute:(id)sender
{
    EntryTableViewCell *cell = [self entryCellView];
    EntriesViewController *controller = [cell parentController];
    
    [[cell textView] resignFirstResponder];

    ResponsibilityTableViewController *tableController = [[ResponsibilityTableViewController alloc] initWithEntries:[[controller note] entries]];
    [tableController setDelegate:self];
    
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:tableController];
    [self setPopup:popup];
    
    UIView *view = self;
    CGRect rect = [view bounds];
    
    [popup presentPopoverFromRect:rect inView:view
         permittedArrowDirections:UIPopoverArrowDirectionUp 
                         animated:YES];
}

- (void)selectedAttendant:(Attendant *)attendant
{
    NSString *name = [BNoteStringUtils append:[attendant firstName], @" ", [attendant lastName], nil];
    [[self actionItem] setResponsibility:name];

    [[self popup] dismissPopoverAnimated:YES];
}
@end
