//
//  ButtonMetaData.m
//  BNote
//
//  Created by Young Kristin on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ButtonMetaData.h"

@implementation ButtonMetaData

@synthesize index = _index;
@synthesize button = _button;
@synthesize color = _color;

+ (ButtonMetaData *)createWithIndex:(NSInteger)index andButton:(UIButton *)button andColor:(int)color
{
    ButtonMetaData *data = [[ButtonMetaData alloc] init];
    [data setIndex:index];
    [data setButton:button];
    [data setColor:color];
    
    return data;
}

@end
