//
//  BNoteMarshallingManager.m
//  BeNote
//
//  Created by kristin young on 8/16/12.
//
//

#import "BNoteMarshallingManager.h"
#import "TopicGroupMarshaller.h"
#import "TopicMarshaller.h"
#import "NoteMarshaller.h"
#import "KeyPointMarshaller.h"
#import "DecisionMarshaller.h"
#import "QuestionMarshaller.h"

@interface BNoteMarshallingManager()
@property (strong, nonatomic) NSMutableArray *marshallers;

- (id)initSingleton;

@end

@implementation BNoteMarshallingManager
@synthesize marshallers = _marshallers;

- (NSFileHandle *)marshall:(id)data
{
    NSString *documentsDirectory = [NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"];
    NSString *path = [documentsDirectory
                      stringByAppendingPathComponent:@"bnote.xml"];
    
    NSError *error;
    [@"" writeToFile:path atomically:NO encoding:NSUnicodeStringEncoding error:&error];
    
    NSFileHandle *file = [NSFileHandle fileHandleForWritingAtPath:path];
    
    [self write:kBeNoteOpen into:file];
    [self marshall:data into:file];
    [self write:kBeNoteClose into:file];
    
    [file closeFile];
    
    if (error) {
        NSLog(@"%@",error);
    }
    
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUnicodeStringEncoding
                                                     error:&error];
    if (error) {
        NSLog(@"%@",error);
    }

    NSLog(@"%@",content);
    
    return file;
}

- (void)marshall:(id)data into:(NSFileHandle *)file
{
    for (id<BNoteMarshaller> marshaller in self.marshallers) {
        if ([marshaller accept:data]) {
            [marshaller marshall:data into:file];
        }
    }
}

- (BOOL)accept:(id)obj
{
    return NO;
}

- (id)initSingleton
{
    self = [super init];
    
    if (self) {
        NSMutableArray *marshallers = [[NSMutableArray alloc] init];
        self.marshallers = marshallers;
        
        [marshallers addObject:[[TopicGroupMarshaller alloc] init]];
        [marshallers addObject:[[TopicMarshaller alloc] init]];
        [marshallers addObject:[[NoteMarshaller alloc] init]];
        [marshallers addObject:[[KeyPointMarshaller alloc] init]];
        [marshallers addObject:[[DecisionMarshaller alloc] init]];
        [marshallers addObject:[[QuestionMarshaller alloc] init]];
    }
    
    return self;
}

+ (BNoteMarshallingManager *)instance
{
    static BNoteMarshallingManager *_default = nil;
    
    if (_default != nil) {
        return _default;
    }
    
    static dispatch_once_t safer;
    dispatch_once(&safer, ^{
        _default = [[BNoteMarshallingManager alloc] initSingleton];
    });
    
    return _default;
}

@end
