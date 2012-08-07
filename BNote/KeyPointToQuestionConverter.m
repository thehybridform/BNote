//
//  KeyPointToQuestionConverter.m
//  BeNote
//
//  Created by kristin young on 8/6/12.
//
//

#import "KeyPointToQuestionConverter.h"

@implementation KeyPointToQuestionConverter

- (BOOL)convert:(Entry *)entryFrom to:(Entry *)entryTo
{
    if ([entryFrom isKindOfClass:[KeyPoint class]] && [entryTo isKindOfClass:[Question class]]) {
        
        [entryTo setText:[entryFrom text]];
        
        return YES;
    }
    
    return NO;
}

@end
