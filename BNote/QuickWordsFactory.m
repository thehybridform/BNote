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

+ (NSMutableArray *)buildDateButtonsForEntryCellView:(EntryTableCellBasis *)entryCellView
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    DateQuickButton *button;
    
    button = [[DateQuickButton alloc] initWithName:@"yesterday" andEntryCellView:entryCellView];
    [button setOffset:-1];
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:button];
    
    button = [[DateQuickButton alloc] initWithName:@"tomorrow" andEntryCellView:entryCellView];
    [button setOffset:1];
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:button];

    button = [[DateQuickButton alloc] initWithName:@"week ago" andEntryCellView:entryCellView];
    [button setOffset:-7];
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:button];
    
    button = [[DateQuickButton alloc] initWithName:@"week form now" andEntryCellView:entryCellView];
    [button setOffset:7];
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:button];
    
    return data;
}

+ (NSMutableArray *)buildKeyWordButtionsForEntryCellView:(EntryTableCellBasis *)entryCellView
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    NSEnumerator *keyWords = [[[BNoteReader instance] allKeyWords] objectEnumerator];
    KeyWord *keyWord;
    while (keyWord = [keyWords nextObject]) {
        KeyWordButton *button = [[KeyWordButton alloc] initWithName:[keyWord word] andEntryCellView:entryCellView];
        [button setKeyWord:keyWord];
        [button setBackgroundColor:[QuickWordsFactory normal]];
        [data addObject:button];
    }
    
    return data;
}

+ (NSMutableArray *)buildButtionsForEntryCellView:(EntryTableCellBasis *)entryCellView andActionItem:(ActionItem *)actionItem
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    ActionItemQuickButton *button;

    if ([actionItem completed]) {
        button = [[ActionItemMarkDone alloc] initWithName:@"mark incomplete" andEntryCellView:entryCellView];
    } else {
        button = [[ActionItemMarkDone alloc] initWithName:@" mark complete " andEntryCellView:entryCellView];
    }
    
    [button setActionItem:actionItem];
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:button];

    if ([BNoteEntryUtils containsAttendants:[actionItem note]]) {
        Attendants *attendants = [[BNoteEntryUtils attendants:[actionItem note]] objectAtIndex:0];
        if ([[attendants children] count] > 0) {
            button = [[ActionItemResponabiltyButton alloc] initWithName:@"responsibility" andEntryCellView:entryCellView];
            [button setActionItem:actionItem];
            [button setBackgroundColor:[QuickWordsFactory normal]];
            [data addObject:button];
        }
    }
    
    if ([actionItem dueDate]) {
        button = [[DueDateActionItemButton alloc] initWithName:@"clear due date" andEntryCellView:entryCellView];
    } else {
        button = [[DueDateActionItemButton alloc] initWithName:@"   due date   " andEntryCellView:entryCellView];
    }
    [button setActionItem:actionItem];
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:button];
    
    return data;
}

+ (NSMutableArray *)buildButtionsForEntryCellView:(EntryTableCellBasis *)entryCellView andQuestion:(Question *)question
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    QuestionQuickButton *button;
    if ([question answer]) {
        button = [[QuestionQuickButton alloc] initWithName:@"Clear Answer" andEntryCellView:entryCellView];
    } else {
        button = [[QuestionQuickButton alloc] initWithName:@"   Answer   " andEntryCellView:entryCellView];
    }
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [button setQuestion:question];
    
    [data addObject:button];
    
    return data;
}

+ (NSMutableArray *)buildButtionsForEntryCellView:(EntryTableCellBasis *)entryCellView andKeyPoint:(KeyPoint *)keyPoint
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    KeyPointButton *button;

    if ([keyPoint photo]) {
        button = [[KeyPointPhotoPickerButton alloc] initWithName:@"change photo" andEntryCellView:entryCellView];\
    } else {
        button = [[KeyPointPhotoPickerButton alloc] initWithName:@"photos" andEntryCellView:entryCellView];\
    }
    [button setKeyPoint:keyPoint];
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:button];
    
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (hasCamera) {
        button = [[KeyPointCameraButton alloc] initWithName:@"take picture" andEntryCellView:entryCellView];
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
