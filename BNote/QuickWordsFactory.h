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
#import "EntryTableCellBasis.h"

@interface QuickWordsFactory : NSObject

+ (NSMutableArray *)buildDateButtonsForEntryCellView:(EntryTableCellBasis *)entryCellView;
+ (NSMutableArray *)buildButtionsForEntryCellView:(EntryTableCellBasis *)entryCellView andActionItem:(ActionItem *)actionItem;
+ (NSMutableArray *)buildButtionsForEntryCellView:(EntryTableCellBasis *)entryCellView andQuestion:(Question *)question;
+ (NSMutableArray *)buildButtionsForEntryCellView:(EntryTableCellBasis *)entryCellView andKeyPoint:(KeyPoint *)keyPoint;
+ (NSMutableArray *)buildKeyWordButtionsForEntryCellView:(EntryTableCellBasis *)entryCellView;

@end
