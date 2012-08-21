//
//  TopicEditorViewController.m
//  BNote
//
//  Created by Young Kristin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopicEditorViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BNoteFactory.h"
#import "BNoteWriter.h"
#import "LayerFormater.h"
#import "BNoteSessionData.h"

@interface TopicEditorViewController ()
@property (strong, nonatomic) IBOutlet UIView *buttonControlView;
@property (strong, nonatomic) IBOutlet UIButton *selectedColorButton;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UIButton *buttonAction;
@property (strong, nonatomic) IBOutlet UILabel *menuLabel;

@property (strong, nonatomic) IBOutlet UIButton *button_1;
@property (strong, nonatomic) IBOutlet UIButton *button_2;
@property (strong, nonatomic) IBOutlet UIButton *button_3;
@property (strong, nonatomic) IBOutlet UIButton *button_4;
@property (strong, nonatomic) IBOutlet UIButton *button_5;
@property (strong, nonatomic) IBOutlet UIButton *button_6;
@property (strong, nonatomic) IBOutlet UIButton *button_7;
@property (strong, nonatomic) IBOutlet UIButton *button_8;
@property (strong, nonatomic) IBOutlet UIButton *button_9;
@property (assign, nonatomic) int selectedColor;

@property (strong, nonatomic) TopicGroup *topicGroup;

@property (strong, nonatomic) IBOutlet UIView *shadowView1;
@property (strong, nonatomic) IBOutlet UIView *shadowView2;
@property (strong, nonatomic) IBOutlet UIView *shadowView3;
@property (strong, nonatomic) IBOutlet UIView *shadowView4;
@property (strong, nonatomic) IBOutlet UIView *shadowView5;
@property (strong, nonatomic) IBOutlet UIView *shadowView6;
@property (strong, nonatomic) IBOutlet UIView *shadowView7;
@property (strong, nonatomic) IBOutlet UIView *shadowView8;
@property (strong, nonatomic) IBOutlet UIView *shadowView9;
@property (assign, nonatomic) BOOL canDismiss;

@end

@implementation TopicEditorViewController

@synthesize nameTextField = _nameTextField;
@synthesize topic = _topic;
@synthesize buttonAction = _buttonAction;
@synthesize button_1 = _button_1;
@synthesize button_2 = _button_2;
@synthesize button_3 = _button_3;
@synthesize button_4 = _button_4;
@synthesize button_5 = _button_5;
@synthesize button_6 = _button_6;
@synthesize button_7 = _button_7;
@synthesize button_8 = _button_8;
@synthesize button_9 = _button_9;
@synthesize selectedColorButton = _selectedColorButton;
@synthesize selectedColor = _selectedColor;
@synthesize buttonControlView = _buttonControlView;
@synthesize popup = _popup;
@synthesize topicGroup = _topicGroup;
@synthesize menuLabel = _menuLabel;

@synthesize shadowView1 = _shadowView1;
@synthesize shadowView2 = _shadowView2;
@synthesize shadowView3 = _shadowView3;
@synthesize shadowView4 = _shadowView4;
@synthesize shadowView5 = _shadowView5;
@synthesize shadowView6 = _shadowView6;
@synthesize shadowView7 = _shadowView7;
@synthesize shadowView8 = _shadowView8;
@synthesize shadowView9 = _shadowView9;
@synthesize canDismiss = _canDismiss;


static NSString *createText;
static NSString *updateText;
static NSString *addTopicText;
static NSString *editTopicText;
static NSString *placeHolderText;


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setButtonControlView:nil];
    
    [self setButtonAction:nil];
    [self setNameTextField:nil];
    [self setSelectedColorButton:nil];
    
    [self setButton_1:nil];
    [self setButton_2:nil];
    [self setButton_3:nil];
    [self setButton_4:nil];
    [self setButton_5:nil];
    [self setButton_6:nil];
    [self setButton_7:nil];
    [self setButton_8:nil];
    [self setButton_9:nil];
    self.menuLabel = nil;
    
    self.shadowView1 = nil;
    self.shadowView2 = nil;
    self.shadowView3 = nil;
    self.shadowView4 = nil;
    self.shadowView5 = nil;
    self.shadowView6 = nil;
    self.shadowView7 = nil;
    self.shadowView8 = nil;
    self.shadowView9 = nil;
}

