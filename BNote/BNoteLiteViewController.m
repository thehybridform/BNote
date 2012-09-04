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
#import "BNoteReader.h"

@interface BNoteLiteViewController ()
@property (strong, nonatomic) IBOutlet UILabel *thankYouLabel;
@property (strong, nonatomic) IBOutlet UILabel *uobiaLabel;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property (strong, nonatomic) IBOutlet UITextView *line1TextView;
@property (strong, nonatomic) IBOutlet UITextView *line2TextView;
@property (strong, nonatomic) IBOutlet UITextView *line3TextView;
@property (strong, nonatomic) IBOutlet UITextView *line4TextView;
@property (strong, nonatomic) IBOutlet UIButton *okButton;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIButton *helpNotesButton;
@property (strong, nonatomic) IBOutlet UIButton *licenseButton;

@end

@implementation BNoteLiteViewController
@synthesize thankYouLabel = _thankYouLabel;
@synthesize line1TextView = _line1TextView;
@synthesize line2TextView = _line2TextView;
@synthesize line3TextView = _line3TextView;
@synthesize line4TextView = _line4TextView;
@synthesize okButton = _okButton;
@synthesize closeButton = _closeButton;
@synthesize topicGroupSelector = _topicGroupSelector;
@synthesize firstLoad = _firstLoad;
@synthesize uobiaLabel = _uobiaLabel;
@synthesize helpNotesButton = _helpNotesButton;
@synthesize versionLabel = _versionLabel;
@synthesize licenseButton = _licenseButton;

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.thankYouLabel = nil;
    self.line1TextView = nil;
    self.line2TextView = nil;
    self.line3TextView = nil;
    self.line4TextView = nil;
    self.okButton = nil;
    self.closeButton = nil;
    self.helpNotesButton = nil;
    self.versionLabel = _versionLabel;
    self.licenseButton = nil;
}

- (id)initWithDefault
{
    self = [super initWithNibName:@"BNoteLiteViewController" bundle:nil];
    if (self) {
        self.firstLoad = YES;
    }
    return self;
}

- (IBAction)close:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    
    if (self.firstLoad) {
        [BNoteDefaultData setup];
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefetchAllDatabaseData object:nil];
    }
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
    
    self.uobiaLabel.text = NSLocalizedString(@"A musing of Uobia, Copyright 2012", nil);
    
    self.thankYouLabel.font = [BNoteConstants font:RobotoRegular andSize:20];
    self.uobiaLabel.font = [BNoteConstants font:RobotoRegular andSize:14];
    self.line1TextView.font = [BNoteConstants font:RobotoRegular andSize:14];
    self.line2TextView.font = [BNoteConstants font:RobotoRegular andSize:14];
    self.line3TextView.font = [BNoteConstants font:RobotoRegular andSize:14];
    self.line4TextView.font = [BNoteConstants font:RobotoRegular andSize:14];
    self.versionLabel.font = [BNoteConstants font:RobotoRegular andSize:12];

    self.thankYouLabel.textColor = [BNoteConstants appHighlightColor1];
    self.uobiaLabel.textColor = [BNoteConstants appHighlightColor1];
    self.line1TextView.textColor = [BNoteConstants appHighlightColor1];
    self.line2TextView.textColor = [BNoteConstants appHighlightColor1];
    self.line3TextView.textColor = [BNoteConstants appHighlightColor1];
    self.line4TextView.textColor = [BNoteConstants appHighlightColor1];
    self.versionLabel.textColor = [BNoteConstants appHighlightColor1];

#ifdef LITE
    self.versionLabel.text = @"BeNote Lite Version 1.0";
#else
    self.versionLabel.text = @"BeNote Version 1.0";
#endif


    if (self.firstLoad) {
        [[self closeButton] setHidden:YES];
        self.helpNotesButton.hidden = YES;
        self.licenseButton.hidden = YES;
    } else {
        [[self closeButton] setHidden:NO];
        [[self okButton] setHidden:YES];
    }
    
}

- (IBAction)generateHelpNotes:(id)sender
{
    [BNoteDefaultData setup];

    [self dismissViewControllerAnimated:YES completion:^{
        if (self.topicGroupSelector) {
            TopicGroup *group = [[BNoteReader instance] getTopicGroup:kAllTopicGroupName];
            [self.topicGroupSelector selectTopicGroup:group];
        }
    }];
}

- (IBAction)openGoolePlus:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    NSURL *url = [NSURL URLWithString:@"http://plus.google.com/113838676367829565073/"];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)showLicense:(id)sender
{
    EluaViewController *controller = [[EluaViewController alloc] initWithDefault];
    [controller setModalInPopover:YES];
    [controller setModalPresentationStyle:UIModalPresentationPageSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self presentModalViewController:controller animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
