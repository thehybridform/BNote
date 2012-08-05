//
//  BNoteLiteViewController.m
//  BeNote
//
//  Created by kristin young on 8/4/12.
//
//

#import "BNoteLiteViewController.h"
#import "BNoteSessionData.h"

@interface BNoteLiteViewController ()
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation BNoteLiteViewController
@synthesize textView = _textView;
@synthesize okButton = _okButton;

- (id)initWithDefault
{
    self = [super initWithNibName:@"BNoteLiteViewController" bundle:nil];
    if (self) {

    }
    return self;
}

- (IBAction)done:(id)sender
{
    [BNoteSessionData setBoolean:YES forKey:EulaFlag];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[self textView] setFont:[BNoteConstants font:RobotoRegular andSize:20]];
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
