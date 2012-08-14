//
//  BNoteConstants.m
//  BNote
//
//  Created by Young Kristin on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteConstants.h"


const int kColor1 = 0xd7a779;
const int kColor2 = 0xd1c5a4;
const int kColor3 = 0x665d51;
const int kColor4 = 0x98bac3;
const int kColor5 = 0xcb694d;
const int kColor6 = 0x8e9c6d;
const int kColor7 = 0xc4d1c5;
const int kColor8 = 0xc19cb5;
const int kColor9 = 0xd7cd79;

const int kFilterColor = 0xaaaaaa;

const int kColorWhite = 0xffffff;
const int kAppColor1 = 0xfefefe;
const int kAppColor2 = 0xf4f4f4;
const int kDarkGray = 0xa8a8a8;
const int kDarkGray2 = 0xe0e0e0;
const int AppHighlightColor1 = 0x365ab0;

#ifdef LITE

const int kMaxTopicGroups = 3;
const int kMaxTopics = 3;
const int kMaxNotes = 4;
const int kMaxEntries = 5;

#endif


NSString * const kKeyPointPhotoUpdated = @"kKeyPointPhotoUpdated";
NSString * const kKeyWordsUpdated = @"kKeyWordsUpdated";
NSString * const kNoteUpdated = @"kNoteUpdated";
NSString * const kNoteSelected = @"kNoteSelected";
NSString * const kTopicCreated = @"kTopicCreated";
NSString * const kTopicSelected = @"kTopicSelected";
NSString * const kAddTopicGroupSelected = @"kAddTopicGroupSelected";
NSString * const kEditTopicGroupSelected = @"kEditTopicGroupSelected";
NSString * const kTopicGroupSelected = @"TopicGroupSelected";
NSString * const kTopicGroupManage = @"kTopicGroupManage";
NSString * const kTopicUpdated = @"kTopicUpdated";
NSString * const kClosedNoteEditor = @"kClosedNoteEditor";
NSString * const kAttendantsEntryDeleted = @"kAttendantsEntryDeleted";
NSString * const kAttendeeDeleted = @"kAttendeeDeleted";
NSString * const kAttendeeUpdated = @"kAttendeeUpdated";
NSString * const kReviewingNote = @"kReviewingNote";
NSString * const kEditingNote = @"kEditingNote";
NSString * const kFocusTextInput = @"kFocusTextInput";


NSString * const kNewLine = @"\r\n";

NSString * const kRefetchAllDatabaseData = @"kRefetchAllDatabaseData";
NSString * const kEulaFlag = @"kEulaFlag";

NSString * const kFilteredTopicName = @"random name - 01pq92ow83ie847rut75thfgdyd63hvbdkc+_)(*ndjgddnjk<>?/.,ml9912";
NSString * const kAllTopicGroupName = @"random name - 234234098lskdjlksdc09rsdjkv$&^%TIDHCVKN88934cndjSDGERERGERGH";

@implementation BNoteConstants

+ (UIColor *)colorFor:(BNoteColor)color
{
    switch (color) {
        case BNoteColorHighlight:
            return UIColorFromRGB(AppHighlightColor1);
            break;
            
        case BNoteColorMain:
            return UIColorFromRGB(kAppColor1);
            break;
            
        case BNoteColorGray:
            return UIColorFromRGB(kAppColor1);
            break;
            
        default:
            break;
    }
    return [UIColor blackColor];
}

+ (UIColor *)appHighlightColor1
{
    return UIColorFromRGB(AppHighlightColor1);
}

+ (UIColor *)appColor1
{
    return UIColorFromRGB(kAppColor1);
}

+ (UIColor *)appColor2
{
    return UIColorFromRGB(kAppColor2);
}

+ (UIColor *)darkGray
{
    return UIColorFromRGB(kDarkGray);
}

+ (UIColor *)darkGray2
{
    return UIColorFromRGB(kDarkGray2);
}

+ (UIFont *)font:(BNoteFont)font andSize:(float)size
{
    NSString *name;
    switch (font) {
        case RobotoRegular:
            name = @"Roboto-Regular";
            break;
        case RobotoLight:
            name = @"Roboto-Light";
            break;
        case RobotoItalic:
            name = @"Roboto-Italic";
            break;
        case RobotoBold:
            name = @"Roboto-Bold";
            break;
        default:
            break;
    }
    return [UIFont fontWithName:name size:size];
}

@end
