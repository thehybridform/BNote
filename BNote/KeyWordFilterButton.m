//
//  KeyWordFilterButton.m
//  BeNote
//
//  Created by kristin young on 7/29/12.
//
//

#import "KeyWordFilterButton.h"
#import "LayerFormater.h"

@interface KeyWordFilterButton()
@property (strong, nonatomic) id<BNoteFilter> filter;
@property (strong, nonatomic) UIView *highlightView;

@end

@implementation KeyWordFilterButton
@synthesize filter = _filter;
@synthesize highlightView = _highlightView;

- (id)initWithName:(NSString *)name andBNoteFilterDelegate:(id<BNoteFilterDelegate>)delegate
{
    self = [super initWithName:name andBNoteFilterDelegate:delegate];

    if (self) {
        id<BNoteFilter> filter = [BNoteFilterFactory createEntryTextFilter:name];
        [self setFilter:filter];
        
        
        CGRect frame = CGRectMake(5, 8, [self frame].size.width - 10, [self frame].size.height - 10);
        UIView *highlightView = [[UIView alloc] initWithFrame:frame];
        [highlightView setBackgroundColor:[BNoteConstants appHighlightColor1]];
        [highlightView setUserInteractionEnabled:NO];
        
        [LayerFormater roundCornersForView:highlightView];
        [LayerFormater setBorderWidth:0 forView:highlightView];
        [highlightView setHidden:YES];
        
        [self addSubview:highlightView];
        [self sendSubviewToBack:highlightView];
        [self setHighlightView:highlightView];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        [[self highlightView] setHidden:NO];
    } else {
        [[self highlightView] setHidden:YES];
    }
}

- (void)execute:(id)sender
{
    [[self delegate] useFilter:[self filter] sender:self];
}

@end
