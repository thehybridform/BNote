//
//  NoteSummaryViewController.m
//  BeNote
//
//  Created by kristin young on 7/31/12.
//
//

#import "NoteSummaryViewController.h"
#import "LayerFormater.h"
#import "QuickWordsViewController.h"

@interface NoteSummaryViewController ()
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UILabel *summaryLabel;
@property (strong, nonatomic) Note *note;
@property (strong, nonatomic) QuickWordsViewController *quickWordsViewController;
@property (strong, nonatomic) IBOutlet UIView *borderView;

@end

@implementation NoteSummaryViewController
@synthesize textView = _textView;
@synthesize note = _note;
@synthesize summaryLabel = _summaryLabel;
@synthesize quickWordsViewController = _quickWordsViewController;
@synthesize borderView = _borderView;

- (id)initWithNote:(Note *)note
{
    self = [super initWithNibName:@"NoteSummaryViewController" bundle:nil];
    
    if (self) {
        [self setNote:note];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableViewCell *cell = (UITableViewCell *) [self view];
    [cell setEditingAccessoryType:(UITableViewCellAccessoryType) UITableViewCellEditingStyleNone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [LayerFormater roundCornersForView:cell];
    [LayerFormater roundCornersForView:self.borderView];
    [LayerFormater setBorderColor:UIColorFromRGB(self.note.color) forView:self.borderView];
    [LayerFormater setBorderWidth:2 forView:self.borderView];
    [LayerFormater setBorderWidth:0 forView:cell];
    
    UITextView *view = self.textView;
    view.delegate = self;

    [view setFont:[BNoteConstants font:RobotoRegular andSize:16]];
    [view setTextColor:UIColorFromRGB(0x444444)];
    [view setClipsToBounds:YES];
    [view setText:[[self note] summary]];
    
    [LayerFormater roundCornersForView:view];
    [LayerFormater setBorderColor:[BNoteConstants appHighlightColor1] forView:view];

    [self reset];

    [[self summaryLabel] setFont:[BNoteConstants font:RobotoRegular andSize:15]];
    self.summaryLabel.textColor = UIColorFromRGB(0x444444);

    self.summaryLabel.text = NSLocalizedString(@"Note Summary", @"Note summary title");
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setTextView:nil];
    [self setSummaryLabel:nil];
    self.borderView = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (Entry *)entry
{
    return nil;
}

- (UITextView *)selectedTextView
{
    return [self textView];
}

- (UITextView *)mainTextView
{
    return [self textView];
}

- (UIImageView *)iconView
{
    return nil;
}

- (UITableViewCell *)cell
{
    return (UITableViewCell *) [self view];
}

- (float)height
{
    UITextView *view = [[UITextView alloc] init];
    [view setText:[[self note] summary]];
    [view setFont:[BNoteConstants font:RobotoRegular andSize:16]];
    [view setFrame:CGRectMake(0, 0, [self width] - 100, 50)];
    
    return MAX(100, [view contentSize].height + 10);
}

- (float)width
{
    float width = 900;
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsPortrait(orientation)) {
        width = 600;
    }
    
    return width;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView setScrollEnabled:YES];
    [[self quickWordsViewController] selectFirstButton];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView setScrollEnabled:NO];
    NSString *text = [BNoteStringUtils trim:textView.text];
    if ([BNoteStringUtils nilOrEmpty:text]) {
        [[self note] setSummary:nil];
    } else {
        [[self note] setSummary:text];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)detachFromNotificationCenter
{
}

- (void)reset
{
    [self.textView resignFirstResponder];

    QuickWordsViewController *quick = [[QuickWordsViewController alloc] initWithEntryContent:self];
    [self setQuickWordsViewController:quick];
    [self.textView setInputAccessoryView:[quick view]];
}

@end
