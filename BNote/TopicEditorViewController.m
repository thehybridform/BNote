//
//  TopicEditorViewController.m
//  BNote
//
//  Created by Young Kristin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopicEditorViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ButtonMetaData.h"

@interface TopicEditorViewController ()
@property (strong, nonatomic) NSMutableArray *buttons;
@end

@implementation TopicEditorViewController

@synthesize nameTextField = _nameTextField;
@synthesize titleTextLabel= _titleTextLabel;
@synthesize delegate = _delegate;
@synthesize indexPath = _indexPath;
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
@synthesize selectedColor = _selectedColor;
@synthesize currentColor = _currentColor;
@synthesize buttons = _buttons;

- (id)initWithDefaultNib
{
    self = [super initWithNibName:@"TopicEditorViewController" bundle:nil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self isEditing]) {
        [[self nameTextField] setText:[[self topic] title]];
        [[self titleTextLabel] setText:@"Edit Topic"];
        [[self buttonAction] setTitle:@"Update"];
    } else {
        [[self titleTextLabel] setText:@"New Topic"];
        [[self buttonAction] setTitle:@"Create"];
    }
    
    [self setButtons:[[NSMutableArray alloc] init]];
    
    [self initButton:[self button_1] withColor:0xffffff andIndex:1];
    [self initButton:[self button_2] withColor:0xfce5cd andIndex:2];
    [self initButton:[self button_3] withColor:0x7098bc andIndex:3];
    [self initButton:[self button_4] withColor:0xf9b56E andIndex:4];
    [self initButton:[self button_5] withColor:0xcfe2f3 andIndex:5];
    [self initButton:[self button_6] withColor:0xCCCC11 andIndex:6];
    [self initButton:[self button_7] withColor:0x11AA11 andIndex:7];
    [self initButton:[self button_8] withColor:0xCCCCCC andIndex:8];
    [self initButton:[self button_9] withColor:0xE1DED3 andIndex:9];
    [self initButton:[self selectedColor] withColor:0xffffff andIndex:10];

    [self initHighlightColor];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

# pragma mark - Actions
- (IBAction)done:(id)sender
{
    id<TopicEditorViewControllerDelegate> delegate = [self delegate];
    if (delegate) {
        [delegate didFinish:self];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender
{
    id<TopicEditorViewControllerDelegate> delegate = [self delegate];
    if (delegate) {
        [delegate didCancel:self];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)initButton:(UIButton *)button withColor:(int)color andIndex:(NSInteger)index
{
    [button setBackgroundColor:UIColorFromRGB(color)];
    [[button layer] setCornerRadius:7.0];
    [[button layer] setMasksToBounds:YES];
    [[button layer] setBorderWidth:1];
    
    [[self buttons] addObject:[ButtonMetaData createWithIndex:index andButton:button andColor:[NSNumber numberWithInt:color]]];
}

- (void)updateHighlightColor:(NSInteger)index
{
    for (int i = 0; i < [[self buttons] count]; i++) {
        ButtonMetaData *data = [[self buttons] objectAtIndex:i];
        if ([data index] == index) {
            [self setCurrentColor:[data color]];
            [[self selectedColor] setBackgroundColor:[[data button] backgroundColor]];
            
            break;
        }
    }
}

- (void)initHighlightColor
{
    for (int i = 0; i < [[self buttons] count]; i++) {
        ButtonMetaData *data = [[self buttons] objectAtIndex:i];
        if ([[[self topic] color] intValue] == [[data color] intValue]) {
            [self setCurrentColor:[data color]];
            [[self selectedColor] setBackgroundColor:[[data button] backgroundColor]];
            
            break;
        }
    }
}

- (IBAction)color1Selected:(id)sender
{
    [self updateHighlightColor:1];
}

- (IBAction)color2Selected:(id)sender
{
    [self updateHighlightColor:2];
}

- (IBAction)color3Selected:(id)sender
{
    [self updateHighlightColor:3];
}

- (IBAction)color4Selected:(id)sender
{
    [self updateHighlightColor:4];
}

- (IBAction)color5Selected:(id)sender
{
    [self updateHighlightColor:5];
}

- (IBAction)color6Selected:(id)sender
{
    [self updateHighlightColor:6];
}

- (IBAction)color7Selected:(id)sender
{
    [self updateHighlightColor:7];
}

- (IBAction)color8Selected:(id)sender
{
    [self updateHighlightColor:8];
}

- (IBAction)color9Selected:(id)sender
{
    [self updateHighlightColor:9];
}

- (void)viewDidUnload
{
    [self setDelegate:nil];
    [self setTopic:nil];
    [self setTitleTextLabel:nil];
    [self setSelectedColor:nil];
    [self setCurrentColor:nil];
    
    [self setButtons:nil];
    [self setButton_1:nil];
    [self setButton_2:nil];
    [self setButton_3:nil];
    [self setButton_4:nil];
    [self setButton_5:nil];
    [self setButton_6:nil];
    [self setButton_7:nil];
    [self setButton_8:nil];
    [self setButton_9:nil];
    [self setButtons:nil];
    
    [super viewDidUnload];
}

@end
