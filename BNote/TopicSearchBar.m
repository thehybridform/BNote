//
//  TopicSearchBar.m
//  BeNote
//
//  Created by Young Kristin on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopicSearchBar.h"
#import "BNoteFactory.h"

@implementation TopicSearchBar

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [[self.subviews objectAtIndex:0] setAlpha:0.0];
    }

    return self;
}

@end
