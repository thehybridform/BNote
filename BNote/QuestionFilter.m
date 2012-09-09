//
//  QuestionFilter.m
//  BNote
//
//  Created by Young Kristin on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionFilter.h"

@implementation QuestionFilter

- (BOOL)accept:(id)item
{
    return [item isKindOfClass:[Question class]];
}

@end
