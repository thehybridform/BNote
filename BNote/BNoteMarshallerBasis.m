//
//  BNoteMarshallerBasis.m
//  BeNote
//
//  Created by kristin young on 8/17/12.
//
//

#import "BNoteMarshallerBasis.h"

@interface BNoteMarshallerBasis()
@property (strong, nonatomic) NSDateFormatter *formatter;

@end

@implementation BNoteMarshallerBasis
@synthesize formatter = _formatter;

- (id)init
{
    self = [super init];
    
    if (self) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        
        [formatter setLocale:enUSPOSIXLocale];
        [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        self.formatter = formatter;
    }
    
    return self;
}

- (void)write:(NSString *)string into:(BNoteExportFileWrapper *)file
{
    if (string) {
        [file.file writeData:[string dataUsingEncoding:NSUnicodeStringEncoding]];
    }
}

- (NSString *)toString:(NSTimeInterval)time
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
    return [self.formatter stringFromDate:date];
}

@end
