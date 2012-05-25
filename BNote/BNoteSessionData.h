//
//  BNoteSessionData.h
//  BNote
//
//  Created by Young Kristin on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntryReviewViewController.h"
#import "NoteViewController.h"

@interface BNoteSessionData : NSObject

@property (strong, nonatomic) EntryReviewViewController *currentEntryReviewViewController;
@property (strong, nonatomic) NoteViewController *currentNoteViewController;

typedef enum {
    Reviewing,
    Editing
} BNotePhase;

+ (BNoteSessionData *)instance;

- (BOOL)canEditEntry;
- (void)setPhase:(BNotePhase)phase;

@end
