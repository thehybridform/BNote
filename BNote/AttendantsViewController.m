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

@interface AttendantsViewController ()

@end

@implementation AttendantsViewController
@synthesize note = _note;
@synthesize attendantHelpLable = _attendantHelpLable;

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setNote:nil];
    [self setAttendantHelpLable:nil];
}

- (void)update
{
    [[BNoteWriter instance] update];

    NSArray *attendants = [self filterAttendants];
    if ([attendants count] > 0) {
        [[self attendantHelpLable] setHidden:YES];
    }
    
    NSEnumerator *items = [attendants objectEnumerator];
    Attendant *attendant;
    
    float x = 3;
    float width = 100;
    int index = 0;
    
    while (attendant = [items nextObject]) {
        AttendantView *view = [[AttendantView alloc] initWithFrame:CGRectMake((width * index++) + x , 3, 100, 69)];
        [view setDelegate:self];
         
        [LayerFormater roundCornersForView:view];
        [view setAttendant:attendant];
        [[self view] addSubview:view];
    }
     
    UIScrollView *view = (UIScrollView *) [self view];
    float height = [view frame].size.height;
    width = [attendants count] * 100;

    if (width > 0) {
        [view setContentSize:CGSizeMake(width, height)];
    }
}

- (NSArray *)filterAttendants
{
    id <BNoteFilter> filter = [BNoteFilterFactory create:AttendantType];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSEnumerator *entries = [[[self note] entries] objectEnumerator];
    Entry *entry;
    while (entry = [entries nextObject]) {
        if ([filter accept:entry]) {
            [array addObject:entry];
        }
    }
    
    return array;
}

- (void)remove:(Attendant *)attendant
{
    [[BNoteWriter instance] removeEntry:attendant];
    
    NSEnumerator *views = [[[self view] subviews] objectEnumerator];
    UIView *view;
    while (view = [views nextObject]) {
        [view setHidden:YES];
    }
    
    [self update];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
