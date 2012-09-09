//
//  DecisionToKeyPointConverter.m
//  BeNote
//
//  Created by kristin young on 8/6/12.
//
//

#import "DecisionToKeyPointConverter.h"
#import "Decision.h"

@implementation DecisionToKeyPointConverter

- (BOOL)convert:(Entry *)entryFrom to:(Entry *)entryTo
{
    if ([entryFrom isKindOfClass:[Decision class]] && [entryTo isKindOfClass:[KeyPoint class]]) {
        
        [entryTo setText:[entryFrom text]];
        
        return YES;
    }
    
    return NO;
}

@end
