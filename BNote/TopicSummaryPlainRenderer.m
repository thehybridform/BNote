//
//  TopicSummaryPlainRenderer.m
//  BNote
//
//  Created by Young Kristin on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopicSummaryPlainRenderer.h"

@implementation TopicSummaryPlainRenderer

- (NSString *)render:(Topic *)topic;
{
    NSString *title = [NSLocalizedString(@"Topic", nil) stringByAppendingString:@": "];
    NSString *text = [topic title];
    NSString *created = [BNoteStringUtils formatDate:[topic created]];
    
    return [BNoteStringUtils append:title, text, @" - ", NSLocalizedString(@"Created Date", nil), @": ", created, kNewLine, kNewLine, nil];
}

@end
