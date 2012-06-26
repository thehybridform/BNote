//
//  DecisionContentViewController.m
//  BeNote
//
//  Created by Young Kristin on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DecisionContentViewController.h"
#import "Decision.h"

@interface DecisionContentViewController()
@property (assign, nonatomic) Decision *decision;
@end

@implementation DecisionContentViewController
@synthesize decision = _decision;

- (Decision *)decision
{
    return (Decision *) [self entry];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self scrollView] removeFromSuperview];
    [[self detailTextView] removeFromSuperview];
}

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    [[self mainTextView] becomeFirstResponder];
}

@end
