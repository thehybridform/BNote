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
    [[self context] deleteObject:topic];
    [self update];
}

- (void)removeNote:(Note *)note
{
    [[self context] deleteObject:note];
    [self update];
}

- (void)update
{
    [[self context] save:nil];    
}

@end
