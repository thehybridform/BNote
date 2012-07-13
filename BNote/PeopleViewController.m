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
@end

@implementation PeopleViewController
@synthesize peopleControllers = _peopleControllers;
@synthesize attendantsArray = _attendantsArray;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setPeopleControllers:[[NSMutableArray alloc] init]];
        [self setAttendantsArray:[[NSMutableArray alloc] init]];
    }
    return self;
}


- (void)reset
{
    UIScrollView *scrollView = (UIScrollView *) [self view];
    for (UIView *view in [scrollView subviews]) {
        [view removeFromSuperview];
    }

    [self setPeopleControllers:[[NSMutableArray alloc] init]];
    [self setAttendantsArray:[[NSMutableArray alloc] init]];
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self]; 
}

- (void)reload
{
    float y = 5;
    float space = 85;
    
    UIScrollView *scrollView = (UIScrollView *) [self view];

    float x = 10;

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
    }
    
    float width = x + space;
    if (width > 0) {
        [scrollView setContentSize:CGSizeMake(width, [scrollView bounds].size.height)];
    }
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