- (id)initWithTopicGroup:(TopicGroup *)group
{
    self = [super initWithNibName:@"TopicEditorViewController" bundle:nil];
    
    if (self) {
        [self setTopicGroup:group];
    }
    
    createText = NSLocalizedString(@"Create", @"Commit create.");
    updateText = NSLocalizedString(@"Update", @"Commit update.");
    addTopicText = NSLocalizedString(@"Add Topic", @"Add Topic text.");
    editTopicText = NSLocalizedString(@"Edit Topic", @"Edit Topic text.");
    placeHolderText = NSLocalizedString(@"Type in a new Topic Title", @"New top place holder text.");

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initButton:[self selectedColorButton] withColor:kColorWhite];

    if ([self topic]) {
        [[self view] setBackgroundColor:UIColorFromRGB([[self topic] color])];
        [self setSelectedColor:[[self topic] color]];
        [[self nameTextField] setText:[[self topic] title]];
        self.menuLabel.text = editTopicText;
    } else {
        [self setSelectedColor:kColor1];
        [[self view] setBackgroundColor:UIColorFromRGB(kColor1)];
        self.menuLabel.text = addTopicText;
    }
    
    [self initButton:[self button_1] withColor:kColor1];
    [self initButton:[self button_2] withColor:kColor2];
    [self initButton:[self button_3] withColor:kColor3];
    [self initButton:[self button_4] withColor:kColor4];
    [self initButton:[self button_5] withColor:kColor5];
    [self initButton:[self button_6] withColor:kColor6];
    [self initButton:[self button_7] withColor:kColor7];
    [self initButton:[self button_8] withColor:kColor8];
    [self initButton:[self button_9] withColor:kColor9];
    
    [LayerFormater setBorderWidth:1 forView:[self buttonControlView]];
    [LayerFormater setBorderColor:[BNoteConstants darkGray] forView:[self buttonControlView]];
    [LayerFormater addShadowToView:[self buttonControlView]];

    [LayerFormater addShadowToView:[self shadowView1]];
    [LayerFormater addShadowToView:[self shadowView2]];
    [LayerFormater addShadowToView:[self shadowView3]];
    [LayerFormater addShadowToView:[self shadowView4]];
    [LayerFormater addShadowToView:[self shadowView5]];
    [LayerFormater addShadowToView:[self shadowView6]];
    [LayerFormater addShadowToView:[self shadowView7]];
    [LayerFormater addShadowToView:[self shadowView8]];
    [LayerFormater addShadowToView:[self shadowView9]];

    [[self nameTextField] setDelegate:self];
    [[self nameTextField] becomeFirstResponder];

    self.menuLabel.font = [BNoteConstants font:RobotoBold andSize:15];
    self.menuLabel.textColor = [BNoteConstants appHighlightColor1];
    
    self.nameTextField.placeholder = placeHolderText;
}

- (void)setPopup:(UIPopoverController *)popup
{
    _popup = popup;
    
    popup.delegate = self;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [[BNoteSessionData instance] setPopup:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)done:(id)sender
{
    NSString *title = [[self nameTextField] text];
    
    if (![BNoteStringUtils nilOrEmpty:title]) {
        Topic *topic = [self topic];
        if (!topic) {
            topic = [BNoteFactory createTopic:title forGroup:[self topicGroup]]; 
        }
    
        [topic setTitle:title];

        [topic setColor:[self selectedColor]];
        
        for (Note *note in [topic notes]) {
            [note setColor:[self selectedColor]];
        }
        
        [[BNoteWriter instance] update];

        [[NSNotificationCenter defaultCenter] postNotificationName:kTopicGroupSelected object:[self topicGroup]];
    }

    [[self nameTextField] resignFirstResponder];
    [[self popup] dismissPopoverAnimated:YES];
}

- (IBAction)cancel:(id)sender
{
    [[self popup] dismissPopoverAnimated:YES];
}

- (void)initButton:(UIButton *)button withColor:(int)color
{
    [button setBackgroundColor:UIColorFromRGB(color)];
    [[button layer] setCornerRadius:7.0];
    [[button layer] setMasksToBounds:YES];
}

- (void)updateHighlightColor:(UIButton *)button
{
    UIColor *color = [button backgroundColor];

    [[self view] setBackgroundColor:color];
}

- (IBAction)color1Selected:(id)sender
{
    [self updateHighlightColor:(UIButton *) sender];
    [self setSelectedColor:kColor1];
}

- (IBAction)color2Selected:(id)sender
{
    [self updateHighlightColor:(UIButton *) sender];
    [self setSelectedColor:kColor2];
}

- (IBAction)color3Selected:(id)sender
{
    [self updateHighlightColor:(UIButton *) sender];
    [self setSelectedColor:kColor3];
}

- (IBAction)color4Selected:(id)sender
{
    [self updateHighlightColor:(UIButton *) sender];
    [self setSelectedColor:kColor4];
}

- (IBAction)color5Selected:(id)sender
{
    [self updateHighlightColor:(UIButton *) sender];
    [self setSelectedColor:kColor5];
}

- (IBAction)color6Selected:(id)sender
{
    [self updateHighlightColor:(UIButton *) sender];
    [self setSelectedColor:kColor6];
}

- (IBAction)color7Selected:(id)sender
{
    [self updateHighlightColor:(UIButton *) sender];
    [self setSelectedColor:kColor7];
}

- (IBAction)color8Selected:(id)sender
{
    [self updateHighlightColor:(UIButton *) sender];
    [self setSelectedColor:kColor8];
}

- (IBAction)color9Selected:(id)sender
{
    [self updateHighlightColor:(UIButton *) sender];
    [self setSelectedColor:kColor9];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self done:nil];
    return NO;
}

@end
