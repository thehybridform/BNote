//
//  TopicSummaryPlainRenderer.m
//  BNote
//
//  Created by Young Kristin on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopicSummaryPlainRenderer.h"
#import "Topic.h"

@implementation TopicSummaryPlainRenderer

- (NSString *)render:(Topic *)topic;
{
    NSString *title = @"Topic: ";
    NSString *text = [topic title];
    NSString *created = [BNoteStringUtils formatDate:[topic created]];
    
    return [BNoteStringUtils append:title, text, @" - Created: ", created, NewLine, NewLine, nil];
}

@end
