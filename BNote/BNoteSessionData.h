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
@property (strong, nonatomic) NSDictionary *settings;
@property (strong, nonatomic) UITextView *scratchTextView;

+ (BNoteSessionData *)instance;

- (BOOL)canEditEntry;
- (NSMutableDictionary *)imageIconViews;
- (BOOL)keyboardVisible;

@end
