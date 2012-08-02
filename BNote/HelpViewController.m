//
//  HelpViewController.m
//  BNote
//
//  Created by Young Kristin on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()
@property (strong, nonatomic) UIViewController *parentController;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation HelpViewController
@synthesize parentController = _parentController;
@synthesize imageView = _imageView;

- (id)initWith:(UIViewController *)parentController
{
    self = [super initWithNibName:@"HelpViewController" bundle:nil];
    if (self) {
        [self setParentController:parentController];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:[self parentController] action:@selector(dismissHelp:)];
    [[self imageView] addGestureRecognizer:tap];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setParentController:nil];
    [self setImageView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
