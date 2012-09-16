//
//  HelpViewController.m
//  BeNote
//
//  Created by kristin young on 9/16/12.
//
//

#import "HelpViewController.h"

@interface HelpViewController()

@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSString *key;

@end

@implementation HelpViewController
@synthesize textView = _textView;

- (id)initWithKey:(NSString *)key
{
    self = [super initWithNibName:@"HelpViewController" bundle:nil];

    if (self) {
        self.key = key;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.textView.text = NSLocalizedString(self.key, nil);
    self.textView.textColor = [BNoteConstants appHighlightColor1];
    self.textView.font = [BNoteConstants font:RobotoRegular andSize:15];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.textView = nil;
}

@end
