//
//  EntryCell.h
//  BeNote
//
//  Created by Young Kristin on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entry.h"

@protocol EntryCell <NSObject>

- (void)setEntry:(Entry *)entry;
- (UIView *)view;
- (void)setParentController:(UIViewController *)parent;
- (void)focus;
- (void)unfocus;

@end
