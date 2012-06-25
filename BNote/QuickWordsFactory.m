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
#import "ActionItemQuickButton.h"
#import "ActionItemMarkDone.h"
#import "QuestionQuickButton.h"
#import "KeyPointButton.h"
#import "KeyPointCameraButton.h"
#import "KeyPointPhotoPickerButton.h"
#import "ActionItemResponabiltyButton.h"
#import "DueDateActionItemButton.h"
#import "KeyWordButton.h"
#import "KeyWord.h"
#import "BNoteReader.h"
#import "BNoteEntryUtils.h"
#import "LayerFormater.h"
#import "Attendants.h"
#import "Attendant.h"

@implementation QuickWordsFactory

+ (NSMutableArray *)buildDateButtonsForEntryContentViewController:(EntryContentViewController *)controller
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    DateQuickButton *button;
    
    button = [[DateQuickButton alloc] initWithName:@"yesterday" andEntryContentViewController:controller];
    [button setOffset:-1];
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:button];
    
    button = [[DateQuickButton alloc] initWithName:@"tomorrow" andEntryContentViewController:controller];
    [button setOffset:1];
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:button];

    button = [[DateQuickButton alloc] initWithName:@"week ago" andEntryContentViewController:controller];
    [button setOffset:-7];
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:button];
    
    button = [[DateQuickButton alloc] initWithName:@"week form now" andEntryContentViewController:controller];
    [button setOffset:7];
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:button];
    
    return data;
}

+ (NSMutableArray *)buildKeyWordButtionsForEntryContentViewController:(EntryContentViewController *)controller
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    NSEnumerator *keyWords = [[[BNoteReader instance] allKeyWords] objectEnumerator];
    KeyWord *keyWord;
    while (keyWord = [keyWords nextObject]) {
        KeyWordButton *button = [[KeyWordButton alloc] initWithName:[keyWord word] andEntryContentViewController:controller];
        [button setKeyWord:keyWord];
        [button setBackgroundColor:[QuickWordsFactory normal]];
        [data addObject:button];
    }
    
    return data;
}

+ (NSMutableArray *)buildButtionsForEntryContentViewController:(EntryContentViewController *)controller andActionItem:(ActionItem *)actionItem
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    ActionItemQuickButton *button;

    if ([actionItem completed]) {
        button = [[ActionItemMarkDone alloc] initWithName:@"mark incomplete" andEntryContentViewController:controller];
    } else {
        button = [[ActionItemMarkDone alloc] initWithName:@" mark complete " andEntryContentViewController:controller];
    }
    
    [button setActionItem:actionItem];
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:button];

    if ([BNoteEntryUtils containsAttendants:[actionItem note]]) {
        Attendants *attendants = [[BNoteEntryUtils attendants:[actionItem note]] objectAtIndex:0];
        if ([[attendants children] count] > 0) {
            button = [[ActionItemResponabiltyButton alloc] initWithName:@"responsibility" andEntryContentViewController:controller];
            [button setActionItem:actionItem];
            [button setBackgroundColor:[QuickWordsFactory normal]];
            [data addObject:button];
        }
    }
    
    if ([actionItem dueDate]) {
        button = [[DueDateActionItemButton alloc] initWithName:@"clear due date" andEntryContentViewController:controller];
    } else {
        button = [[DueDateActionItemButton alloc] initWithName:@"   due date   " andEntryContentViewController:controller];
    }
    [button setActionItem:actionItem];
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:button];
    
    return data;
}

+ (NSMutableArray *)buildButtionsForEntryContentViewController:(EntryContentViewController *)controller andQuestion:(Question *)question
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    QuestionQuickButton *button;
    if ([question answer]) {
        button = [[QuestionQuickButton alloc] initWithName:@"Clear Answer" andEntryContentViewController:controller];
    } else {
        button = [[QuestionQuickButton alloc] initWithName:@"   Answer   " andEntryContentViewController:controller];
    }
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [button setQuestion:question];
    
    [data addObject:button];
    
    return data;
}

+ (NSMutableArray *)buildButtionsForEntryContentViewController:(EntryContentViewController *)controller andKeyPoint:(KeyPoint *)keyPoint
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    KeyPointButton *button;

    if ([keyPoint photo]) {
        button = [[KeyPointPhotoPickerButton alloc] initWithName:@"change photo" andEntryContentViewController:controller];
    } else {
        button = [[KeyPointPhotoPickerButton alloc] initWithName:@"photos" andEntryContentViewController:controller];
    }
    [button setKeyPoint:keyPoint];
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:button];
    
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (hasCamera) {
        button = [[KeyPointCameraButton alloc] initWithName:@"take picture" andEntryContentViewController:controller];
        [button setKeyPoint:keyPoint];
        [button setBackgroundColor:[QuickWordsFactory normal]];
        [data addObject:button];
    }
    
    return data;
}

+ (UIColor *)normal
{
    return [UIColor orangeColor];
}

+ (UIColor *)special
{
    return [UIColor blueColor];
}

@end
