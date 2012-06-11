//
//  KeyPointPlainRenderer.m
//  BNote
//
//  Created by Young Kristin on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KeyPointPlainRenderer.h"
#import "KeyPoint.h"

@implementation KeyPointPlainRenderer

- (BOOL)accept:(Entry *)entry
{
    return [entry isKindOfClass:[KeyPoint class]];
}

- (NSString *)render:(Entry *)entry
{
    NSString *title = @" - Key Point: ";
    NSString *created = [BNoteStringUtils formatDate:[entry created]];
    NSString *text = [entry text];
    
    return [BNoteStringUtils append:title, @" - Created: ", created, NewLine, text, NewLine, NewLine, nil];
}

@end
