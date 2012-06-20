//
//  QuickWordButton.h
//  BNote
//
//  Created by Young Kristin on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntryTableCellBasis.h"

@protocol QuickWordsCallback;

@interface QuickWordButton : UIButton
@property (strong, nonatomic) EntryTableCellBasis *entryCellView;

- (id)initWithName:(NSString *)name andEntryCellView:(EntryTableCellBasis *)entryCellView;
- (void)execute:(id)sender;

@end

