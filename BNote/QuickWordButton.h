//
//  QuickWordButton.h
//  BNote
//
//  Created by Young Kristin on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QuickWordsCallback;

@interface QuickWordButton : UIButton
@property (strong, nonatomic) UITextView *textView;

- (id)initWithName:(NSString *)name andTextView:(UITextView *)textView;
- (void)execute:(id)sender;

@end

