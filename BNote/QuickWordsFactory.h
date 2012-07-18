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
#import "QuickWordsViewController.h"
#import "EntryContent.h"

@interface QuickWordsFactory : NSObject

+ (NSMutableArray *)buildDateButtonsForEntryContent:(id<EntryContent>)controller;
+ (NSMutableArray *)buildKeyWordButtionsForEntryContent:(id<EntryContent>)controller;
+ (NSMutableArray *)buildAttendantButtionsForEntryContent:(id<EntryContent>)controller;

@end
