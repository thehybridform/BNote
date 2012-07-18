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
#import "Attendants.h"
#import "Photo.h"
#import "KeyWord.h"
#import "EntryContentViewController.h"
#import "TopicGroup.h"
#import "EntryContent.h"

extern NSString *const ACTION_ITEM_ACTIVE;
extern NSString *const ACTION_ITEM_INACTIVE;
extern NSString *const ATTENDIES_ACTIVE;
extern NSString *const ATTENDIES_INACTIVE;
extern NSString *const DECISION_ACTIVE;
extern NSString *const DECISION_INACTIVE;
extern NSString *const KEY_POINT_MASK;
extern NSString *const KEY_POINT_ACTIVE;
extern NSString *const KEY_POINT_INACTIVE;
extern NSString *const QUESTION_ACTIVE;
extern NSString *const QUESTION_INACTIVE;
extern NSString *const ATTENDANT;
extern NSString *const PAPER;
extern NSString *const TABLE_CELL_PLAIN;
extern NSString *const TABLE_CELL_SELECTED;
extern NSString *const CAMERA_ICON;
extern NSString *const FILM_ICON;
extern NSString *const GEAR_ICON;
extern NSString *const ENVELOPE_ICON;
extern NSString *const PALETTE_ICON;
extern NSString *const X_ICON;

extern NSString *const questionAnsweredEntryHeader;
extern NSString *const questionUnansweredEntryHeader;
extern NSString *const actionItemsCompletedEntryHeader;
extern NSString *const actionItemsIncompleteEntryHeader;
extern NSString *const decisionsEntryHeader;
extern NSString *const keyPointsEntryHeader;
extern NSString *const allEntryHeader;

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

    KeyPointIconMask,

    AttendantIcon,
    
    TableCellPlain,
    TableCellSelected
    
} BNoteIconType;

typedef enum {
    QuestionAnsweredHeader,
    QuestionUnansweredHeader,
    ActionItemCompleteHeader,
    ActionItemIncompleteHeader,
    DecisionHeader,
    KeyPointHeader,
    AllHeader
    
} EntrySummaryHeaderType;

@interface BNoteFactory : NSObject

+ (TopicGroup *)createTopicGroup:(NSString *)name;
+ (Topic *)createTopic:(NSString *)name;
+ (Note *)createNote:(Topic *)topic;
+ (Note *)copyNote:(Note *)note toTopic:(Topic *)topic;
+ (Question *)createQuestion:(Note *)note;
+ (ActionItem *)createActionItem:(Note *)note;
+ (KeyPoint *)createKeyPoint:(Note *)note;
+ (Decision *)createDecision:(Note *)note;
+ (Attendants *)createAttendants:(Note *)note;
+ (Photo *)createPhoto:(KeyPoint *)keyPoint;
+ (KeyWord *)createKeyWord:(NSString *)word;
+ (Attendant *)createAttendant:(Attendants *)attendants;
+ (SketchPath *)createSketchPath:(Photo *)photo;
+ (void)addUIBezierPath:(UIBezierPath *)path withColor:(UIColor *)color toPhoto:(Photo *)photo;

+ (UIView *)createHighlightSliver:(UIColor *)color;
+ (UIView *)createHighlight:(UIColor *)color;
+ (UIImageView *)createIcon:(BNoteIconType)type;
+ (UIImageView *)createIcon:(Entry *)entry active:(BOOL)active;
+ (UIImage *)paper;

+ (UIView *)createEntrySummaryHeaderView:(EntrySummaryHeaderType)type;

+ (id<EntryContent>)createEntryContent:(Entry *)entry;

@end
