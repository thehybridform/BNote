//
//  KeyPoint.h
//  BeNote
//
//  Created by kristin young on 10/4/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Entry.h"

@class Photo;

@interface KeyPoint : Entry

@property (nonatomic, retain) Photo *photo;

@end
