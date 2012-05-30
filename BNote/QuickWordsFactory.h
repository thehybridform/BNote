//
//  QuickWordsFactory.h
//  BNote
//
//  Created by Young Kristin on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"
#import "ActionItem.h"
#import "KeyPoint.h"
#import "Decision.h"
#import "Attendant.h"

@interface QuickWordsFactory : NSObject

+ (NSMutableArray *)buildDateButtonsForTextView:(UITextView *)textView;
+ (NSMutableArray *)buildButtionsForTextView:(UITextView *)textView andActionItem:(ActionItem *)actionItem;
+ (NSMutableArray *)buildButtionsForTextView:(UITextView *)textView andQuestion:(Question *)question;
+ (NSMutableArray *)buildButtionsForTextView:(UITextView *)textView andNote:(Note *)note;

@end
