//
//  BNoteRenderFactory.m
//  BNote
//
//  Created by Young Kristin on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNotePlainTextRenderer.h"
#import "BNoteRenderFactory.h"

@implementation BNoteRenderFactory

+(id <BNoteRenderer>)create:(BNoteRenderType)type
{
    switch (type) {
        case Html:
            return nil;

        default:
            break;
    }
    
    return [BNotePlainTextRenderer instance];
}


@end
