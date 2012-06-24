//
//  BNoteWriter.m
//  BNote
//
//  Created by Young Kristin on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteWriter.h"

@interface BNoteWriter()

- (id)initSingleton;

@end

@implementation BNoteWriter
@synthesize context = _context;

- (id)initSingleton
{
    self = [super init];
    
    return self;
}

+ (BNoteWriter *)instance
{
    static BNoteWriter *_default = nil;
    
    if (_default != nil) {
        return _default;
    }
    
    static dispatch_once_t safer;
    dispatch_once(&safer, ^{
        _default = [[BNoteWriter alloc] initSingleton];
    });
    
    return _default;
}

- (id)insertNewObjectForEntityForName:(NSString *)name
{
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:[self context]];
}

- (void)removeTopic:(Topic *)topic
{
    [self deleteObject:topic];
}

- (void)removeNote:(Note *)note
{
    [self deleteObject:note];
}

- (void)removeEntry:(Entry *)entry
{
    
    [self deleteObject:entry];
}

- (void)removeAttendant:(Attendant *)attendant
{
    [self deleteObject:attendant];
}

- (void)removePhoto:(Photo *)photo
{
    [self deleteObject:photo];
}

- (void)removeKeyWord:(KeyWord *)keyWord
{
    [self deleteObject:keyWord];
}

- (void)deleteObject:(id)object
{
    if (object) {
        [[self context] deleteObject:object];
        [self update];
    }
}

- (void)moveNote:(Note *)note toTopic:(Topic *)topic
{
    if ([[note associatedTopics] containsObject:topic]) {
        [self disassociateNote:note toTopic:topic];
    }
    
    [note setTopic:topic];
    [note setColor:[topic color]];
    [self update];
}

- (void)associateTopics:(NSArray *)topics toNote:(Note *)note
{
    NSSet *currentTopics = [note associatedTopics];
    NSEnumerator *items = [currentTopics objectEnumerator];
    Topic *topic;
    while (topic = [items nextObject]) {
        if (![topics containsObject:topic]) {
            [self disassociateNote:note toTopic:topic];
        }
    }
    
    items = [topics objectEnumerator];
    while (topic = [items nextObject]) {
        [self associateNote:note toTopic:topic];
    }
}

- (void)associateNote:(Note *)note toTopic:(Topic *)topic
{
    [note addAssociatedTopicsObject:topic];
    [self update];
}

- (void)disassociateNote:(Note *)note toTopic:(Topic *)topic
{
    [note removeAssociatedTopicsObject:topic];
    [self update];
}

- (void)updateAttendee:(Attendant *)attendant
{
    NSString *firstName = [attendant firstName];
    NSString *lastName = [attendant lastName];
    NSString *email = [attendant email];
    
    if ([BNoteStringUtils nilOrEmpty:firstName] && [BNoteStringUtils nilOrEmpty:lastName] && [BNoteStringUtils nilOrEmpty:email]) {
        [[BNoteWriter instance] removeAttendant:attendant];
    } else {
        [[BNoteWriter instance] update];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AttendeeUpdated object:nil];    
}

- (void)update
{
    NSError *error = nil;

    BOOL success = [[self context] save:&error];  
    
    if (success) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:AllDataUpdated object:nil];
    } else {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }    
}

@end
