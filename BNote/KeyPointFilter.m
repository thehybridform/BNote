//
//  KeyPointFilter.m
//  BNote
//
//  Created by Young Kristin on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KeyPointFilter.h"
#import "KeyPoint.h"

@implementation KeyPointFilter

- (BOOL)accept:(id)item
{
    return [item isKindOfClass:[KeyPoint class]];
}

@end
