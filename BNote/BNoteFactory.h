//
//  BNoteFactory.h
//  BNote
//
//  Created by Young Kristin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Topic.h"
#import "Note.h"
#import "Question.h"
#import "ActionItem.h"
#import "KeyPoint.h"
#import "Decision.h"
#import "Attendant.h"

extern NSString *const ACTION_ITEM_ACTIVE;
extern NSString *const ACTION_ITEM_INACTIVE;
extern NSString *const ATTENDIES_ACTIVE;
extern NSString *const ATTENDIES_INACTIVE;
extern NSString *const DECISION_ACTIVE;
extern NSString *const DECISION_INACTIVE;
extern NSString *const KEY_POINT_ACTIVE;
extern NSString *const KEY_POINT_INACTIVE;
extern NSString *const QUESTION_ACTIVE;
extern NSString *const QUESTION_INACTIVE;

typedef enum {
    ActionItemIcon,
    AttentiesIcon,
    DecisionIcon,
    KeyPointIcon,
    QuestionIcon,
    
    ActionItemIconActive,
    AttentiesIconActive,
    DecisionIconActive,
    KeyPointIconActive,
    QuestionIconActive,
    
    Unknown
} BNoteIconType;

@interface BNoteFactory : NSObject

+ (Topic *)createTopic:(NSString *)name;
+ (Note *)createNote:(Topic *)topic;
+ (Question *)createQuestion:(Note *)note;
+ (ActionItem *)createActionItem:(Note *)note;
+ (KeyPoint *)createKeyPoint:(Note *)note;
+ (Decision *)createDecision:(Note *)note;
+ (Attendant *)createAttendant:(Note *)note;

+ (UIView *)createHighlightSliver:(UIColor *)color;
+ (UIView *)createHighlight:(UIColor *)color;
+ (UIImageView *)createIcon:(BNoteIconType)type;
+ (UIImageView *)createIcon:(Entry *)entry active:(BOOL)active;

@end
