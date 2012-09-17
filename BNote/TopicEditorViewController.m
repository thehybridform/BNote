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
#import "BNoteReader.h"

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
@property (strong, nonatomic) IBOutlet UIButton *button_10;
@property (strong, nonatomic) IBOutlet UIButton *button_11;
@property (strong, nonatomic) IBOutlet UIButton *button_12;
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
@property (strong, nonatomic) IBOutlet UIView *shadowView10;
@property (strong, nonatomic) IBOutlet UIView *shadowView11;
@property (strong, nonatomic) IBOutlet UIView *shadowView12;

@property (strong, nonatomic) NSMutableArray *topicNames;
@property (strong, nonatomic) NSString *currentTitle;

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
@synthesize button_10 = _button_10;
@synthesize button_11 = _button_11;
@synthesize button_12 = _button_12;
@synthesize selectedColorButton = _selectedColorButton;
@synthesize selectedColor = _selectedColor;
@synthesize buttonControlView = _buttonControlView;
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
@synthesize shadowView10 = _shadowView10;
@synthesize shadowView11 = _shadowView11;
@synthesize shadowView12 = _shadowView12;

@synthesize delegate = _delegate;

@synthesize topicNames = _topicNames;
@synthesize currentTitle = _currentTitle;

static NSString *kCreateText;
static NSString *kUpdateText;
static NSString *kAddTopicText;
static NSString *kEditTopicText;
static NSString *kPlaceHolderText;
static NSString *kTopicNameExists;
static NSString *kDoneText;


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
    [self setButton_10:nil];
    [self setButton_11:nil];
    [self setButton_12:nil];
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
    self.shadowView10 = nil;
    self.shadowView11 = nil;
    self.shadowView12 = nil;
}

- (id)initWithTopicGroup:(TopicGroup *)group
{
    self = [super initWithNibName:@"TopicEditorViewController" bundle:nil];
    
    if (self) {
        [self setTopicGroup:group];
        self.topicNames = [[BNoteReader instance] topicNames];
    }
    
    kCreateText = NSLocalizedString(@"Create", @"Commit create.");
    kUpdateText = NSLocalizedString(@"Update", @"Commit update.");
    kAddTopicText = NSLocalizedString(@"Add Topic", @"Add Topic text.");
    kEditTopicText = NSLocalizedString(@"Edit Topic", @"Edit Topic text.");
    kPlaceHolderText = NSLocalizedString(@"Type in a new Topic Title", @"New top place holder text.");
    kTopicNameExists = NSLocalizedString(@"Topic name already exists.", nil);
    kDoneText = NSLocalizedString(@"Done", nil);

    return self;
}

- (void)setTopic:(Topic *)topic
{
    _topic = topic;

    NSString *text = [BNoteStringUtils trim:topic.title.lowercaseString];

    for (NSDictionary *dictionary in self.topicNames) {
        NSString *name = [dictionary valueForKey:@"title"];

        if ([text isEqualToString:[BNoteStringUtils trim:name.lowercaseString]]) {
            [self.topicNames removeObject:dictionary];
            break;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initButton:[self selectedColorButton] withColor:kColorWhite];

    if ([self topic]) {
        [[self view] setBackgroundColor:UIColorFromRGB([[self topic] color])];
        [self setSelectedColor:[[self topic] color]];
        [[self nameTextField] setText:[[self topic] title]];
        self.menuLabel.text = kEditTopicText;
    } else {
        [self setSelectedColor:kColor1];
        [[self view] setBackgroundColor:UIColorFromRGB(kColor1)];
        self.menuLabel.text = kAddTopicText;
    }

    self.currentTitle = self.menuLabel.text;
    
    [self initButton:[self button_1] withColor:kColor1];
    [self initButton:[self button_2] withColor:kColor2];
    [self initButton:[self button_3] withColor:kColor3];
    [self initButton:[self button_4] withColor:kColor4];
    [self initButton:[self button_5] withColor:kColor5];
    [self initButton:[self button_6] withColor:kColor6];
    [self initButton:[self button_7] withColor:kColor7];
    [self initButton:[self button_8] withColor:kColor8];
    [self initButton:[self button_9] withColor:kColor9];
    [self initButton:[self button_10] withColor:kColor10];
    [self initButton:[self button_11] withColor:kColor11];
    [self initButton:[self button_12] withColor:kColor12];
    
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
    [LayerFormater addShadowToView:[self shadowView10]];
    [LayerFormater addShadowToView:[self shadowView11]];
    [LayerFormater addShadowToView:[self shadowView12]];

    [[self nameTextField] setDelegate:self];
    [[self nameTextField] becomeFirstResponder];

    self.menuLabel.font = [BNoteConstants font:RobotoBold andSize:15];
    self.menuLabel.textColor = [BNoteConstants appHighlightColor1];
    
    self.nameTextField.placeholder = kPlaceHolderText;
    self.buttonAction.titleLabel.text = kDoneText;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkTopicName:) name:UITextFieldTextDidChangeNotification object:self.nameTextField];
}

- (void)checkTopicName:(id)sender
{
    if ([self topicNameExists]) {
        self.buttonAction.hidden = YES;
        self.menuLabel.text = kTopicNameExists;
        self.menuLabel.textColor = [UIColor redColor];
    } else {
        self.buttonAction.hidden = NO;
        self.menuLabel.text = self.currentTitle;
        self.menuLabel.textColor = [BNoteConstants appHighlightColor1];
    }
}

- (BOOL)topicNameExists
{
    NSString *text = [BNoteStringUtils trim:self.nameTextField.text.lowercaseString];

    for (NSDictionary *dictionary in self.topicNames) {
        NSString *name = [dictionary valueForKey:@"title"];

        if ([text isEqualToString:[BNoteStringUtils trim:name.lowercaseString]]) {
            return YES;
        }
    }

    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)done:(id)sender
{
    NSString *title = [[self nameTextField] text];
    title = [BNoteStringUtils trim:title];
    
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
        
        [self.delegate finishedWith:topic];
    }

    [[self nameTextField] resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:^{}];
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

- (IBAction)color10Selected:(id)sender
{
    [self updateHighlightColor:(UIButton *) sender];
    [self setSelectedColor:kColor10];
}

- (IBAction)color11Selected:(id)sender
{
    [self updateHighlightColor:(UIButton *) sender];
    [self setSelectedColor:kColor11];
}

- (IBAction)color12Selected:(id)sender
{
    [self updateHighlightColor:(UIButton *) sender];
    [self setSelectedColor:kColor12];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self done:nil];
    return NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
