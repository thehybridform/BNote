//
//  KeyPointCloner.m
//  BeNote
//
//  Created by Young Kristin on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KeyPointCloner.h"
#import "KeyPoint.h"
#import "BNoteFactory.h"
#import "PhotoCloner.h"

@implementation KeyPointCloner

- (KeyPoint *)clone:(KeyPoint *)keyPoint into:(Note *)note
{
    KeyPoint *copy = [BNoteFactory createKeyPoint:note];
    [copy setText:[keyPoint text]];
    
    if ([keyPoint photo]) {
        PhotoCloner *cloner = [[PhotoCloner alloc] init];
        [cloner clone:[keyPoint photo] into:copy];
    }
    
    return copy;
}

@end
