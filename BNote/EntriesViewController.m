//
//  EntriesViewController.m
//  BNote
//
//  Created by Young Kristin on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntriesViewController.h"
#import "LayerFormater.h"
#import "BNoteStringUtils.h"
#import "EntryContentViewController.h"
#import "Entry.h"
#import "BNoteWriter.h"
#import "BNoteSessionData.h"
#import "BNoteFactory.h"
#import "Attendant.h"
#import "KeyPoint.h"
#import "BNoteEntryUtils.h"
#import "QuickWordsViewController.h"

@interface EntriesViewController ()
@property (strong, nonatomic) NSMutableArray *filteredControllers;
@property (assign, nonatomic) UITextView *textView;

@end

@implementation EntriesViewController
@synthesize note = _note;
@synthesize entryCell = _entryCell;
@synthesize filter = _filter;
@synthesize filteredControllers = _filteredControllers;
@synthesize parentController = _parentController;
@synthesize textView = _textView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setAutoresizesSubviews:YES];
    
    [self setFilteredControllers:[[NSMutableArray alloc] init]];
    [self setFilter:[BNoteFilterFactory create:ItdentityType]];

    [[self view] setBackgroundColor:[BNoteConstants appColor1]];
     
    UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"Add Key Word" action:@selector(addQuickWord:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:menuItem, nil]];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startedEditing:)
                                                 name:UITextViewTextDidBeginEditingNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setNote:nil];
    [self setEntryCell:nil];
    [self setFilter:nil];
    [self setFilteredControllers:nil];
    [self setParentController:nil];
}

- (void)setFilter:(id<BNoteFilter>)filter
{
    _filter = filter;
    [self reload];
}

- (void)setNote:(Note *)note
{
    _note = note;
    [self setFilter:[BNoteFilterFactory create:ItdentityType]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self filteredControllers] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell =
        [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    EntryContentViewController *controller = [[self filteredControllers] objectAtIndex:[indexPath row]]; 

    [controller setParentController:[self parentController]];

    [cell setEditingAccessoryType:UITableViewCellAccessoryNone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    [cell setAutoresizesSubviews:YES];
    [[cell contentView] setAutoresizesSubviews:YES];
    [[cell contentView] addSubview:[controller view]];
    
    [LayerFormater setBorderWidth:1 forView:cell];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [[NSNotificationCenter defaultCenter] removeObserver:cell];
        
        EntryContentViewController *controller = [[self filteredControllers] objectAtIndex:[indexPath row]]; 

        [[self filteredControllers] removeObject:controller];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                         withRowAnimation:UITableViewRowAnimationFade];
        
        Entry *entry = [controller entry];
        if ([entry isKindOfClass:[Attendants class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:AttendantsEntryDeleted object:entry];
        }

        [[BNoteWriter instance] removeEntry:entry];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EntryContentViewController *controller = [[self filteredControllers] objectAtIndex:[indexPath row]]; 
    
    return [controller height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)reload
{
    [[self filteredControllers] removeAllObjects];
    for (Entry *entry in [[self note] entries]) {
        if ([[self filter] accept:entry]) {
            if (![entry isKindOfClass:[Attendants class]]) {
                EntryContentViewController *controller = [BNoteFactory createEntryContentViewControllerForEntry:entry];
                [[self filteredControllers] addObject:controller];
            }
        }
    }
    
    NSArray *attendants = [BNoteEntryUtils attendants:[self note]];
    if (attendants && [attendants count] > 0) {
        // there will only be one
        EntryContentViewController *controller = [BNoteFactory createEntryContentViewControllerForEntry:[attendants objectAtIndex:0]];
        [[self filteredControllers] insertObject:controller atIndex:0];
    }
    
    [[self tableView] reloadData];
}

- (void)selectLastCell
{
    int index = [[self filteredControllers] count] - 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [[self tableView] scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    EntryContentViewController *controller = [[self filteredControllers] objectAtIndex:index];
    [[controller mainTextView] becomeFirstResponder];
}

- (void)selectFirstCell
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [[self tableView] scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)selectEntry:(Entry *)entry
{
    for (EntryContentViewController *controller in [self filteredControllers]) {
        if ([controller entry] == entry) {
            [[controller mainTextView] becomeFirstResponder];
        }
    }
}

- (void)addQuickWord:(id)sender
{
    UITextView *textView = [self textView];
    UITextRange *range = [textView selectedTextRange];
    NSString *keyWord = [textView textInRange:range];
    
    [BNoteFactory createKeyWord:keyWord];
    [[NSNotificationCenter defaultCenter] postNotificationName:KeyWordsUpdated object:nil];
}

- (void)startedEditing:(NSNotification *)notification
{
    [self setTextView:[notification object]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [[self tableView] reloadData];
}

@end
