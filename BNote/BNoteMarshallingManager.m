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
#import "ActionItemMarshaller.h"
#import "AttendeeMarshaller.h"
#import "BNoteReader.h"
#import "ZipWriteStream.h"
#import "BNoteXmlConstants.h"
#import "BNoteFileUtils.h"

@interface BNoteMarshallingManager()
@property (strong, nonatomic) NSMutableArray *marshallers;

- (id)initSingleton;

@end

@implementation BNoteMarshallingManager
@synthesize marshallers = _marshallers;

static NSString *xmlFile = @"bnote.xml";

- (BNoteExportFileWrapper *)marshall:(id)data
{
    NSString *documentsDirectory = [NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"];
    NSString *path = [documentsDirectory
                      stringByAppendingPathComponent:xmlFile];
    
    [BNoteFileUtils primeFileForWriting:path];
    
    NSFileHandle *file = [NSFileHandle fileHandleForWritingAtPath:path];
    
    BNoteExportFileWrapper *fileWrapper = [[BNoteExportFileWrapper alloc] init];
    fileWrapper.filename = path;
    fileWrapper.file = file;
    
    NSString *zipPath = [documentsDirectory
                      stringByAppendingPathComponent:@"benote.zip"];
    
    ZipFile *zipFile= [[ZipFile alloc] initWithFileName:zipPath mode:ZipFileModeCreate];
    fileWrapper.zipFile = zipFile;
    
    [self initMarshallers];
    
    [self write:kBeNoteOpen into:fileWrapper];
    if (data) {
        [self marshall:data into:fileWrapper];
    } else {
        for (TopicGroup *group in [[BNoteReader instance] allTopicGroups]) {
            [self marshall:group into:fileWrapper];
        }
    }
    [self write:kBeNoteClose into:fileWrapper];
    
    [file closeFile];
    
    [self clearMarshallers];
    
    ZipWriteStream *stream = [zipFile writeFileInZipWithName:[@"benote/xml/" stringByAppendingString:xmlFile] compressionLevel:ZipCompressionLevelBest];
    [stream writeData:[NSData dataWithContentsOfFile:path]];
    [stream finishedWriting];
    
    [zipFile close];

    return fileWrapper;
}

- (void)marshall:(id)data into:(BNoteExportFileWrapper *)file
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

- (void)initMarshallers
{
    NSMutableArray *marshallers = [[NSMutableArray alloc] init];
    self.marshallers = marshallers;
    
    [marshallers addObject:[[TopicGroupMarshaller alloc] init]];
    [marshallers addObject:[[TopicMarshaller alloc] init]];
    [marshallers addObject:[[NoteMarshaller alloc] init]];
    [marshallers addObject:[[AttendeeMarshaller alloc] init]];
    [marshallers addObject:[[KeyPointMarshaller alloc] init]];
    [marshallers addObject:[[DecisionMarshaller alloc] init]];
    [marshallers addObject:[[QuestionMarshaller alloc] init]];
    [marshallers addObject:[[ActionItemMarshaller alloc] init]];
    
    self.marshalledNotes = [[NSMutableArray alloc] init];
}

- (void)clearMarshallers
{
    self.marshallers = nil;
    self.marshalledNotes = nil;
}

- (id)initSingleton
{
    self = [super init];
    
    if (self) {
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
