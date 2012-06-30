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
@property (strong, nonatomic) IBOutlet UIBarButtonItem *declineButton;

@end

@implementation EluaViewController
@synthesize webView = _webView;
@synthesize normalToobar = _normalToobar;
@synthesize eulaToobar = _eulaToobar;
@synthesize eula = _eula;
@synthesize acceptButton = _acceptButton;
@synthesize declineButton = _declineButton;

- (id)initWithDefault;
{
    self = [super initWithNibName:@"EluaViewController" bundle:nil];
    if (self) {
        
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
        [[self declineButton] setEnabled:NO];
        [[self eulaToobar] setAlpha:0];
    } else {
        [[self eulaToobar] setHidden:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setWebView:nil];
    [self setNormalToobar:nil];
    [self setEulaToobar:nil];
    [self setAcceptButton:nil];
    [self setDeclineButton:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGPoint point = [scrollView contentOffset];
    
    
    CGFloat height = 900;
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation & (UIDeviceOrientationPortrait | UIDeviceOrientationPortraitUpsideDown)) {
        height = 650;
    }

    if (point.y > height) {
        [[self acceptButton] setEnabled:YES];
        [[self declineButton] setEnabled:YES];
    } else {
        [[self acceptButton] setEnabled:NO];
        [[self declineButton] setEnabled:NO];
    }
    
    CGFloat alpha = 1 + (point.y - height) / height;
    [[self eulaToobar] setAlpha:alpha];
}

- (IBAction)done:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)decline:(id)sender
{
    UIAlertView *anAlert = [[UIAlertView alloc] initWithTitle:@"Action Required" message:@"Please accept the End User License Agreement, or press home to exit." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [anAlert show];
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
