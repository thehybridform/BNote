//
//  PhotoUnmarshaller.m
//  BeNote
//
//  Created by kristin young on 8/27/12.
//
//

#import "PhotoUnmarshaller.h"
#import "BNoteFactory.h"
#import "Photo.h"
#import "BNoteUnarshallingManager.h"
#import "ZipFile.h"
#import "ZipReadStream.h"
#import "BNoteFileUtils.h"

@implementation PhotoUnmarshaller
@synthesize keyPoint = _keyPoint;

static NSString *kJpegFileName = @"bnote-temp.jpeg";

- (NSString *)nodeName
{
    return kPhoto;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:kLocation]) {
        self.nodeType = LocationNode;
    } else {
        self.nodeType = NoNode;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)text
{
    NSString *string = [BNoteStringUtils trim:text];
    
    switch (self.nodeType) {
        case LocationNode:
        {
            @try {
                ZipFile *zipFile = [BNoteUnarshallingManager instance].zipFile;
                if ([zipFile locateFileInZip:string]) {
                    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
                    NSString *filename = [documentsDirectory stringByAppendingPathComponent:kJpegFileName];

                    [BNoteFileUtils primeFileForWriting:filename];
                    
                    ZipReadStream *stream = [zipFile readCurrentFileInZip];
                    [BNoteUnarshallingManager writeZipReadStream:stream toFile:filename];
                
                    NSData *data = [NSData dataWithContentsOfFile:filename];
                    UIImage *image = [UIImage imageWithData:data];

                    UIImageWriteToSavedPhotosAlbum(image, nil, nil , nil);

                    [BNoteFactory createPhoto:self.keyPoint];
                    [self.keyPoint.photo setOriginal:data];
                
                    [BNoteEntryUtils updateThumbnailPhotos:image forKeyPoint:self.keyPoint];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
            @finally {
            }
        }
            break;
            
        default:
            break;
    }
}

@end
