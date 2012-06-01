//
//  DecisionFilter.m
//  BNote
//
//  Created by Young Kristin on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DecisionFilter.h"
#import "Decision.h"

@implementation DecisionFilter

- (BOOL)accept:(id)item
{
    return [item isKindOfClass:[Decision class]];
}

@end
