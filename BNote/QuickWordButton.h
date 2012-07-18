//
//  QuickWordButton.h
//  BNote
//
//  Created by Young Kristin on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntryContent.h"

@protocol QuickWordsCallback;

@interface QuickWordButton : UIButton

- (id)initWithName:(NSString *)name andEntryContentViewController:(id<EntryContent>)controller;
- (void)execute:(id)sender;
- (id<EntryContent>)entryContent;

@end

