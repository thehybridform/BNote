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

@implementation QuickWordsFactory

+ (NSArray *)buildDateButtonsForTextView:(UITextView *)textView
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    DateQuickButton *qdb = [[DateQuickButton alloc] initWithName:@"yesterday" andTextView:textView];
    [qdb setOffset:-1];
    [qdb setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:qdb];
    
    qdb = [[DateQuickButton alloc] initWithName:@"tomorrow" andTextView:textView];
    [qdb setOffset:1];
    [qdb setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:qdb];

    qdb = [[DateQuickButton alloc] initWithName:@"week ago" andTextView:textView];
    [qdb setOffset:-7];
    [qdb setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:qdb];
    
    qdb = [[DateQuickButton alloc] initWithName:@"week form now" andTextView:textView];
    [qdb setOffset:7];
    [qdb setBackgroundColor:[QuickWordsFactory normal]];
    [data addObject:qdb];
    
    return [[NSArray alloc] initWithArray:data];
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
