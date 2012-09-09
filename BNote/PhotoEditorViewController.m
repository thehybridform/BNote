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
#import "BNoteAnimation.h"
#import "ButtonPair.h"

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

@property (strong, nonatomic) IBOutlet UIView *shadowView0;
@property (strong, nonatomic) IBOutlet UIView *shadowView1;
@property (strong, nonatomic) IBOutlet UIView *shadowView2;
@property (strong, nonatomic) IBOutlet UIView *shadowView3;
@property (strong, nonatomic) IBOutlet UIView *shadowView4;
@property (strong, nonatomic) IBOutlet UIView *shadowView5;
@property (strong, nonatomic) IBOutlet UIView *shadowView6;
@property (strong, nonatomic) IBOutlet UIView *shadowView7;
@property (strong, nonatomic) IBOutlet UIView *shadowView8;
@property (strong, nonatomic) IBOutlet UIView *shadowView9;
@property (strong, nonatomic) IBOutlet UIView *shadowView10;
@property (strong, nonatomic) IBOutlet UIView *shadowView11;
@property (strong, nonatomic) IBOutlet UIView *shadowView12;
@property (strong, nonatomic) IBOutlet UIView *shadowView13;

@property (strong, nonatomic) NSMutableArray *buttons;

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

@synthesize shadowView0 = _shadowView0;
@synthesize shadowView1 = _shadowView1;
@synthesize shadowView2 = _shadowView2;
@synthesize shadowView3 = _shadowView3;
@synthesize shadowView4 = _shadowView4;
@synthesize shadowView5 = _shadowView5;
@synthesize shadowView6 = _shadowView6;
@synthesize shadowView7 = _shadowView7;
@synthesize shadowView8 = _shadowView8;
@synthesize shadowView9 = _shadowView9;
@synthesize shadowView10 = _shadowView10;
@synthesize shadowView11 = _shadowView11;
@synthesize shadowView12 = _shadowView12;
@synthesize shadowView13 = _shadowView13;

@synthesize buttons = _buttons;

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
    
    self.shadowView0 = nil;
    self.shadowView1 = nil;
    self.shadowView2 = nil;
    self.shadowView3 = nil;
    self.shadowView4 = nil;
    self.shadowView5 = nil;
    self.shadowView6 = nil;
    self.shadowView7 = nil;
    self.shadowView8 = nil;
    self.shadowView9 = nil;
    self.shadowView10 = nil;
    self.shadowView11 = nil;
    self.shadowView12 = nil;
    self.shadowView13 = nil;
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
    [LayerFormater setBorderColor:UIColorFromRGB(0x444444) forView:[self imageView]];
    [LayerFormater setBorderColor:UIColorFromRGB(0x444444) forView:[self drawView]];
    [LayerFormater setBorderColor:[BNoteConstants darkGray] forView:[self menuView]];

    [LayerFormater addShadowToView:[self menuView]];
    
    [LayerFormater addShadowToView:self.shadowView0 ofSize:7];
    [LayerFormater addShadowToView:self.shadowView1 ofSize:7];
    [LayerFormater addShadowToView:self.shadowView2 ofSize:7];
    [LayerFormater addShadowToView:self.shadowView3 ofSize:7];
    [LayerFormater addShadowToView:self.shadowView4 ofSize:7];
    [LayerFormater addShadowToView:self.shadowView5 ofSize:7];
    [LayerFormater addShadowToView:self.shadowView6 ofSize:7];
    [LayerFormater addShadowToView:self.shadowView7 ofSize:7];
    [LayerFormater addShadowToView:self.shadowView8 ofSize:7];
    [LayerFormater addShadowToView:self.shadowView9 ofSize:7];
    [LayerFormater addShadowToView:self.shadowView10 ofSize:7];
    [LayerFormater addShadowToView:self.shadowView11 ofSize:7];
    [LayerFormater addShadowToView:self.shadowView12 ofSize:7];
    [LayerFormater addShadowToView:self.shadowView13 ofSize:7];

    [LayerFormater addShadowToView:[self smallPencileButton]];
    [LayerFormater addShadowToView:[self mediumPencileButton]];
    [LayerFormater addShadowToView:[self largePencileButton]];

    [[self buttonsView] setBackgroundColor:[UIColor clearColor]];
    [[self actionView] setBackgroundColor:[UIColor clearColor]];
    self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);

    [self updateViewOrientation];
    
    NSArray *views1 = [[NSArray alloc]
                       initWithObjects:
                       [self color0Button],
                       [self color1Button],
                       [self color2Button],
                       [self color3Button],
                       [self color4Button],
                       [self color5Button],
                       [self color6Button],
                       
                       self.shadowView0,
                       self.shadowView1,
                       self.shadowView2,
                       self.shadowView3,
                       self.shadowView4,
                       self.shadowView5,
                       self.shadowView6,
                       
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
                       
                       self.shadowView7,
                       self.shadowView8,
                       self.shadowView9,
                       self.shadowView10,
                       self.shadowView11,
                       self.shadowView12,
                       self.shadowView13,

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
    [BNoteAnimation winkInView:views1 withDuration:0.05 andDelay:0.8 andDelayIncrement:0.1 spark:NO];
    [BNoteAnimation winkInView:views4 withDuration:0.05 andDelay:0.8 andDelayIncrement:0.1 spark:NO];
    [BNoteAnimation winkInView:views2 withDuration:0.05 andDelay:0.9 andDelayIncrement:0.1 spark:NO];
    [BNoteAnimation winkInView:views3 withDuration:0.05 andDelay:1.0 andDelayIncrement:0.1 spark:NO];
    [BNoteAnimation winkInView:[self imageView] withDuration:0.2 andDelay:0.7 spark:NO];
    
    [self selectPencil:self.smallPencileButton];
    [self selectColor:self.color11Button];
    
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    self.buttons = buttons;
    
    [self button:self.color0Button paired:self.shadowView0];
    [self button:self.color1Button paired:self.shadowView1];
    [self button:self.color2Button paired:self.shadowView2];
    [self button:self.color3Button paired:self.shadowView3];
    [self button:self.color4Button paired:self.shadowView4];
    [self button:self.color5Button paired:self.shadowView5];
    [self button:self.color6Button paired:self.shadowView6];
    [self button:self.color7Button paired:self.shadowView7];
    [self button:self.color8Button paired:self.shadowView8];
    [self button:self.color9Button paired:self.shadowView9];
    [self button:self.color10Button paired:self.shadowView10];
    [self button:self.color11Button paired:self.shadowView11];
    [self button:self.color12Button paired:self.shadowView12];
    [self button:self.color13Button paired:self.shadowView13];
}

