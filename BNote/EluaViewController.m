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
@property (strong, nonatomic) IBOutlet UIToolbar *normalToobar;
@property (strong, nonatomic) IBOutlet UIToolbar *eulaToobar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *acceptButton;

@end

@implementation EluaViewController
@synthesize webView = _webView;
@synthesize normalToobar = _normalToobar;
@synthesize eulaToobar = _eulaToobar;
@synthesize eula = _eula;
@synthesize acceptButton = _acceptButton;

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
    
    [[[self webView] scrollView] setDelegate:self];
    
    if ([self eula]) {
        [[self normalToobar] setHidden:YES];
        [[self acceptButton] setEnabled:NO];
        [[self eulaToobar] setAlpha:0];
    } else {
        [[self eulaToobar] setHidden:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setWebView:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 968
	CGPoint point = [scrollView contentOffset];
    
    if (point.y > 900) {
        [[self acceptButton] setEnabled:YES];
    } else {
        [[self acceptButton] setEnabled:NO];
    }
    
    CGFloat alpha = 1 + (point.y - 980) / 980;
    [[self eulaToobar] setAlpha:alpha];
}

- (IBAction)done:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)accept:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"OK" forKey:EulaFlag];
    [defaults synchronize];
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
