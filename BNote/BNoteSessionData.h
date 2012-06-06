//
//  BNoteSessionData.h
//  BNote
//
//  Created by Young Kristin on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Topic.h"

@interface BNoteSessionData : NSObject

typedef enum {
    Reviewing,
    Editing
} BNotePhase;

@property (assign, nonatomic) BNotePhase phase;

+ (BNoteSessionData *)instance;

- (BOOL)canEditEntry;

@end
