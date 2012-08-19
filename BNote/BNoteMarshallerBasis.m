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
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterFullStyle];
        self.formatter = formatter;
    }
    
    return self;
}

- (void)write:(NSString *)string into:(NSFileHandle *)file
{
    if (string) {
        [file writeData:[string dataUsingEncoding:NSUnicodeStringEncoding]];
    }
}

- (NSString *)toString:(NSTimeInterval)time
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
    return [self.formatter stringFromDate:date];
}

@end
