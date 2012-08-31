//
//  BNoteUnarshallingManager.m
//  BeNote
//
//  Created by kristin young on 8/22/12.
//
//

#import "BNoteUnarshallingManager.h"
#import "FileInZipInfo.h"
#import "ZipException.h"
#import "RootUnmarshaller.h"
#import "BNoteWriter.h"
#import "BNoteFileUtils.h"
#import "BNoteXmlConstants.h"

@interface BNoteUnarshallingManager()
@property (strong, nonatomic) id<NSXMLParserDelegate> benoteParser;

- (id)initSingleton;

@end

@implementation BNoteUnarshallingManager
@synthesize benoteParser = _benoteParser;
@synthesize zipFile = _zipFile;
@synthesize errors = _errors;

static int BUFFER_SIZE = 1024;
static NSString *kBeNote = @"benote";

- (void)delegate:(id<UnmarshallerListener>)delegate unmarshallUrl:(NSURL *)url
{
    self.errors = [[NSMutableArray alloc] init];
    
    @try {
        self.zipFile = [[ZipFile alloc] initWithFileName:url.path mode:ZipFileModeUnzip];

        NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *filename = [documentsDirectory stringByAppendingPathComponent:kBeNoteXmlFile];

        BOOL result = [self extractXml:self.zipFile toFile:filename];
        if (result) {

            NSInputStream *in = [[NSInputStream alloc] initWithFileAtPath:filename];
        
            NSXMLParser *parser = [[NSXMLParser alloc] initWithStream:in];
            
            parser.delegate = self;
        
            BOOL result = [parser parse];
            if (!result) {
                NSLog(@"failed to parse");
            }
        }
    }
    @catch (ZipException *exception) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Note Import Errors", nil)
                              message:NSLocalizedString(@"import failed message corrupt xml", nil)
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                              otherButtonTitles:nil];
        
        [alert show];
    }
    @finally {
        if (self.zipFile) {
            [self.zipFile close];
            self.zipFile = nil;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefetchAllDatabaseData object:nil];
        [[BNoteWriter instance] update];
        
        if (self.errors.count) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"Note Import Error", nil)
                                  message:NSLocalizedString(@"import failed message", nil)
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                  otherButtonTitles:nil];
            
            [alert show];
        }
    }
}

- (BOOL)extractXml:(ZipFile *)zipFile toFile:(NSString *)filename
{
    NSString *xml;
    NSArray *infos= [zipFile listFileInZipInfos];
    for (FileInZipInfo *info in infos) {
        if ([info.name hasSuffix:kBeNoteXmlFile]) {
            xml = info.name;
            break;
        }
    }
        
    if (xml && [zipFile locateFileInZip:xml]) {
        [BNoteFileUtils primeFileForWriting:filename];
        ZipReadStream *stream = [zipFile readCurrentFileInZip];
        [BNoteUnarshallingManager writeZipReadStream:stream toFile:filename];
        return YES;
    }
    
    return NO;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:kBeNote]) {
        self.benoteParser = [[RootUnmarshaller alloc] init];
        parser.delegate = self.benoteParser;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:kBeNote]) {
        self.benoteParser = nil;
        parser.delegate = self;
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"%@", parser);
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
    NSLog(@"%@", parser);
}

+ (void)writeZipReadStream:(ZipReadStream *)stream toFile:(NSString *)filename
{
    NSFileHandle *tempFile= [NSFileHandle fileHandleForWritingAtPath:filename];
    NSMutableData *buffer= [[NSMutableData alloc] initWithLength:BUFFER_SIZE];
    
    int bytesRead;
    do {
        
        [buffer setLength:BUFFER_SIZE];
        
        bytesRead = [stream readDataWithBuffer:buffer];
        if (bytesRead > 0) {
            [buffer setLength:bytesRead];
            [tempFile writeData:buffer];
        }
        
    } while (bytesRead > 0);
    
    [stream finishedReading];
    [tempFile closeFile];
}

- (id)initSingleton
{
    self = [super init];
    
    if (self) {
    }
    
    return self;
}

+ (BNoteUnarshallingManager *)instance
{
    static BNoteUnarshallingManager *_default = nil;
    
    if (_default != nil) {
        return _default;
    }
    
    static dispatch_once_t safer;
    dispatch_once(&safer, ^{
        _default = [[BNoteUnarshallingManager alloc] initSingleton];
    });
    
    return _default;
}

@end
