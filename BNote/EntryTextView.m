//
//  EntryTextView.m
//  BNote
//
//  Created by Young Kristin on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntryTextView.h"

@implementation EntryTextView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"Add Key Word" action:@selector(addQuickWord:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:menuItem, nil]];
    
    [super touchesBegan:touches withEvent:event];

}

- (void)addQuickWord:(id)sender
{
    NSLog(@"gfsfdgsfdg");
}
@end
