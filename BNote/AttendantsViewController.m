//
//  AttendantsViewController.m
//  BNote
//
//  Created by Young Kristin on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AttendantsViewController.h"
#import "BNoteFactory.h"
#import "BNoteWriter.h"
#import "LayerFormater.h"
#import "Attendant.h"
#import "AttendantView.h"

@interface AttendantsViewController ()

@end

@implementation AttendantsViewController
@synthesize attendants = _attendants;

- (id)init
{
    self = [super init];

    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attendeeUpdate:)
                                                     name:AttendeeDeleted object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attendeeUpdate:)
                                                     name:AttendeeUpdated object:nil];
    }
    
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)attendeeUpdate:(NSNotification *)notification
{
    [self update];
}

- (void)update
{
    for (UIView *subView in [[self view] subviews]) {
        [subView setHidden:YES];
    }
    
    NSOrderedSet *attendees = [[self attendants] children];
    
    float x = 5;
    float width = 100;
    int index = 0;
    
    for (Attendant *attendant in attendees) {
        AttendantView *view = [[AttendantView alloc] initWithFrame:CGRectMake((width * index++) + x , 3, 100, 80)];
        
        [LayerFormater roundCornersForView:view];
        [view setAttendant:attendant];
        [[self view] addSubview:view];
    }
     
    UIScrollView *view = (UIScrollView *) [self view];
    float height = [view frame].size.height;
    width = [attendees count] * 100;

    if (width > 0) {
        [view setContentSize:CGSizeMake(width, height)];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
