//
//  SketchPathCloner.m
//  BeNote
//
//  Created by Young Kristin on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SketchPathCloner.h"
#import "SketchPath.h"
#import "BNoteFactory.h"

@implementation SketchPathCloner

- (SketchPath *)clone:(SketchPath *)path into:(Photo *)photo
{
    SketchPath *copy = [BNoteFactory createSketchPath:photo];
    [copy setBezierPath:[[path bezierPath] copy]];
    [copy setPathColor:[[path pathColor] copy]];
    
    return copy;
}

@end
