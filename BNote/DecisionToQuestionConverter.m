//
//  DecisionToQuestionConverter.m
//  BeNote
//
//  Created by kristin young on 8/6/12.
//
//

#import "DecisionToQuestionConverter.h"
#import "Decision.h"

@implementation DecisionToQuestionConverter

- (BOOL)convert:(Entry *)entryFrom to:(Entry *)entryTo
{
    if ([entryFrom isKindOfClass:[Decision class]] && [entryTo isKindOfClass:[Question class]]) {
        
        [entryTo setText:[entryFrom text]];
        
        return YES;
    }
    
    return NO;
}

@end
