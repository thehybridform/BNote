//
//  BNoteConstants.m
//  BNote
//
//  Created by Young Kristin on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteConstants.h"


const int Color1 = 0xd7a779;
const int Color2 = 0xd1c5a4;
const int Color3 = 0x665d51;
const int Color4 = 0x98bac3;
const int Color5 = 0xcb694d;
const int Color6 = 0x8e9c6d;
const int Color7 = 0xc4d1c5;
const int Color8 = 0xc19cb5;
const int Color9 = 0xd7cd79;

const int AnswerColor = 0x336633;

const int FilterColor = 0xaaaaaa;

const int ColorWhite = 0xffffff;
const int AppColor1 = 0xfefefe;
const int AppColor2 = 0xf4f4f4;
const int darkGray = 0x888888;
const int AppHighlightColor1 = 0x365ab0;


NSString *const KeyPointPhotoUpdated = @"KeyPointPhotoUpdated";
NSString *const KeyWordsUpdated = @"KeyWordsUpdated";
NSString *const NoteUpdated = @"NoteUpdated";
NSString *const NoteSelected = @"NoteSelected";
NSString *const TopicCreated = @"TopicCreated";
NSString *const TopicSelected = @"TopicSelected";
NSString *const AddTopicGroupSelected = @"AddTopicGroupSelected";
NSString *const EditTopicGroupSelected = @"EditTopicGroupSelected";
NSString *const TopicGroupSelected = @"TopicGroupSelected";
NSString *const TopicGroupManage = @"TopicGroupManage";
NSString *const TopicUpdated = @"TopicUpdated";
NSString *const TopicDeleted = @"TopicDeleted";
NSString *const AttendantsEntryDeleted = @"AttendantsEntryDeleted";
NSString *const AttendeeDeleted = @"AttendeeDeleted";
NSString *const AttendeeUpdated = @"AttendeeUpdated";
NSString *const FinishedEditingNote = @"FinishedEditingNote";
NSString *const DeleteNote = @"DeleteNote";
NSString *const ReviewingNote = @"ReviewingNote";
NSString *const EditingNote = @"EditingNote";

NSString *const NewLine = @"\r\n";

NSString *const RefetchAllDatabaseData = @"RefetchAllDatabaseData";
NSString *const EulaFlag = @"EulaFlag";

NSString *const kFilteredTopicName = @"random name - 01pq92ow83ie847rut75thfgdyd63hvbdkc+_)(*ndjgddnjk<>?/.,ml9912";
NSString *const kAllTopicGroupName = @"random name - 234234098lskdjlksdc09rsdjkv$&^%TIDHCVKN88934cndjSDGERERGERGH";


@implementation BNoteConstants

+ (UIColor *)colorFor:(BNoteColor)color
{
    switch (color) {
        case BNoteColorHighlight:
            return UIColorFromRGB(AppHighlightColor1);
            break;
            
        case BNoteColorMain:
            return UIColorFromRGB(AppColor1);
            break;
            
        case BNoteColorGray:
            return UIColorFromRGB(AppColor1);
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
    return UIColorFromRGB(AppColor1);
}

+ (UIColor *)appColor2
{
    return UIColorFromRGB(AppColor2);
}

+ (UIColor *)darkGray
{
    return UIColorFromRGB(darkGray);
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
