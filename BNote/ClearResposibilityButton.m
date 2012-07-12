//
//  ClearResposibilityButton.m
//  BeNote
//
//  Created by Young Kristin on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ClearResposibilityButton.h"

@implementation ClearResposibilityButton

- (void)execute:(id)sender
{
    [[self actionItem] setResponsibility:nil];    
    [[self entryContentViewController] updateDetail];
}


@end
