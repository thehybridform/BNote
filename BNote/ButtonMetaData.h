//
//  ButtonMetaData.h
//  BNote
//
//  Created by Young Kristin on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ButtonMetaData : NSObject

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) UIButton *button;
@property (assign, nonatomic) int color;

+ (ButtonMetaData *)createWithIndex:(NSInteger)index andButton:(UIButton *)button andColor:(int)color;

@end
