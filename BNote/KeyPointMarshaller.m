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

@implementation KeyPointMarshaller

static NSString *kKeyPoint = @"key-point";

- (BOOL)accept:(id)obj
{
    return [obj isKindOfClass:[KeyPoint class]];
}

- (void)marshall:(KeyPoint *)keyPoint into:(NSFileHandle *)file
{
    [self write:[BNoteXmlFormatter openTag:kKeyPoint] into:file];
    
    NSString *s = [BNoteXmlFormatter node:kText withText:keyPoint.text];
    [self write:s into:file];
    
    s = [BNoteXmlFormatter node:kCreated withText:[self toString:keyPoint.created]];
    [self write:s into:file];

    s = [BNoteXmlFormatter node:kLastUpdated withText:[self toString:keyPoint.lastUpdated]];
    [self write:s into:file];
    
    [self write:[BNoteXmlFormatter closeTag:kKeyPoint] into:file];
}

@end
