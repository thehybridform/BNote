//
//  KeyPointMarshaller.m
//  BeNote
//
//  Created by kristin young on 8/17/12.
//
//

#import "KeyPointMarshaller.h"
#import "KeyPoint.h"
#import "BNoteXmlFormatter.h"
#import "BNoteMarshallingManager.h"
#import "ZipWriteStream.h"
#import "Photo.h"
#import "BNoteXmlConstants.h"

@implementation KeyPointMarshaller


- (BOOL)accept:(id)obj
{
    return [obj isKindOfClass:[KeyPoint class]];
}

- (void)marshall:(KeyPoint *)keyPoint into:(BNoteExportFileWrapper *)file
{
    [self write:[BNoteXmlFormatter openTag:kKeyPoint] into:file];
    
    NSString *s = [BNoteXmlFormatter node:kText withText:keyPoint.text];
    [self write:s into:file];
    
    s = [BNoteXmlFormatter node:kCreated withText:[BNoteXmlConstants toString:keyPoint.created]];
    [self write:s into:file];

    s = [BNoteXmlFormatter node:kLastUpdated withText:[BNoteXmlConstants toString:keyPoint.lastUpdated]];
    [self write:s into:file];
    
    if (keyPoint.photo) {
        NSString *location =
            [@"benote/photos/" stringByAppendingString:[[BNoteStringUtils guuid] stringByAppendingString:@".jpeg"]];
        
        ZipWriteStream *stream = [file.zipFile writeFileInZipWithName:location compressionLevel:ZipCompressionLevelBest];

        Photo *photo = [keyPoint photo];
        NSData *data;
        if ([[photo sketchPaths] count]) {
            data = [photo sketch];
        } else {
            data = [photo original];
        }
        
        [stream writeData:data];
        [stream finishedWriting];

        [self write:[BNoteXmlFormatter openTag:kPhoto] into:file];
 
        s = [BNoteXmlFormatter node:kLocation withText:location];
        [self write:s into:file];

        [self write:[BNoteXmlFormatter closeTag:kPhoto] into:file];
    }
    
    [self write:[BNoteXmlFormatter closeTag:kKeyPoint] into:file];
}

@end
