//
//  KeyPointToDecisionConverter.m
//  BeNote
//
//  Created by kristin young on 8/6/12.
//
//

#import "KeyPointToDecisionConverter.h"
#import "Decision.h"

@implementation KeyPointToDecisionConverter

- (BOOL)convert:(Entry *)entryFrom to:(Entry *)entryTo
{
    if ([entryFrom isKindOfClass:[KeyPoint class]] && [entryTo isKindOfClass:[Decision class]]) {
        
        [entryTo setText:[entryFrom text]];
        
        return YES;
    }
    
    return NO;
}

@end
