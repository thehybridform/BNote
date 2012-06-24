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
+ (BOOL)containsAttendants:(Note *)note;

+ (NSMutableArray *)attendants:(Note *)note;
+ (NSMutableArray *)attendees:(Note *)note;

+ (CGFloat)cellHeight:(Entry *)entry inView:(UIView *)view;

+ (UIImage *)handlePhoto:(NSDictionary *)info forKeyPoint:(KeyPoint *)keyPoint;

@end
