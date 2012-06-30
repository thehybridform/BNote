//
//  ActionItem.h
//  BeNote
//
//  Created by Young Kristin on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Entry.h"


@interface ActionItem : Entry

@property (nonatomic) NSTimeInterval completed;
@property (nonatomic) NSTimeInterval dueDate;
@property (nonatomic, retain) NSString * responsibility;

@end
