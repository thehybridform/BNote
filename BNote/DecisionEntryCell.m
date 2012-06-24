//
//  DecisionEntryCell.m
//  BeNote
//
//  Created by Young Kristin on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DecisionEntryCell.h"
#import "Decision.h"

@implementation DecisionEntryCell

- (Decision *)decision
{
    return (Decision *) [self entry];
}

- (void)setup
{
    [super setup];
    
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDecisionOptions:)];
    [self addGestureRecognizer:tap];
}

- (void)showDecisionOptions:(UITapGestureRecognizer *)gesture
{
    [[self textView] becomeFirstResponder];
}

@end
