//
//  NoteSummaryViewController.m
//  BeNote
//
//  Created by kristin young on 7/31/12.
//
//

#import "NoteSummaryViewController.h"
#import "LayerFormater.h"

@interface NoteSummaryViewController ()
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

@implementation NoteSummaryViewController
@synthesize textView = _textView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {

    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setTextView:nil];
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

- (void)setParentController:(UIViewController *)controller
{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
