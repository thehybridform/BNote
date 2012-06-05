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
#import "EntryTableViewCell.h"

@interface QuickWordsFactory : NSObject

+ (NSMutableArray *)buildDateButtonsForEntryCellView:(EntryTableViewCell *)entryCellView;
+ (NSMutableArray *)buildButtionsForEntryCellView:(EntryTableViewCell *)entryCellView andActionItem:(ActionItem *)actionItem;
+ (NSMutableArray *)buildButtionsForEntryCellView:(EntryTableViewCell *)entryCellView andQuestion:(Question *)question;
+ (NSMutableArray *)buildButtionsForEntryCellView:(EntryTableViewCell *)entryCellView andKeyPoint:(KeyPoint *)keyPoint;

@end
