//
//  DecisionToActionItemConverter.m
//  BeNote
//
//  Created by kristin young on 8/6/12.
//
//

#import "DecisionToActionItemConverter.h"
#import "Decision.h"

@implementation DecisionToActionItemConverter

- (BOOL)convert:(Entry *)entryFrom to:(Entry *)entryTo
{
    if ([entryFrom isKindOfClass:[Decision class]] && [entryTo isKindOfClass:[ActionItem class]]) {
        
        [entryTo setText:[entryFrom text]];
        
        return YES;
    }
    
    return NO;
}

@end
