//
//  BNoteArchiverManager.m
//  BeNote
//
//  Created by kristin young on 8/15/12.
//
//

#import "BNoteArchiverManager.h"
#import "EmailArchiver.h"

@interface BNoteArchiverManager()

- (id)initSingleton;

@end

@implementation BNoteArchiverManager

- (id)initSingleton
{
    self = [super init];
    
    if (self) {
    }
    
    return self;
}

- (NSArray *)archivers
{
    NSMutableArray *archivers = [[NSMutableArray alloc] init];
    [archivers addObject:[[EmailArchiver alloc] init]];
    
    return archivers;
}

+ (BNoteArchiverManager *)instance
{
    static BNoteArchiverManager *_default = nil;
    
    if (_default != nil) {
        return _default;
    }
    
    static dispatch_once_t safer;
    dispatch_once(&safer, ^{
        _default = [[BNoteArchiverManager alloc] initSingleton];
    });
    
    return _default;
}

@end
