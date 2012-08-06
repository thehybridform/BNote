//
//  BNoteLiteViewController.m
//  BeNote
//
//  Created by kristin young on 8/4/12.
//
//

#import "BNoteLiteViewController.h"
#import "BNoteSessionData.h"
#import "EluaViewController.h"
#import "BNoteReader.h"

@interface BNoteLiteViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIButton *okButton;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation BNoteLiteViewController
@synthesize webView = _webView;
@synthesize okButton = _okButton;
@synthesize closeButton = _closeButton;

- (id)initWithDefault
{
    self = [super initWithNibName:@"BNoteLiteViewController" bundle:nil];
    if (self) {

    }
    return self;
}

- (IBAction)close:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)ok:(id)sender
{
    [[self closeButton] setHidden:NO];
    [[self okButton] setHidden:YES];

    EluaViewController *controller = [[EluaViewController alloc] initWithDefault];
    [controller setEula:YES];
    [controller setModalInPopover:YES];
    [controller setModalPresentationStyle:UIModalPresentationPageSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self presentViewController:controller animated:YES completion:^{}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[self closeButton] setHidden:YES];
    
#ifdef LITE
    NSString *path = [[NSBundle mainBundle] pathForResource:@"lite-description.rtf" ofType:nil];
#else
    NSString *path = [[NSBundle mainBundle] pathForResource:@"full-description.rtf" ofType:nil];
#endif
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[self webView] loadRequest:request];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end