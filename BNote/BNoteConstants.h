//
//  BNoteConstants.h
//  BNote
//
//  Created by Young Kristin on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



extern int const kColor1;
extern int const kColor2;
extern int const kColor3;
extern int const kColor4;
extern int const kColor5;
extern int const kColor6;
extern int const kColor7;
extern int const kColor8;
extern int const kColor9;
extern int const kColor10;
extern int const kColor11;
extern int const kColor12;

extern int const kAppColor1;
extern int const kAppColor2;
extern int const kDarkGray;

extern int const kColorWhite;
extern int const kFilterColor;

extern NSString * const kArchiveFilename;

extern NSString * const kKeyPointPhotoUpdated;
extern NSString * const kKeyWordsUpdated;
extern NSString * const kNoteUpdated;
extern NSString * const kNoteSelected;
extern NSString * const kTopicCreated;
extern NSString * const kTopicGroupSelected;
extern NSString * const kTopicGroupManage;
extern NSString * const kTopicSelected;
extern NSString * const kTopicUpdated;
extern NSString * const kClosedNoteEditor;
extern NSString * const kAttendantsEntryDeleted;
extern NSString * const kAttendeeDeleted;
extern NSString * const kAttendeeUpdated;
extern NSString * const kActionItemActive;

extern NSString * const kNewLine;

extern NSString * const kRefetchAllDatabaseData;

extern NSString * const kFirstLoad;
extern NSString * const kFirstMainView;
extern NSString * const kFirstMainViewStep2;
extern NSString * const kFirstMainViewStep3;
extern NSString * const kFirstMainViewStep4;
extern NSString * const kFirstTopicAdd;

extern NSString * const kFilteredTopicName;
extern NSString * const kAllTopicGroupName;

extern NSString * const kUobiaHomePage;
extern NSString * const kUobia;

#ifdef LITE

extern int const kMaxTopicGroups;
extern int const kMaxTopics;
extern int const kMaxNotes;
extern int const kMaxEntries;

#endif

typedef enum {
    RobotoItalic,
    RobotoLight,
    RobotoBold,
    RobotoRegular
} BNoteFont;

@interface BNoteConstants : NSObject

+ (UIColor *)appColor1;
+ (UIColor *)appColor2;
+ (UIColor *)darkGray;
+ (UIColor *)darkGray2;
+ (UIColor *)appHighlightColor1;
+ (UIFont *)font:(BNoteFont)font andSize:(float)size;

@end
