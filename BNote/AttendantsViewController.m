//
//  AttendantsViewController.m
//  BNote
//
//  Created by Young Kristin on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AttendantsViewController.h"
#import "AttendantView.h"
#import "BNoteFactory.h"
#import "LayerFormater.h"
#import "AttendantFilter.h"

@interface AttendantsViewController ()

@end

@implementation AttendantsViewController
@synthesize note = _note;

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (void)update
{
    NSEnumerator *attendants = [[self filterAttendants] objectEnumerator];
    Attendant *attendant;
    
    float x = 10;
    float width = 120;
    int index = 0;
    
    while (attendant = [attendants nextObject]) {
        AttendantView *view = [[AttendantView alloc] initWithFrame:CGRectMake((width * index++) + x , 6, 120, 82)];
        [LayerFormater roundCornersForView:view];
    
        [view setAttendant:attendant];
    
        [[self view] addSubview:view];
    }
     
}

- (NSArray *)filterAttendants
{
    AttendantFilter *filter = [[AttendantFilter alloc] init];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
