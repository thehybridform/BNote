//
//  DecisionCloner.m
//  BeNote
//
//  Created by Young Kristin on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DecisionCloner.h"
#import "Decision.h"
#import "BNoteFactory.h"

@implementation DecisionCloner

- (Decision *)clone:(Decision *)decision into:(Note *)note
{
    Decision *copy = [BNoteFactory createDecision:note];
    [copy setText:[decision text]];

    return copy;
}

@end
