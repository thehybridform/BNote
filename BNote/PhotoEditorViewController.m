//
//  PhotoEditorViewController.m
//  BeNote
//
//  Created by Young Kristin on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoEditorViewController.h"
#import "DrawingView.h"
#import "LayerFormater.h"
#import "Photo.h"
#import "BNoteWriter.h"
#import "BNoteAnimation.h"

@interface PhotoEditorViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet DrawingView *drawView;
@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet UIView *buttonsView;
@property (strong, nonatomic) IBOutlet UIView *actionView;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIButton *undoButton;
@property (strong, nonatomic) IBOutlet UIButton *redoButton;
@property (strong, nonatomic) IBOutlet UIButton *smallPencileButton;
@property (strong, nonatomic) IBOutlet UIButton *mediumPencileButton;
@property (strong, nonatomic) IBOutlet UIButton *largePencileButton;
@property (strong, nonatomic) IBOutlet UIButton *color0Button;
@property (strong, nonatomic) IBOutlet UIButton *color1Button;
@property (strong, nonatomic) IBOutlet UIButton *color2Button;
@property (strong, nonatomic) IBOutlet UIButton *color3Button;
@property (strong, nonatomic) IBOutlet UIButton *color4Button;
@property (strong, nonatomic) IBOutlet UIButton *color5Button;
@property (strong, nonatomic) IBOutlet UIButton *color6Button;
@property (strong, nonatomic) IBOutlet UIButton *color7Button;
@property (strong, nonatomic) IBOutlet UIButton *color8Button;
@property (strong, nonatomic) IBOutlet UIButton *color9Button;
@property (strong, nonatomic) IBOutlet UIButton *color10Button;
@property (strong, nonatomic) IBOutlet UIButton *color11Button;
@property (strong, nonatomic) IBOutlet UIButton *color12Button;
@property (strong, nonatomic) IBOutlet UIButton *color13Button;
@property (strong, nonatomic) UIButton *selectedColorButton;
@property (strong, nonatomic) UIButton *selectedPencilButton;
@property (strong, nonatomic) IBOutlet UIView *progressView;
@property (strong, nonatomic) IBOutlet UIView *progressBackgroundView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@end

@implementation PhotoEditorViewController
@synthesize imageView = _imageView;
@synthesize drawView = _drawView;
@synthesize undoButton = _undoButton;
@synthesize redoButton = _redoButton;
@synthesize smallPencileButton = _smallPencileButton;
@synthesize mediumPencileButton = _mediumPencileButton;
@synthesize largePencileButton = _largePencileButton;
@synthesize color0Button = _color0Button;
@synthesize color1Button = _color1Button;
@synthesize color2Button = _color2Button;
@synthesize color3Button = _color3Button;
@synthesize color4Button = _color4Button;
@synthesize color5Button = _color5Button;
@synthesize color6Button = _color6Button;
@synthesize color7Button = _color7Button;
@synthesize color8Button = _color8Button;
@synthesize color9Button = _color9Button;
@synthesize color10Button = _color10Button;
@synthesize color11Button = _color11Button;
@synthesize color12Button = _color12Button;
@synthesize color13Button = _color13Button;
@synthesize keyPoint = _keyPoint;
@synthesize selectedColorButton = _selectedColorButton;
@synthesize selectedPencilButton = _selectedPencilButton;
@synthesize buttonsView = _buttonsView;
@synthesize actionView = _actionView;
@synthesize menuView = _menuView;
@synthesize doneButton = _doneButton;
@synthesize resetButton = _resetButton;
@synthesize progressView = _progressView;
@synthesize progressBackgroundView = _progressBackgroundView;
@synthesize activityView = _activityView;

static const CGFloat small = 5;
static const CGFloat medium = 10;
static const CGFloat large = 20;

