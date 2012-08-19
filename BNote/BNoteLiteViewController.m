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
#import "BNoteDefaultData.h"

@interface BNoteLiteViewController ()
@property (strong, nonatomic) IBOutlet UILabel *thankYouLabel;
@property (strong, nonatomic) IBOutlet UITextView *line1TextView;
@property (strong, nonatomic) IBOutlet UITextView *line2TextView;
@property (strong, nonatomic) IBOutlet UITextView *line3TextView;
@property (strong, nonatomic) IBOutlet UITextView *line4TextView;
@property (strong, nonatomic) IBOutlet UIButton *okButton;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation BNoteLiteViewController
@synthesize thankYouLabel = _thankYouLabel;
@synthesize line1TextView = _line1TextView;
@synthesize line2TextView = _line2TextView;
@synthesize line3TextView = _line3TextView;
@synthesize line4TextView = _line4TextView;
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
    [BNoteDefaultData setup];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefetchAllDatabaseData object:nil];
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

    [self.closeButton setTitle:NSLocalizedString(@"Close", @"Close current window") forState:UIControlStateNormal];
    [self.okButton setTitle:NSLocalizedString(@"Continue", @"Continue to the next window") forState:UIControlStateNormal];

    [[self closeButton] setHidden:YES];

#ifdef LITE
    self.thankYouLabel.text = NSLocalizedString(@"Splash Screen Lite Title", nil);
    self.line2TextView.text =  NSLocalizedString(@"Splash Screen Lite Line 2", nil);
#else
    self.thankYouLabel.text = NSLocalizedString(@"Splash Screen Full Title", nil);
    self.line2TextView.text =  NSLocalizedString(@"Splash Screen Full Line 2", nil);
#endif
    
    self.line1TextView.text = NSLocalizedString(@"Welcome 1", nil);
    self.line3TextView.text = NSLocalizedString(@"Splash Screen Line 1", nil);
    self.line4TextView.text = NSLocalizedString(@"Splash Screen Line 3", nil);

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
