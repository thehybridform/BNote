//
//  BNoteRenderFactory.h
//  BNote
//
//  Created by Young Kristin on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNoteRenderer.h"

typedef enum {
    Plain,
    Html
} BNoteRenderType;

@interface BNoteRenderFactory : NSObject

+(id <BNoteRenderer>)create:(BNoteRenderType)type;

@end
