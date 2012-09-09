//
//  KeyPointToActionItemConverter.m
//  BeNote
//
//  Created by kristin young on 8/6/12.
//
//

#import "KeyPointToActionItemConverter.h"

@implementation KeyPointToActionItemConverter

- (BOOL)convert:(Entry *)entryFrom to:(Entry *)entryTo
{
    if ([entryFrom isKindOfClass:[KeyPoint class]] && [entryTo isKindOfClass:[ActionItem class]]) {
        
        [entryTo setText:[entryFrom text]];
        
        return YES;
    }
    
    return NO;
}

@end
