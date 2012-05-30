//
//  QuickWordsFactory.m
//  BNote
//
//  Created by Young Kristin on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuickWordsFactory.h"
#import "BNoteFactory.h"
#import "QuickWordButton.h"
#import "DateQuickButton.h"
#import "ActionItemQuickButton.h"
#import "ActionItemMarkDone.h"
#import "QuestionQuickButton.h"
#import "AttendantQuickButton.h"

@implementation QuickWordsFactory

+ (NSMutableArray *)buildDateButtonsForTextView:(UITextView *)textView
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    DateQuickButton *button;
    
    button = [[DateQuickButton alloc] initWithName:@"yesterday" andTextView:textView];
    [button setOffset:-1];
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:button];
    
    button = [[DateQuickButton alloc] initWithName:@"tomorrow" andTextView:textView];
    [button setOffset:1];
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:button];

    button = [[DateQuickButton alloc] initWithName:@"week ago" andTextView:textView];
    [button setOffset:-7];
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:button];
    
    button = [[DateQuickButton alloc] initWithName:@"week form now" andTextView:textView];
    [button setOffset:7];
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:button];
    
    return data;
}

+ (NSMutableArray *)buildButtionsForTextView:(UITextView *)textView andActionItem:(ActionItem *)actionItem
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    ActionItemQuickButton *button;

    if ([actionItem completed]) {
        button = [[ActionItemMarkDone alloc] initWithName:@" mark complete " andTextView:textView];
    } else {
        button = [[ActionItemMarkDone alloc] initWithName:@"mark incomplete" andTextView:textView];
    }
    
    [button setActionItem:actionItem];
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:button];

    
    return data;
}

+ (NSMutableArray *)buildButtionsForTextView:(UITextView *)textView andQuestion:(Question *)question
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    QuestionQuickButton *button;

    if ([question answer]){
        button = [[QuestionQuickButton alloc] initWithName:@"clear answer" andTextView:textView];
    } else {
        button = [[QuestionQuickButton alloc] initWithName:@"   answer   " andTextView:textView];
    }
    
    [button setQuestion:question];
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:button];

    return data;
}

+ (NSMutableArray *)buildButtionsForTextView:(UITextView *)textView andNote:(Note *)note
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    AttendantQuickButton *button;
    
    button = [[AttendantQuickButton alloc] initWithName:@"contacts" andTextView:textView];
    [button setNote:note];
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:button];

    button = [[AttendantQuickButton alloc] initWithName:@"add contact" andTextView:textView];
    [button setNote:note];
    [button setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:button];
    

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
