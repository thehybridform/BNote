//
//  QuickWordButton.m
//  BNote
//
//  Created by Young Kristin on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuickWordButton.h"
#import "LayerFormater.h"

@interface QuickWordButton()
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIColor *highlightColor;
@end

@implementation QuickWordButton
@synthesize color = _color;
@synthesize highlightColor = _highlightColor;
@synthesize entryCellView = _entryCellView;

- (id)initWithName:(NSString *)name andEntryCellView:(EntryTableViewCell *)entryCellView
{
    self = [super init];
    if (self) {
        [self setTitle:name forState:UIControlStateNormal];
        
        [LayerFormater roundCornersForView:self];
        
        [self setTitle:name forState:UIControlStateNormal];
        [self setEntryCellView:entryCellView];
        
        [self addTarget:self action:@selector(execute:) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(unhighlight:) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(highlight:) forControlEvents:UIControlEventTouchDown];
        [self setFrame:CGRectMake(0, 0, [[[self titleLabel] text] length] * 11, 40)];
        
        [self setHighlightColor:[UIColor blueColor]];
        
        [self initCommon];
    }
    
    return self;
}

- (void)initCommon
{
    
}

- (void)highlight:(id)sender
{
    [self setColor:[self backgroundColor]];
    [self setBackgroundColor:[self highlightColor]];
}

- (void)unhighlight:(id)sender
{
    [self setBackgroundColor:[self color]];
}

- (void)execute:(id)sender
{
    NSLog(@"Need to everi this method in subclass: %s", __PRETTY_FUNCTION__);
}

@end

