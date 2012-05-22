//
//  BNoteReader.m
//  BNote
//
//  Created by Young Kristin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteReader.h"

@interface BNoteReader()

- (id)initSingleton;

@end

@implementation BNoteReader
@synthesize context = _context;

- (id)initSingleton
{
    self = [super init];
    
    return self;
}

+ (BNoteReader *)instance
{
    static BNoteReader *_default = nil;
    
    if (_default != nil) {
        return _default;
    }
    
    static dispatch_once_t safer;
    dispatch_once(&safer, ^{
        _default = [[BNoteReader alloc] initSingleton];
    });
    
    return _default;
}


- (NSMutableArray *)allTopics
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Topic"];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *topics = [[self context] executeFetchRequest:fetchRequest error:&error];
    
    if (topics != nil) {
        return [topics mutableCopy];
    } else {
        return [NSMutableArray array];
    }
}


@end
