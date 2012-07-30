//
//  KeyWordFilterButton.m
//  BeNote
//
//  Created by kristin young on 7/29/12.
//
//

#import "KeyWordFilterButton.h"
#import "KeyWordFilter.h"

@interface KeyWordFilterButton()
@property (strong, nonatomic) id<BNoteFilter> filter;

@end

@implementation KeyWordFilterButton
@synthesize filter = _filter;

- (id)initWithName:(NSString *)name andBNoteFilterDelegate:(id<BNoteFilterDelegate>)delegate
{
    self = [super initWithName:name andBNoteFilterDelegate:delegate];

    if (self) {
        id<BNoteFilter> filter = [BNoteFilterFactory createEntryTextFilter:name];
        [self setFilter:filter];
    }
    
    return self;
}

- (void)execute:(id)sender
{
    [[self delegate] useFilter:[self filter] sender:self];
}

@end
