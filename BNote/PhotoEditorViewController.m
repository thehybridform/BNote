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
@property (assign, nonatomic) UIButton *selectedColorButton;
@property (assign, nonatomic) UIButton *selectedPencilButton;

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

static const CGFloat small = 5;
static const CGFloat medium = 10;
static const CGFloat large = 20;

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

    [[self view] setBackgroundColor:[BNoteConstants appColor1]];
    [[self buttonsView] setBackgroundColor:[BNoteConstants appColor1]];
    [[self actionView] setBackgroundColor:[BNoteConstants appColor1]];
 
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    [self changeTheViewToPortrait:UIInterfaceOrientationIsPortrait(orientation) andDuration:0.3];
}

- (void)setupButton:(UIButton *)button withColor:(UIColor *)color
{
    [button setBackgroundColor:color];
    [[button layer] setCornerRadius:7.0];
    [[button layer] setMasksToBounds:YES];
    [[button layer] setBorderWidth:1];
}

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
    [self setSelectedColorButton:nil];
    [self setButtonsView:nil];
    [self setActionView:nil];
    [self setMenuView:nil];
    [self setActionView:nil];
    [self setDoneButton:nil];
    [self setResetButton:nil];
}

- (IBAction)done:(id)sender
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
