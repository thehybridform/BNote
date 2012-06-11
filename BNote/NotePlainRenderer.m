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
    NSString *text = [note subject];
    NSString *created = [BNoteStringUtils formatDate:[note created]];
    
    return [BNoteStringUtils append:title, text, @" - Created: ", created, NewLine, NewLine, nil];
}

@end
