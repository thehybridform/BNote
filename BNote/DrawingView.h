//
//  DrawingView.h
//  BeNote
//
//  Created by Young Kristin on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface DrawingView : UIView
@property (assign, nonatomic) UIColor *strokeColor;
@property (assign, nonatomic) CGFloat strokeWidth;
@property (assign, nonatomic) Photo *photo;

- (void)undoLast;
- (void)redoLast;
- (void)reset;

@end

