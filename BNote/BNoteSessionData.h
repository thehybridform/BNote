//
//  BNoteSessionData.h
//  BNote
//
//  Created by Young Kristin on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Topic.h"

@interface BNoteSessionData : NSObject <UIActionSheetDelegate>
@property (strong, nonatomic) UIPopoverController *popup;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (assign, nonatomic) id<UIActionSheetDelegate> actionSheetDelegate;

typedef enum {
    Reviewing,
    Editing
} BNotePhase;

@property (assign, nonatomic) BNotePhase phase;
@property (strong, nonatomic) NSDictionary *settings;

+ (BNoteSessionData *)instance;

- (BOOL)canEditEntry;
- (NSMutableDictionary *)imageIconViews;
- (BOOL)keyboardVisible;
- (NSMutableDictionary *)entrySummaryHeaderImageViews;

@end
