//
//  EluaViewController.m
//  BeNote
//
//  Created by Young Kristin on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EluaViewController.h"

@interface EluaViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation EluaViewController
@synthesize webView = _webView;

- (id)initWithDefault;
{
    self = [super initWithNibName:@"EluaViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BeNote-EULA.rtf" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[self webView] loadRequest:request];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setWebView:nil];
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
