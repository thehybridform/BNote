//
//  BNoteWriter.h
//  BNote
//
//  Created by Young Kristin on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Topic.h"
#import "Note.h"
#import "Entry.h"
#import "Photo.h"
#import "KeyPoint.h"
#import "KeyWord.h"
#import "Attendant.h"
#import "SketchPath.h"

@interface BNoteWriter : NSObject

@property (strong, nonatomic) NSManagedObjectContext *context;

+ (BNoteWriter *)instance;

- (void)update;
- (void)removeTopic:(Topic *)topic;
- (void)removeNote:(Note *)note;
- (void)removeEntry:(Entry *)entry;

- (void)removePhoto:(Photo *)photo;
- (void)removeSketchPath:(SketchPath *)path;
- (void)removeAllSketchPathFromPhoto:(Photo *)photo;
- (void)removeKeyWord:(KeyWord *)keyWord;

- (void)removeAttendant:(Attendant *)attendant;

- (id)insertNewObjectForEntityForName:(NSString *)name;

- (void)moveNote:(Note *)note toTopic:(Topic *)topic;
- (void)associateTopics:(NSArray *)topics toNote:(Note *)note;

- (void)updateAttendee:(Attendant *)attendant;

@end
