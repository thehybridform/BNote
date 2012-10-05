//
//  Entry.h
//  BeNote
//
//  Created by kristin young on 10/4/12.
//
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
