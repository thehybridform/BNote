//
//  ProgressViewController.m
//  BeNote
//
//  Created by Young Kristin on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProgressViewController.h"
#import "LayerFormater.h"

@interface ProgressViewController ()
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@end

@implementation ProgressViewController
@synthesize backgroundView = _backgroundView;
@synthesize activityView = _activityView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [LayerFormater roundCornersForView:[self backgroundView]];
    
    [[self view] setBackgroundColor:[UIColor clearColor]];
    [[self backgroundView] setBackgroundColor:[UIColor darkGrayColor]];
    [[self backgroundView] setAlpha:0.8];
    [[self activityView] startAnimating];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setBackgroundView:nil];
    [self setActivityView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
