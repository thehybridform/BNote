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


const NSString *const KeyPointPhotoUpdated = @"KeyPointPhotoUpdated";
const NSString *const KeyWordsUpdated = @"KeyWordsUpdated";
//const NSString *const AllDataUpdated = @"AllDataUpdated";
const NSString *const NoteUpdated = @"NoteUpdated";
const NSString *const NoteSelected = @"NoteSelected";
const NSString *const TopicCreated = @"TopicCreated";
const NSString *const TopicSelected = @"TopicSelected";
const NSString *const AddTopicGroupSelected = @"AddTopicGroupSelected";
const NSString *const EditTopicGroupSelected = @"EditTopicGroupSelected";
const NSString *const TopicGroupSelected = @"TopicGroupSelected";
const NSString *const TopicGroupManage = @"TopicGroupManage";
const NSString *const TopicUpdated = @"TopicUpdated";
const NSString *const TopicDeleted = @"TopicDeleted";
const NSString *const AttendantsEntryDeleted = @"AttendantsEntryDeleted";
const NSString *const AttendeeDeleted = @"AttendeeDeleted";
const NSString *const AttendeeUpdated = @"AttendeeUpdated";
const NSString *const FinishedEditingNote = @"FinishedEditingNote";
const NSString *const DeleteNote = @"DeleteNote";
const NSString *const ReviewingNote = @"ReviewingNote";
const NSString *const EditingNote = @"EditingNote";

const NSString *const NewLine = @"\r\n";

const NSString *const RefetchAllDatabaseData = @"RefetchAllDatabaseData";
const NSString *const EulaFlag = @"EulaFlag";

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
