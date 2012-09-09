//
//  BNoteMarshallerBasis.m
//  BeNote
//
//  Created by kristin young on 8/17/12.
//
//

#import "BNoteMarshallerBasis.h"

@interface BNoteMarshallerBasis()

@end

@implementation BNoteMarshallerBasis

- (id)init
{
    self = [super init];
    
    if (self) {

    }
    
    return self;
}

- (void)write:(NSString *)string into:(BNoteExportFileWrapper *)file
{
    if (string) {
        [file.file writeData:[string dataUsingEncoding:NSUnicodeStringEncoding]];
    }
}

@end
