//
//  ConfigurationViewController.m
//  BNote
//
//  Created by Young Kristin on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConfigurationViewController.h"
#import "ConfigurationTableViewController.h"

@interface ConfigurationViewController ()
@property (strong, nonatomic) IBOutlet ConfigurationTableViewController *configurationTableViewController;

@end

@implementation ConfigurationViewController
@synthesize configurationTableViewController = _configurationTableViewController;

- (id)initWithDefault
{
    self = [super initWithNibName:@"ConfigurationViewController" bundle:nil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (IBAction)done:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
