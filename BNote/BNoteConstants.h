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

extern int const ColorWhite;
extern int const AnswerColor;

extern NSString *const KeyPointPhotoUpdated;
extern NSString *const KeyWordsUpdated;
extern NSString *const TopicUpdated;
extern NSString *const NoteUpdated;
extern NSString *const FinishedEditingNote;
extern NSString *const DeleteNote;

extern NSString *const NewLine;

extern NSString *const RefetchAllDatabaseData;

@interface BNoteConstants : NSObject

+ (UIColor *)appColor1;

@end
