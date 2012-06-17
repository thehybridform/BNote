//
//  BNoteRenderer.h
//  BNote
//
//  Created by Young Kristin on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Topic.h"
#import "Note.h"

@protocol BNoteRenderer <NSObject>

@required
- (NSString *)render:(Topic *)topic;
- (NSString *)render:(Topic *)topic and:(Note *)selectedNote;

@end
