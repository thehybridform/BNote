//
//  QuickWordsViewController.m
//  BNote
//
//  Created by Young Kristin on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuickWordsViewController.h"
#import "QuickWordsFactory.h"
#import "BNoteButton.h"

@interface QuickWordsViewController ()
@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet BNoteButton *attendantsButton;
@property (strong, nonatomic) IBOutlet BNoteButton *datesButton;
@property (strong, nonatomic) IBOutlet BNoteButton *keyWordsButton;
@property (strong, nonatomic) IBOutlet BNoteButton *doneButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *iconScrollView;

@property (strong, nonatomic) UIColor *highColor;
@property (strong, nonatomic) UIColor *lowColor;
@property (strong, nonatomic) UIColor *textColor;

@property (strong, nonatomic) id<EntryContent> entryContent;

@end

@implementation QuickWordsViewController
@synthesize menuView = _menuView;
@synthesize datesButton = _datesButton;
@synthesize keyWordsButton = _keyWordsButton;
@synthesize doneButton = _doneButton;
@synthesize scrollView = _scrollView;
@synthesize entryContent = _entryContent;
@synthesize attendantsButton = _attendantsButton;
@synthesize iconScrollView = _iconScrollView;
@synthesize delegate = _delegate;
@synthesize highColor = _highColor;
@synthesize lowColor = _lowColor;

static float spacing = 10;

static NSString *doneText;
static NSString *datesText;
static NSString *keyWordsText;
static NSString *attendantsText;

- (id)initWithEntryContent:(id<EntryContent>)entryContent
{
    self = [super initWithNibName:@"QuickWordsViewController" bundle:nil];
    if (self) {
        [self setEntryContent:entryContent];
    }
    
    doneText = NSLocalizedString(@"Done", @"Done");
    datesText = NSLocalizedString(@"Dates", @"Select dates menu item");
    keyWordsText = NSLocalizedString(@"Key Words", @"Select key words menu item");
    attendantsText = NSLocalizedString(@"Attendants", @"Select attendants menu item");

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[UIColor clearColor]];
    [[self scrollView] setBackgroundColor:[UIColor clearColor]];

    [self.attendantsButton setTitle:attendantsText forState:UIControlStateNormal];
    [self.datesButton setTitle:datesText forState:UIControlStateNormal];
    [self.keyWordsButton setTitle:keyWordsText forState:UIControlStateNormal];
    [self.doneButton setTitle:doneText forState:UIControlStateNormal];

    self.highColor = self.doneButton.highColor;
    self.lowColor = self.doneButton.lowColor;
    self.textColor = self.doneButton.titleLabel.textColor;

    [self addActionButtons];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyWords:)
                                                 name:kKeyWordsUpdated object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setAttendantsButton:nil];
    [self setDatesButton:nil];
    [self setKeyWordsButton:nil];
    [self setDoneButton:nil];
    [self setScrollView:nil];
    [self setMenuView:nil];
    self.iconScrollView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addActionButtons
{
    if (self.delegate) {
        CGFloat size = self.iconScrollView.frame.size.height - 8;
        int x = 4;
        for (UIButton *button in [self.delegate quickActionButtons]) {
            [self.iconScrollView addSubview:button];

            CGRect frame;
            if ([self resizeActionButton]) {
                int y = 4;
                frame = CGRectMake(x, y, size, size);
            } else {
                CGRect buttonFrame = button.frame;

                CGFloat y = self.iconScrollView.frame.size.height / 2.0 - buttonFrame.size.height / 2.0;
                
                frame = CGRectMake(x, y, buttonFrame.size.width, buttonFrame.size.height);
            }
            
            button.frame = frame;
            x += size + 8;
        }
    }
}

- (BOOL)resizeActionButton
{
    if ([self.delegate respondsToSelector:@selector(doNotResizeActionButton)]) {
        return ![self.delegate doNotResizeActionButton];
    }
    
    return YES;
}

- (IBAction)dates:(id)sender
{
    NSEnumerator *items = [[QuickWordsFactory buildDateButtonsForEntryContent:[self entryContent]] objectEnumerator];
    [self buildButtons:items];

    [self resetButtonColor];
    [self handleButtonColor:self.datesButton];
}

- (IBAction)keyWords:(id)sender
{
    NSEnumerator *items = [[QuickWordsFactory buildKeyWordButtionsForEntryContent:[self entryContent]] objectEnumerator];
    [self buildButtons:items];

    [self resetButtonColor];
    [self handleButtonColor:self.keyWordsButton];
}

- (IBAction)attendants:(id)sender
{
    NSEnumerator *items = [[QuickWordsFactory buildAttendantButtionsForEntryContent:[self entryContent]] objectEnumerator];
    [self buildButtons:items];

    [self resetButtonColor];
    [self handleButtonColor:self.attendantsButton];
}

- (IBAction)done:(id)sender
{
    [[[self entryContent] selectedTextView] resignFirstResponder];
}

- (void)buildButtons:(NSEnumerator *)items
{
    [self clearScrollView];
    
    float next = spacing;
    float y = [[self scrollView] bounds].size.height / 2.0;
    
    UIView *view;
    while ((view = [items nextObject])) {
        float width = [view bounds].size.width;
        
        [view setCenter:CGPointMake(next + width/2.0, y)];
        [[self scrollView] addSubview:view];
        
        next += width + spacing;
    }   
    
    [[self scrollView] setContentSize:CGSizeMake(next, [[self scrollView] bounds].size.height)];
}

- (void)clearScrollView
{
    NSEnumerator *items = [[[self scrollView] subviews] objectEnumerator];
    UIView *view;
    while ((view = [items nextObject])) {
        [view setHidden:YES];
    }
}

- (void)resetButtonColor
{
    self.attendantsButton.highColor = self.highColor;
    self.attendantsButton.lowColor = self.lowColor;
    [self.attendantsButton setNeedsDisplay];

    self.datesButton.highColor = self.highColor;
    self.datesButton.lowColor = self.lowColor;
    [self.datesButton setNeedsDisplay];

    self.keyWordsButton.highColor = self.highColor;
    self.keyWordsButton.lowColor = self.lowColor;
    [self.keyWordsButton setNeedsDisplay];
}

- (void)handleButtonColor:(BNoteButton *)button
{
    button.highColor = self.lowColor;
    button.lowColor = self.highColor;
    [button setNeedsDisplay];
}

- (void)selectFirstButton
{
    [self dates:nil]; 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
