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
@property (assign, nonatomic) Note *note;
@property (strong, nonatomic) QuickWordsViewController *quickWordsViewController;

@end

@implementation NoteSummaryViewController
@synthesize textView = _textView;
@synthesize note = _note;
@synthesize parentController = _parentController;
@synthesize summaryLabel = _summaryLabel;
@synthesize quickWordsViewController = _quickWordsViewController;

- (id)initWithNote:(Note *)note
{
    self = [super initWithNibName:@"NoteSummaryViewController" bundle:nil];
    
    if (self) {
        [self setNote:note];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateText:)
                                                     name:UITextViewTextDidChangeNotification object:[self textView]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startedEditingText:)
                                                     name:UITextViewTextDidBeginEditingNotification object:[self textView]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[self summaryLabel] setFont:[BNoteConstants font:RobotoBold andSize:15]];
    [[self summaryLabel] setTextColor:[BNoteConstants appHighlightColor1]];
    
    UITextView *view = [self textView];
    
    [view setFont:[BNoteConstants font:RobotoRegular andSize:16]];
    [view setTextColor:UIColorFromRGB(0x444444)];
    [view setClipsToBounds:YES];
    [view setText:[[self note] summary]];
    
    [LayerFormater roundCornersForView:view];
    [LayerFormater setBorderColor:[BNoteConstants appHighlightColor1] forView:view];
    
    QuickWordsViewController *quick = [[QuickWordsViewController alloc] initWithEntryContent:self];
    [self setQuickWordsViewController:quick];
    [view setInputAccessoryView:[quick view]];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setTextView:nil];
    [self setSummaryLabel:nil];
}

- (void)dealloc
{
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
    return 100;
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
        [[self quickWordsViewController] selectFirstButton];
    }
}

- (void)updateText:(NSNotification *)notification
{
    if ([notification object] == [self textView]) {
        NSString *text = [[self mainTextView] text];
        if ([BNoteStringUtils nilOrEmpty:text]) {
            [[self note] setSubject:nil];
        } else {
            [[self note] setSubject:text];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
