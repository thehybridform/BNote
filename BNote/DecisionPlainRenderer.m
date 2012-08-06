//
//  DecisionPlainRenderer.m
//  BNote
//
//  Created by Young Kristin on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DecisionPlainRenderer.h"
#import "Decision.h"

@implementation DecisionPlainRenderer

- (BOOL)accept:(Entry *)entry
{
    return [entry isKindOfClass:[Decision class]];
}

- (NSString *)render:(Entry *)entry
{
    NSString *title = @" - Decision: ";
    NSString *created = [BNoteStringUtils formatDate:[entry created]];
    NSString *text = [entry text];
    
    return [BNoteStringUtils append:title, @" - Created: ", created, kNewLine, text, kNewLine, kNewLine, nil];
}

@end