- (void)button:(UIButton *)button paired:(UIView *)view
{
    ButtonPair *pair = [[ButtonPair alloc] init];
    pair.colorButton = button;
    pair.shadowView = view;
    
    [self.buttons addObject:pair];
}

- (UIView *)shadowFor:(UIButton *)button
{
    for (ButtonPair *pair in self.buttons) {
        if (pair.colorButton == button) {
            return pair.shadowView;
        }
    }
    
    return nil;
}

- (void)setupButton:(UIButton *)button withColor:(UIColor *)color
{
    [button setBackgroundColor:color];
    [[button layer] setCornerRadius:7.0];
    [[button layer] setMasksToBounds:YES];
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
    static int offset = 7;
    
    UIButton *currentButton = self.selectedColorButton;
    
    if (currentButton) {
        [self view:currentButton resize:-offset];
    
        UIView *shadow = [self shadowFor:currentButton];
        [self view:shadow resize:-offset];
    }

    [self setSelectedColorButton:button];
    
    [self view:button resize:offset];

    UIView *shadow = [self shadowFor:button];
    [self view:shadow resize:offset];

    [[self drawView] setStrokeColor:[button backgroundColor]];
}

- (void)view:(UIView *)view resize:(int)offset
{
    CGRect frame = view.frame;
    view.frame = CGRectMake(frame.origin.x - offset, frame.origin.y - offset, frame.size.width + 2 * offset, frame.size.height + 2 * offset);
}

- (IBAction)selectPencil:(UIButton *)button
{
    static int offset = 7;
    
    UIButton *currentButton = self.selectedPencilButton;
    
    if (currentButton) {
        [self view:currentButton resize:-offset];
    }
    
    [self setSelectedPencilButton:button];

    [self view:button resize:offset];

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

    self.buttonsView.alpha = 0.0;
    self.actionView.alpha = 0.0;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    [self updateViewOrientation];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.buttonsView.alpha = 1.0;
        self.actionView.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}

- (void)updateViewOrientation
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    BOOL portrait = UIInterfaceOrientationIsPortrait(orientation);

    if (portrait) {
        CGAffineTransform rotate = CGAffineTransformMakeRotation(90.0 * M_PI / 180.0);
        CGAffineTransform translate = CGAffineTransformMakeTranslation(300, 400);
        CGAffineTransform transform = CGAffineTransformConcat(rotate, translate);
                             
        [[self buttonsView] setTransform:transform];
                             
        translate = CGAffineTransformMakeTranslation(0, 25);
        rotate = CGAffineTransformMakeRotation(-90.0 * M_PI / 180.0);
        transform = CGAffineTransformConcat(rotate, translate);
        [[self actionView] setTransform:transform];

    } else {
        [[self buttonsView] setTransform:CGAffineTransformIdentity];
        [[self actionView] setTransform:CGAffineTransformIdentity];
    }
}

@end
