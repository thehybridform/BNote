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
@property (strong, nonatomic) NSMutableArray *archivers;

- (id)initSingleton;

@end

@implementation BNoteArchiverManager
@synthesize archivers = _archivers;

- (id)initSingleton
{
    self = [super init];
    
    if (self) {
        NSMutableArray *archivers = [[NSMutableArray alloc] init];
        self.archivers = archivers;
        
        [archivers addObject:[[EmailArchiver alloc] init]];
    }
    
    return self;
}

- (NSArray *)archivers
{
    return _archivers;
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