static NSString *doneText;
static NSString *undoText;
static NSString *redoText;
static NSString *resetText;

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setImageView:nil];
    [self setDrawView:nil];
    [self setUndoButton:nil];
    [self setRedoButton:nil];
    [self setSmallPencileButton:nil];
    [self setMediumPencileButton:nil];
    [self setLargePencileButton:nil];
    [self setColor0Button:nil];
    [self setColor1Button:nil];
    [self setColor2Button:nil];
    [self setColor3Button:nil];
    [self setColor4Button:nil];
    [self setColor5Button:nil];
    [self setColor6Button:nil];
    [self setColor7Button:nil];
    [self setColor8Button:nil];
    [self setColor9Button:nil];
    [self setColor10Button:nil];
    [self setColor11Button:nil];
    [self setColor12Button:nil];
    [self setColor13Button:nil];
    [self setButtonsView:nil];
    [self setActionView:nil];
    [self setMenuView:nil];
    [self setActionView:nil];
    [self setDoneButton:nil];
    [self setResetButton:nil];
    [self setProgressView:nil];
    [self setProgressBackgroundView:nil];
    [self setActivityView:nil];
}

- (id)initDefault
{
    self = [super initWithNibName:@"PhotoEditorViewController" bundle:nil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    doneText = NSLocalizedString(@"Done", @"Done");
    redoText = NSLocalizedString(@"Redo", @"Redo last action");
    undoText = NSLocalizedString(@"Undo", @"Undo last action");
    resetText = NSLocalizedString(@"Reset", @"Reset image");
    
    [self.doneButton setTitle:doneText forState:UIControlStateNormal];
    [self.redoButton setTitle:redoText forState:UIControlStateNormal];
    [self.undoButton setTitle:undoText forState:UIControlStateNormal];
    [self.resetButton setTitle:resetText forState:UIControlStateNormal];

    [LayerFormater roundCornersForView:[self progressBackgroundView]];
    [[self progressView] setHidden:YES];
    [[self progressView] setBackgroundColor:[UIColor clearColor]];
    [[self view] bringSubviewToFront:[self progressView]];

    [[self view] setBackgroundColor:[UIColor lightGrayColor]];

    [[self drawView] setPhoto:[[self keyPoint] photo]];
    
    UIImage *image = [UIImage imageWithData:[[[self keyPoint] photo] original]];
    [[self imageView] setImage:image];

    [self setupButton:[self color0Button] withColor:[UIColor blackColor]];
    [self setupButton:[self color1Button] withColor:[UIColor darkGrayColor]];
    [self setupButton:[self color2Button] withColor:[UIColor lightGrayColor]];
    [self setupButton:[self color3Button] withColor:[UIColor whiteColor]];
    [self setupButton:[self color4Button] withColor:[UIColor grayColor]];
    [self setupButton:[self color5Button] withColor:[UIColor redColor]];
    [self setupButton:[self color6Button] withColor:[UIColor greenColor]];
    [self setupButton:[self color7Button] withColor:[UIColor blueColor]];
    [self setupButton:[self color8Button] withColor:[UIColor cyanColor]];
    [self setupButton:[self color9Button] withColor:[UIColor yellowColor]];
    [self setupButton:[self color10Button] withColor:[UIColor magentaColor]];
    [self setupButton:[self color11Button] withColor:[UIColor orangeColor]];
    [self setupButton:[self color12Button] withColor:[UIColor purpleColor]];
    [self setupButton:[self color13Button] withColor:[UIColor brownColor]];
    
    [LayerFormater setBorderWidth:2 forView:[self drawView]];
    [LayerFormater setBorderWidth:1 forView:[self menuView]];

    [LayerFormater addShadowToView:[self menuView]];

    [[self view] setBackgroundColor:[BNoteConstants appColor1]];
    [[self buttonsView] setBackgroundColor:[BNoteConstants appColor1]];
    [[self actionView] setBackgroundColor:[BNoteConstants appColor1]];
 
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    [self changeTheViewToPortrait:UIInterfaceOrientationIsPortrait(orientation) andDuration:0.3];
    
    NSArray *views1 = [[NSArray alloc]
                       initWithObjects:
                       [self color0Button],
                       [self color1Button],
                       [self color2Button],
                       [self color3Button],
                       [self color4Button],
                       [self color5Button],
                       [self color6Button],
                       nil];
    NSArray *views4 = [[NSArray alloc]
                       initWithObjects:
                       [self color7Button],
                       [self color8Button],
                       [self color9Button],
                       [self color10Button],
                       [self color11Button],
                       [self color12Button],
                       [self color13Button],
                       nil];
    NSArray *views2 = [[NSArray alloc]
                       initWithObjects:
                       [self smallPencileButton],
                       [self mediumPencileButton],
                       [self largePencileButton],
                       nil];
    NSArray *views3 = [[NSArray alloc]
                       initWithObjects:
                       [self redoButton],
                       [self undoButton],
                       nil];
    [BNoteAnimation winkInView:views1 withDuration:0.05 andDelay:0.8 andDelayIncrement:0.1];
    [BNoteAnimation winkInView:views4 withDuration:0.05 andDelay:0.8 andDelayIncrement:0.1];
    [BNoteAnimation winkInView:views2 withDuration:0.05 andDelay:0.9 andDelayIncrement:0.1];
    [BNoteAnimation winkInView:views3 withDuration:0.05 andDelay:1.0 andDelayIncrement:0.1];
    [BNoteAnimation winkInView:[self imageView] withDuration:0.2 andDelay:0.7];
}

- (void)setupButton:(UIButton *)button withColor:(UIColor *)color
{
    [button setBackgroundColor:color];
    [[button layer] setCornerRadius:7.0];
    [[button layer] setMasksToBounds:YES];
    [[button layer] setBorderWidth:1];
}

- (IBAction)done:(id)sender
{
    [[self progressView] setHidden:NO];
    [[self activityView] startAnimating];
    
    [self performSelector: @selector(finishAndClose)
               withObject: nil
               afterDelay: 0];
}

- (void)finishAndClose
{
    CGRect rect = [[self drawView] bounds];
        
    UIGraphicsBeginImageContext(rect.size);
    [[[self imageView] layer] renderInContext:UIGraphicsGetCurrentContext()];
    [[[self drawView] layer] renderInContext:UIGraphicsGetCurrentContext()];
        
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
    [BNoteEntryUtils updateThumbnailPhotos:image forKeyPoint:[self keyPoint]];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)selectColor:(UIButton *)button
{
    [[button layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[[self selectedColorButton] layer] setBorderWidth:1];
    [self setSelectedColorButton:button];
    [[[self selectedColorButton] layer] setBorderWidth:5];
    
    if (button == [self color0Button]) {
        [[button layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    }
    
    [[self drawView] setStrokeColor:[button backgroundColor]];
}

- (IBAction)selectPencil:(UIButton *)button
{
    [[[self selectedPencilButton] layer] setBorderWidth:0];
    [self setSelectedPencilButton:button];
    [[[self selectedPencilButton] layer] setBorderWidth:5];
    
    if (button == [self smallPencileButton]) {
        [[self drawView] setStrokeWidth:small];
    } else if (button == [self mediumPencileButton]) {
        [[self drawView] setStrokeWidth:medium];
    } else if (button == [self largePencileButton]) {
        [[self drawView] setStrokeWidth:large];
    }
}

- (IBAction)undo:(id)sender
{
    [[self drawView] undoLast];
}

- (IBAction)redo:(id)sender
{
    [[self drawView] redoLast];
}

- (IBAction)reset:(id)sender
{
    [[self drawView] reset];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        //self.view = portraitView;
        [self changeTheViewToPortrait:YES andDuration:duration];
        
    } else if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        //self.view = landscapeView;
        [self changeTheViewToPortrait:NO andDuration:duration];
    }
}

- (void)changeTheViewToPortrait:(BOOL)portrait andDuration:(NSTimeInterval)duration
{
    if (portrait) {
        [UIView animateWithDuration:duration
                         animations:^{
                             CGAffineTransform rotate = CGAffineTransformMakeRotation(90.0 * M_PI / 180.0);
                             CGAffineTransform translate = CGAffineTransformMakeTranslation(300, 400);
                             CGAffineTransform transform = CGAffineTransformConcat(rotate, translate);
                             
                             [[self buttonsView] setTransform:transform];
                             
                             translate = CGAffineTransformMakeTranslation(0, 25);
                             rotate = CGAffineTransformMakeRotation(-90.0 * M_PI / 180.0);
                             transform = CGAffineTransformConcat(rotate, translate);
                             [[self actionView] setTransform:transform];
                             
                         }
                         completion:^(BOOL finished){ }];
    } else {   
        [UIView animateWithDuration:duration
                         animations:^{
                             [[self buttonsView] setTransform:CGAffineTransformIdentity];
                             [[self actionView] setTransform:CGAffineTransformIdentity];
                         }
                         completion:^(BOOL finished){ }];
    }
}

@end
