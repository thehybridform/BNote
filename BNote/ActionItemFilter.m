//
//  ActionItemFilter.m
//  BNote
//
//  Created by Young Kristin on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActionItemFilter.h"
#import "ActionItem.h"

@implementation ActionItemFilter

- (BOOL)accept:(id)item
{
    return [item isKindOfClass:[ActionItem class]];
}

@end
