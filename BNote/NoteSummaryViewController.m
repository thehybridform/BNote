//
//  NoteSummaryViewController.m
//  BeNote
//
//  Created by kristin young on 7/31/12.
//
//

#import "NoteSummaryViewController.h"
#import "LayerFormater.h"
#import "Note.h"
#import "QuickWordsViewController.h"

@interface NoteSummaryViewController ()
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UILabel *summaryLabel;
@property (strong, nonatomic) Note *note;
@property (strong, nonatomic) QuickWordsViewController *quickWordsViewController;

@end

@implementation NoteSummaryViewController
@synthesize textView = _textView;
@synthesize note = _note;
@synthesize summaryLabel = _summaryLabel;
@synthesize quickWordsViewController = _quickWordsViewController;

- (id)initWithNote:(Note *)note
{
    self = [super initWithNibName:@"NoteSummaryViewController" bundle:nil];
    
    if (self) {
        [self setNote:note];

        UITableViewCell *cell = (UITableViewCell *) [self view];
        [cell setEditingAccessoryType:UITableViewCellEditingStyleNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [LayerFormater roundCornersForView:cell];
        [LayerFormater setBorderColor:UIColorFromRGB([note color]) forView:cell];
        [LayerFormater setBorderWidth:2 forView:cell];

        UITextView *view = [self mainTextView];
        
        [view setFont:[BNoteConstants font:RobotoRegular andSize:16]];
        [view setTextColor:UIColorFromRGB(0x444444)];
        [view setClipsToBounds:YES];
        [view setText:[[self note] summary]];
        
        [LayerFormater roundCornersForView:view];
        [LayerFormater setBorderColor:[BNoteConstants appHighlightColor1] forView:view];
        
        QuickWordsViewController *quick = [[QuickWordsViewController alloc] initWithEntryContent:self];
        [self setQuickWordsViewController:quick];
        [view setInputAccessoryView:[quick view]];
        
        [[self summaryLabel] setFont:[BNoteConstants font:RobotoBold andSize:15]];
        [[self summaryLabel] setTextColor:[BNoteConstants appHighlightColor1]];
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UITextView *view = [self mainTextView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateText:)
                                                 name:UITextViewTextDidChangeNotification object:view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stoppedEditingText:)
                                                 name:UITextViewTextDidEndEditingNotification object:view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startedEditingText:)
                                                 name:UITextViewTextDidBeginEditingNotification object:view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setTextView:nil];
    [self setSummaryLabel:nil];

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

- (void)startedEditingText:(NSNotification *)notification
{
    if ([notification object] == [self textView]) {
//        [[self mainTextView] setClipsToBounds:NO];
        [[self quickWordsViewController] selectFirstButton];
    }
}

- (void)stoppedEditingText:(NSNotification *)notification
{
    if ([notification object] == [self mainTextView]) {
//        [[self mainTextView] setClipsToBounds:YES];
    }
}

- (void)updateText:(NSNotification *)notification
{
    if ([notification object] == [self textView]) {
        NSString *text = [[self mainTextView] text];
        if ([BNoteStringUtils nilOrEmpty:text]) {
            [[self note] setSummary:nil];
        } else {
            [[self note] setSummary:text];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
