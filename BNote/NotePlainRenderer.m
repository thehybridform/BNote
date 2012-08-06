//
//  NotePlainRenderer.m
//  BNote
//
//  Created by Young Kristin on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotePlainRenderer.h"
#import "Note.h"

@implementation NotePlainRenderer

- (BOOL)accept:(id)entry
{
    return NO;
}

- (NSString *)render:(Note *)note
{
    NSString *title = @"Note Subject: ";
    NSString *subject = [note subject];
    NSString *created = [BNoteStringUtils formatDate:[note created]];
    
    NSString *text = [BNoteStringUtils append:title, subject, @" - Created: ", created, kNewLine, kNewLine, nil];
    
    if ([note summary]) {
        text = [BNoteStringUtils append:text, @"Summary:", kNewLine, [note summary], kNewLine, kNewLine, nil];
    }
    
    return text;
}

@end
