//
//  AttendantFilter.m
//  BNote
//
//  Created by Young Kristin on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AttendantFilter.h"
#import "Attendants.h"

@implementation AttendantFilter

- (BOOL)accept:(id)item
{
    return [item isKindOfClass:[Attendants class]];
}

@end
