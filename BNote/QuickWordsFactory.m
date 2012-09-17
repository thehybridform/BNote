//
//  QuickWordsFactory.m
//  BNote
//
//  Created by Young Kristin on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuickWordsFactory.h"
#import "QuickWordButton.h"
#import "DateQuickButton.h"
#import "KeyWordButton.h"
#import "AttendantQuickButton.h"
#import "BNoteReader.h"

@implementation QuickWordsFactory

+ (NSMutableArray *)buildDateButtonsForEntryContent:(id<EntryContent>)controller
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    DateQuickButton *button;
    
    button = [[DateQuickButton alloc] initWithName:NSLocalizedString(@"yesterday", @"yeterday") andEntryContentViewController:controller];
    [button setOffset:-1];
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:button];
    
    button = [[DateQuickButton alloc] initWithName:NSLocalizedString(@"tomorrow", @"tomorrow") andEntryContentViewController:controller];
    [button setOffset:1];
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:button];

    button = [[DateQuickButton alloc] initWithName:NSLocalizedString(@"week ago", @"A week ago") andEntryContentViewController:controller];
    [button setOffset:-7];
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:button];

    button = [[DateQuickButton alloc] initWithName:NSLocalizedString(@"week from now", @"A week from now") andEntryContentViewController:controller];
    [button setOffset:7];
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:button];
    
    return data;
}

+ (NSMutableArray *)buildKeyWordButtionsForEntryContent:(id<EntryContent>)controller
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    for (KeyWord *keyWord in [[BNoteReader instance] allKeyWords]) {
        KeyWordButton *button =
            [[KeyWordButton alloc] initWithName:[keyWord word] andEntryContentViewController:controller];
        [button setKeyWord:keyWord];
        [button setBackgroundColor:[QuickWordsFactory normal]];
        [data addObject:button];
    }
    
    return data;
}

+ (NSMutableArray *)buildAttendantButtionsForEntryContent:(id<EntryContent>)controller
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
        
    for (Attendant *attendant in [BNoteEntryUtils attendees:[[controller entry] note]]) {
        NSString *name = [BNoteStringUtils append:[attendant firstName], @" ", [attendant lastName], nil];
        AttendantQuickButton *button =
        [[AttendantQuickButton alloc] initWithName:name andEntryContentViewController:controller];
        [button setBackgroundColor:[QuickWordsFactory normal]];
        [data addObject:button];
    }

    return data;
}

+ (UIColor *)normal
{
    return [BNoteConstants appHighlightColor1];
}

+ (UIColor *)special
{
    return [UIColor blueColor];
}

@end
