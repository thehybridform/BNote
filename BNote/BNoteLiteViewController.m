//
//  BNoteLiteViewController.m
//  BeNote
//
//  Created by kristin young on 8/4/12.
//
//

#import "BNoteLiteViewController.h"
#import "BNoteDefaultData.h"
#import "BNoteReader.h"
#import "ShowHelpProtocol.h"
#import "BNoteSessionData.h"

@interface BNoteLiteViewController ()
@property (strong, nonatomic) IBOutlet UILabel *thankYouLabel;
@property (strong, nonatomic) IBOutlet UILabel *uobiaLabel;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property (strong, nonatomic) IBOutlet UITextView *line1TextView;
@property (strong, nonatomic) IBOutlet UITextView *line2TextView;
@property (strong, nonatomic) IBOutlet UITextView *line3TextView;
@property (strong, nonatomic) IBOutlet UITextView *line4TextView;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIButton *helpNotesButton;

@end

@implementation BNoteLiteViewController
@synthesize thankYouLabel = _thankYouLabel;
@synthesize line1TextView = _line1TextView;
@synthesize line2TextView = _line2TextView;
@synthesize line3TextView = _line3TextView;
@synthesize line4TextView = _line4TextView;
@synthesize closeButton = _closeButton;
@synthesize topicGroupSelector = _topicGroupSelector;
@synthesize firstLoad = _firstLoad;
@synthesize uobiaLabel = _uobiaLabel;
@synthesize helpNotesButton = _helpNotesButton;
@synthesize versionLabel = _versionLabel;
@synthesize helpDelegate = _helpDelegate;

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.thankYouLabel = nil;
    self.line1TextView = nil;
    self.line2TextView = nil;
    self.line3TextView = nil;
    self.line4TextView = nil;
    self.closeButton = nil;
    self.helpNotesButton = nil;
    self.versionLabel = nil;
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
    if (self.firstLoad) {
        [BNoteDefaultData setup];
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefetchAllDatabaseData object:nil];
        [self dismissViewControllerAnimated:YES completion:^{
            [self.helpDelegate showHelp];
        }];

        [BNoteSessionData setBoolean:YES forKey:kFirstLoad];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.closeButton setTitle:NSLocalizedString(@"Close", @"Close current window") forState:UIControlStateNormal];
    [self.helpNotesButton setTitle:NSLocalizedString(@"Generate Help Notes", nil) forState:UIControlStateNormal];

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
        self.helpNotesButton.hidden = YES;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
