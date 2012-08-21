//
//  BNoteButton.h
//  BeNote
//
//  Created by Young Kristin on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BNoteButton : UIButton

@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UIColor *highColor;
@property (strong, nonatomic) UIColor *lowColor;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (strong, nonatomic) CAGradientLayer *pressedGradientLayer;

- (CAGradientLayer *)setupGradient;
- (void)updateTitle:(NSString *)title;

@end
