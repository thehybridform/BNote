//
//  QuickWordsViewController.m
//  BNote
//
//  Created by Young Kristin on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuickWordsViewController.h"
#import "LayerFormater.h"
#import "BNoteStringUtils.h"
#import "QuickWordsFactory.h"
#import "QuickWordButton.h"

#import "Question.h"
#import "ActionItem.h"
#import "KeyPoint.h"
#import "Decision.h"
#import "Attendant.h"

@interface QuickWordsViewController ()
@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet UIButton *attendantsButton;
@property (strong, nonatomic) IBOutlet UIButton *datesButton;
@property (strong, nonatomic) IBOutlet UIButton *keyWordsButton;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

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

static float spacing = 10;

static NSString *doneText;
static NSString *datesText;
static NSString *keyWordsText;
static NSString *attendenatsText;

- (id)initWithEntryContent:(id<EntryContent>)entryContent
{
    self = [super initWithNibName:@"QuickWordsViewController" bundle:nil];
    if (self) {
        [self setEntryContent:entryContent];
    }
    
    doneText = NSLocalizedString(@"Done", @"Done");
    datesText = NSLocalizedString(@"Dates", @"Select dates menu item");
    keyWordsText = NSLocalizedString(@"Key Words", @"Select key words menu item");
    attendenatsText = NSLocalizedString(@"Attendants", @"Select attendants menu item");

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[UIColor clearColor]];
    [[self scrollView] setBackgroundColor:[UIColor clearColor]];
    
    [self.attendantsButton setTitle:attendenatsText forState:UIControlStateNormal];
    [self.datesButton setTitle:datesText forState:UIControlStateNormal];
    [self.keyWordsButton setTitle:keyWordsText forState:UIControlStateNormal];
    [self.doneButton setTitle:doneText forState:UIControlStateNormal];
    
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)dates:(id)sender
{
    NSEnumerator *items = [[QuickWordsFactory buildDateButtonsForEntryContent:[self entryContent]] objectEnumerator];
    [self buildButtons:items];
}

- (IBAction)keyWords:(id)sender
{
    NSEnumerator *items = [[QuickWordsFactory buildKeyWordButtionsForEntryContent:[self entryContent]] objectEnumerator];
    [self buildButtons:items];
}

- (IBAction)attendants:(id)sender
{
    NSEnumerator *items = [[QuickWordsFactory buildAttendantButtionsForEntryContent:[self entryContent]] objectEnumerator];
    [self buildButtons:items];
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
    while (view = [items nextObject]) {
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
    while (view = [items nextObject]) {
        [view setHidden:YES];
    }
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
