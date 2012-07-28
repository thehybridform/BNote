//
//  EntryContent.h
//  BeNote
//
//  Created by Young Kristin on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entry.h"

@protocol EntryContent <NSObject>

@required
- (UIView *)view;
- (Entry *)entry;
- (UITextView *)selectedTextView;
- (UITextView *)mainTextView;
- (UIImageView *)iconView;
- (UITableViewCell *)cell;
- (float)height;
- (float)width;
- (void)setParentController:(UIViewController *)controller;

@end