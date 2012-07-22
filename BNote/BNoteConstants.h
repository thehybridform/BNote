//
//  BNoteConstants.h
//  BNote
//
//  Created by Young Kristin on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *const ACTION_ITEM_ACTIVE;

extern int const Color1;
extern int const Color2;
extern int const Color3;
extern int const Color4;
extern int const Color5;
extern int const Color6;
extern int const Color7;
extern int const Color8;
extern int const Color9;

extern int const AppColor1;
extern int const AppHighlightColor1;

extern int const ColorWhite;
extern int const AnswerColor;

extern NSString *const KeyPointPhotoUpdated;
extern NSString *const KeyWordsUpdated;
//extern NSString *const AllDataUpdated;
extern NSString *const NoteUpdated;
extern NSString *const NoteSelected;
extern NSString *const TopicCreated;
extern NSString *const AddTopicGroupSelected;
extern NSString *const EditTopicGroupSelected;
extern NSString *const TopicGroupSelected;
extern NSString *const TopicGroupManage;
extern NSString *const TopicSelected;
extern NSString *const TopicUpdated;
extern NSString *const TopicDeleted;
extern NSString *const AttendantsEntryDeleted;
extern NSString *const AttendeeDeleted;
extern NSString *const AttendeeUpdated;
extern NSString *const FinishedEditingNote;
extern NSString *const DeleteNote;
extern NSString *const ReviewingNote;
extern NSString *const EditingNote;

extern NSString *const NewLine;

extern NSString *const RefetchAllDatabaseData;

extern NSString *const EulaFlag;

typedef enum {
    RobotoItalic,
    RobotoLight,
    RobotoBold,
    RobotoRegular
} BNoteFont;

typedef enum {
    BNoteColorHighlight,
    BNoteColorMain,
    
    BNoteColorGray
} BNoteColor;

@interface BNoteConstants : NSObject

+ (UIColor *)appColor1;
+ (UIColor *)appHighlightColor1;
+ (UIFont *)font:(BNoteFont)font andSize:(float)size;

+ (UIColor *)colorFor:(BNoteColor)color;

@end
