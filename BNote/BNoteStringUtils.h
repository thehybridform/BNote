//
//  BNoteStringUtils.h
//  BNote
//
//  Created by Young Kristin on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entry.h"

@interface BNoteStringUtils : NSObject

+ (NSString *)trim:(NSString *)string;
+ (BOOL)nilOrEmpty:(NSString *)string;

+ (NSString *)dateToString:(NSDate *)date;
+ (NSString *)timeToString:(NSDate *)date;
+ (NSString *)formatDate:(NSTimeInterval)interval;

+ (NSString *)nameForEntry:(Entry *)entry;

+ (NSString *)append:(NSString *)firstObj, ... NS_REQUIRES_NIL_TERMINATION;
+ (int)textHieght:(NSString *)text inView:(UIView *)view;

@end
