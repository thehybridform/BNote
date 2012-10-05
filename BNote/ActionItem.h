//
//  ActionItem.h
//  BeNote
//
//  Created by kristin young on 10/4/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Entry.h"

@class Attendant;

@interface ActionItem : Entry

@property (nonatomic) NSTimeInterval completed;
@property (nonatomic) NSTimeInterval dueDate;
@property (nonatomic, retain) Attendant *attendant;

@end
