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
@property (strong, nonatomic) id<EntryContent> entryContent;
@end

@implementation QuickWordButton
@synthesize color = _color;
@synthesize highlightColor = _highlightColor;
@synthesize entryContent = _entryContent;

- (id)initWithName:(NSString *)name andEntryContentViewController:(id<EntryContent>)controller
{
    self = [super init];
    if (self) {
        [self setTitle:name forState:UIControlStateNormal];
        [[self titleLabel] setFont:[BNoteConstants font:RobotoRegular andSize:15]];
        
        [LayerFormater roundCornersForView:self];
        
        [self setTitle:name forState:UIControlStateNormal];
        [self setEntryContent:controller];
        
        [self addTarget:self action:@selector(execute:) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(unhighlight:) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(highlight:) forControlEvents:UIControlEventTouchDown];
        
        float width = MAX([[[self titleLabel] text] length] * 10, 40);
        
        [self setFrame:CGRectMake(0, 0, width, 35)];
        
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
    NSLog(@"Need to override this method in subclass: %s", __PRETTY_FUNCTION__);
}

@end

