//
//  BNoteTextField.m
//  BeNote
//
//  Created by kristin young on 8/13/12.
//
//

#import "BNoteTextField.h"

@implementation BNoteTextField

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [[self.subviews objectAtIndex:0] setAlpha:0.0];
    }
    
    return self;
}

- (void)showFrame:(BOOL)flag
{
    if (flag) {
        [[self.subviews objectAtIndex:0] setAlpha:1];
    } else {
        [[self.subviews objectAtIndex:0] setAlpha:0.0];
    }
}

@end
