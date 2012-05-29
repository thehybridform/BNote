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

@end

@implementation QuickWordButton
@synthesize textView = _textView;

- (id)initWithName:(NSString *)name andTextView:(UITextView *)textView
{
    float width = [name length] * 11;
    self = [super initWithFrame:CGRectMake(0, 0, width, 40)];
    if (self) {
        [self setTitle:name forState:UIControlStateNormal];
        
        [LayerFormater roundCornersForView:self];
        
        [self setTitle:name forState:UIControlStateNormal];
        [self setTextView:textView];
    }
    
    return self;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self execute];
}

- (void)execute {}

@end

