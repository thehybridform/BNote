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
    [note setTopic:topic];
    [self update];
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

- (void)update
{
    NSError *error = nil;

    BOOL success = [[self context] save:&error];  
    
    if (success) {
        [[NSNotificationCenter defaultCenter] postNotificationName:AllDataUpdated object:nil];
    } else {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }    
}

@end
