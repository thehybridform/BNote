//
//  KeyPoint.h
//  BeNote
//
//  Created by Young Kristin on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Entry.h"

@class Photo;

@interface KeyPoint : Entry

@property (nonatomic, retain) Photo *photo;

@end
