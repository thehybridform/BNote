//
//  BNoteSessionData.h
//  BNote
//
//  Created by Young Kristin on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Topic.h"
#import "TopicGroup.h"

@interface BNoteSessionData : NSObject <UIActionSheetDelegate>
@property (strong, nonatomic) UIPopoverController *popup;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (assign, nonatomic) id<UIActionSheetDelegate> actionSheetDelegate;
@property (assign, nonatomic) Topic *selectedTopic;

typedef enum {
    Reviewing,
    Editing
} BNotePhase;

@property (assign, nonatomic) BNotePhase phase;

+ (BNoteSessionData *)instance;

- (BOOL)canEditEntry;
- (BOOL)keyboardVisible;
- (NSMutableDictionary *)imageIconViews;
- (NSMutableDictionary *)entrySummaryHeaderImageViews;

+ (BOOL)booleanForKey:(NSString *)key;
+ (void)setBoolean:(BOOL)flag forKey:(NSString *)key;
+ (NSString *)stringForKey:(NSString *)key;
+ (void)setString:(NSString *)string forKey:(NSString *)key;

@end
