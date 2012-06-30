//
//  DrawingView.h
//  BeNote
//
//  Created by Young Kristin on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawingView : UIView
@property (assign, nonatomic) UIColor *strokeColor;
@property (assign, nonatomic) CGFloat strokeWidth;

- (void)undoLast;
- (void)reset;

@end
