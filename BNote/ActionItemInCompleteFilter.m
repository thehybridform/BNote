//
//  ActionItemInCompleteFilter.m
//  BNote
//
//  Created by Young Kristin on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActionItemInCompleteFilter.h"

@implementation ActionItemInCompleteFilter

- (BOOL)accept:(id)item
{
    if ([item isKindOfClass:[ActionItem class]]) {
        ActionItem *actionItem = (ActionItem *) item;
        return ![actionItem completed];
    }
    
    return NO;
}

@end
