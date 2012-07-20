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

@interface TopicEditorViewController ()
@property (strong, nonatomic) IBOutlet UIView *buttonControlView;
@property (strong, nonatomic) IBOutlet UIButton *selectedColorButton;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UIButton *buttonAction;

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

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setButtonControlView:nil];
    
    [self setButtonAction:nil];
    [self setNameTextField:nil];
    [self setTopic:nil];
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
}

- (id)initWithDefaultNib
{
    self = [super initWithNibName:@"TopicEditorViewController" bundle:nil];
    
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initButton:[self selectedColorButton] withColor:ColorWhite];

    if ([self topic]) {
        [[self view] setBackgroundColor:UIColorFromRGB([[self topic] color])];
        [self setSelectedColor:[[self topic] color]];
        [[self nameTextField] setText:[[self topic] title]];
        [[self buttonAction] setTitle:@"Update" forState:UIControlStateNormal];        
    }
    
    [self initButton:[self button_1] withColor:Color1];
    [self initButton:[self button_2] withColor:Color2];
    [self initButton:[self button_3] withColor:Color3];
    [self initButton:[self button_4] withColor:Color4];
    [self initButton:[self button_5] withColor:Color5];
    [self initButton:[self button_6] withColor:Color6];
    [self initButton:[self button_7] withColor:Color7];
    [self initButton:[self button_8] withColor:Color8];
    [self initButton:[self button_9] withColor:Color9];
    
//    [LayerFormater addShadowToView:[self buttonControlView]];
    [LayerFormater setBorderWidth:1 forView:[self buttonControlView]];

    [[self nameTextField] setDelegate:self];
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
        if ([self topic]) {
            topic = [self topic];
        } else {
            topic = [BNoteFactory createTopic:title]; 
        }
    
        [topic setTitle:title];

        [topic setColor:[self selectedColor]];
        
        for (Note *note in [topic notes]) {
            [note setColor:[self selectedColor]];
        }
        
        [[BNoteWriter instance] update];

        [[NSNotificationCenter defaultCenter] postNotificationName:TopicCreated object:topic];
    }

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
    [[button layer] setBorderWidth:1];
}

- (void)updateHighlightColor:(UIButton *)button
{
    UIColor *color = [button backgroundColor];

    [[self view] setBackgroundColor:color];
}

- (IBAction)color1Selected:(id)sender
{
    [self updateHighlightColor:(UIButton *) sender];
    [self setSelectedColor:Color1];
}

- (IBAction)color2Selected:(id)sender
{
    [self updateHighlightColor:(UIButton *) sender];
    [self setSelectedColor:Color2];
}

- (IBAction)color3Selected:(id)sender
{
    [self updateHighlightColor:(UIButton *) sender];
    [self setSelectedColor:Color3];
}

- (IBAction)color4Selected:(id)sender
{
    [self updateHighlightColor:(UIButton *) sender];
    [self setSelectedColor:Color4];
}

- (IBAction)color5Selected:(id)sender
{
    [self updateHighlightColor:(UIButton *) sender];
    [self setSelectedColor:Color5];
}

- (IBAction)color6Selected:(id)sender
{
    [self updateHighlightColor:(UIButton *) sender];
    [self setSelectedColor:Color6];
}

- (IBAction)color7Selected:(id)sender
{
    [self updateHighlightColor:(UIButton *) sender];
    [self setSelectedColor:Color7];
}

- (IBAction)color8Selected:(id)sender
{
    [self updateHighlightColor:(UIButton *) sender];
    [self setSelectedColor:Color8];
}

- (IBAction)color9Selected:(id)sender
{
    [self updateHighlightColor:(UIButton *) sender];
    [self setSelectedColor:Color9];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self done:nil];
    return NO;
}

@end
