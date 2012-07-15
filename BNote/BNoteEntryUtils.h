//
//  BNoteEntryUtils.h
//  BNote
//
//  Created by Young Kristin on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"
#import "ActionItem.h"
#import "Question.h"
#import "Attendant.h"
#import "Attendants.h"
#import "KeyPoint.h"
#import "Entry.h"

@interface BNoteEntryUtils : NSObject

+ (Attendant *)findMatch:(Attendants *)attendants withFirstName:(NSString *)first andLastName:(NSString *)last;

+ (NSString *)formatDetailTextForActionItem:(ActionItem *)actionItem;
+ (NSString *)formatDetailTextForQuestion:(Question *)question;
+ (BOOL)topicContainsAttendants:(Topic *)topic;
+ (BOOL)noteContainsAttendants:(Note *)note;
+ (BOOL)multipleTopics:(Note *)note;

+ (NSMutableArray *)attendants:(Note *)note;
+ (NSMutableArray *)attendees:(Note *)note;
+ (NSMutableArray *)actionItems:(Note *)note;
+ (NSMutableArray *)decisions:(Note *)note;
+ (NSMutableArray *)keyPoints:(Note *)note;
+ (NSMutableArray *)questions:(Note *)note;

+ (UIImage *)handlePhoto:(NSDictionary *)info forKeyPoint:(KeyPoint *)keyPoint saveToLibrary:(BOOL)save;
+ (void)updateThumbnailPhotos:(UIImage *)image forKeyPoint:(KeyPoint *)keyPoint;

+ (void)cleanUpEntriesForNote:(Note *)note;
@end
