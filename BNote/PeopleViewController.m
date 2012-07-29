//
//  PeopleViewController.m
//  BeNote
//
//  Created by Young Kristin on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PeopleViewController.h"
#import "Attendants.h"
#import "Attendant.h"
#import "PersonViewController.h"

@interface PeopleViewController ()
@property (strong, nonatomic) NSMutableArray *peopleControllers;
@property (strong, nonatomic) NSMutableArray *attendantsArray;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControlPeople;

@end

@implementation PeopleViewController
@synthesize peopleControllers = _peopleControllers;
@synthesize attendantsArray = _attendantsArray;
@synthesize pageControlPeople = _pageControlPeople;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

- (void)setTopic:(Topic *)topic
{
    _topic = topic;

    [self setPeopleControllers:[[NSMutableArray alloc] init]];
    [self setAttendantsArray:[[NSMutableArray alloc] init]];
    
    for (Note *note in [topic notes]) {
        for (Attendants *attendants in [BNoteEntryUtils attendants:note]) {
            [self addAttendants:attendants];
        }
    }
    
    for (Note *note in [topic associatedNotes]) {
        for (Attendants *attendants in [BNoteEntryUtils attendants:note]) {
            [self addAttendants:attendants];
        }
    }
    [self reload];
}

- (void)addAttendants:(Attendants *)attendants
{
    for (Attendant *attendant in [attendants children]) {
        if (![self contains:attendant]) {
            [[self attendantsArray] addObject:attendant];
        }
    }

    [self reload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setPeopleControllers:nil];
    [self setAttendantsArray:nil];
    [self setPageControlPeople:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self]; 
}

- (void)reset
{
    UIScrollView *view = (UIScrollView *)[self view];
    CGRect frame;
    frame.origin.x = 10;
    frame.origin.y = 10;
    frame.size = CGSizeMake(10, 10);
    [view scrollRectToVisible:frame animated:YES];

    [[self pageControlPeople] setCurrentPage:0];
}

- (void)reload
{
    UIScrollView *scrollView = (UIScrollView *) [self view];
    for (UIView *view in [scrollView subviews]) {
        [view removeFromSuperview];
    }

    float y = 5;
    float space = 85;
    
    int visiblePeople = 9;
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsPortrait(orientation)) {
        visiblePeople = 6;
    }

    float x = 10;
    int people = 0;

    for (Attendant *attendant in [self attendantsArray]) {
        PersonViewController *controller = [[PersonViewController alloc] initWithAttendant:attendant];
        [[self peopleControllers] addObject:controller];
        
        UIView *view = [controller view];
        float width = [view bounds].size.width;
        float height = [view bounds].size.height;
        
        CGRect frame = CGRectMake(x, y, width, height);
        [view setFrame:frame];
        
        [scrollView addSubview:view];
        
        x += space;
        
        people++;
    }
    
    int count = people / visiblePeople;
    if (people % visiblePeople) {
        count++;
    }

    float width = space * count * visiblePeople;
    if (width > 0) {
        [scrollView setContentSize:CGSizeMake(width, [scrollView bounds].size.height)];
    }

    [[self pageControlPeople] setNumberOfPages:count];
    [[self pageControlPeople] setNeedsDisplay];
}

- (BOOL)contains:(Attendant *)attendant
{
    NSString *firstname1 = [attendant firstName];
    NSString *lastname1 = [attendant lastName];
    
    for (Attendant *att in [self attendantsArray]) {
        NSString *firstname2 = [att firstName];
        NSString *lastname2 = [att lastName];
        
        BOOL firstMatch = [BNoteStringUtils string:firstname1 isEqualsTo:firstname2];
        BOOL lastMatch = [BNoteStringUtils string:lastname1 isEqualsTo:lastname2];
        
        if (firstMatch && lastMatch) {
            return YES;
        }
    }
    
    return NO;
}

- (IBAction)pageChanged:(UIPageControl *)pageControl
{
    UIScrollView *view = (UIScrollView *)[self view];
    CGRect frame;
    frame.origin.x = [view frame].size.width * [pageControl currentPage];
    frame.origin.y = 0;
    frame.size = [view frame].size;
    [view scrollRectToVisible:frame animated:YES];
    
    [[self pageControlPeople] setNeedsDisplay];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    UIScrollView *view = (UIScrollView *)[self view];
    
    CGFloat pageWidth = [view frame].size.width;
    int page = floor((view.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [[self pageControlPeople] setCurrentPage:page];
    
    [[self pageControlPeople] setNeedsDisplay];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
