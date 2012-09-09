//
//  KeyPointPlainRenderer.m
//  BNote
//
//  Created by Young Kristin on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KeyPointPlainRenderer.h"

@implementation KeyPointPlainRenderer

- (BOOL)accept:(Entry *)entry
{
    return [entry isKindOfClass:[KeyPoint class]];
}

- (NSString *)render:(Entry *)entry
{
    NSString *title = [NSLocalizedString(@"Key Point", nil) stringByAppendingString:@": "];
    NSString *created = [BNoteStringUtils formatDate:[entry created]];
    NSString *text = [entry text];
    
    return [BNoteStringUtils append:title, @" - ", NSLocalizedString(@"Created Date", nil), @": ", created, kNewLine, text, kNewLine, kNewLine, nil];
}

@end
