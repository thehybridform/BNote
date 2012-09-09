//
//  BNoteFilterFactory.h
//  BNote
//
//  Created by Young Kristin on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNoteFilter.h"

typedef enum {
    ItdentityType,
    KeyPointType,
    ActionItemType,
    ActionItemCompleteType,
    ActionItemsIncompleteType,
    QuestionType,
    QuestionAnsweredType,
    QuestionUnansweredType,
    DecistionType,
    AttendantType
} BNoteFilterType;

@interface BNoteFilterFactory : NSObject

+ (BNoteFilterFactory *)instance;
+ (id<BNoteFilter>)createEntryTextFilter:(NSString *)searchText;

- (id<BNoteFilter>)create:(BNoteFilterType)type;

@end
