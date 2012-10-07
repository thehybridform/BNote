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
@property (strong, nonatomic) id<UIActionSheetDelegate> actionSheetDelegate;
@property (strong, nonatomic) Topic *selectedTopic;
@property (strong, nonatomic) TopicGroup *selectedTopicGroup;
@property (strong, nonatomic) UIViewController *mainViewController;
@property (assign, nonatomic) BOOL syncingNotes;

+ (BNoteSessionData *)instance;

- (NSMutableDictionary *)entrySummaryHeaderImageViews;

+ (BOOL)booleanForKey:(NSString *)key;
+ (void)setBoolean:(BOOL)flag forKey:(NSString *)key;
+ (NSString *)stringForKey:(NSString *)key;
+ (void)setString:(NSString *)string forKey:(NSString *)key;

@end
