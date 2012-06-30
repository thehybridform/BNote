//
//  Entry.h
//  BeNote
//
//  Created by Young Kristin on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note;

@interface Entry : NSManagedObject

@property (nonatomic) NSTimeInterval created;
@property (nonatomic) NSTimeInterval lastUpdated;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) Note *note;

@end
