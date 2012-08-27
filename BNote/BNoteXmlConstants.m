//
//  BNoteXmlConstants.m
//  BeNote
//
//  Created by kristin young on 8/26/12.
//
//

#import "BNoteXmlConstants.h"

NSString *const kBeNoteOpen =
    @"<?xml version=\"1.0\" encoding=\"UTF-16\"?>\
        <benote xmlns=\"http://docs.uobia.net/2012/benote/XMLSchema-instance-1.0\"\
                xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\
                xsi:schemaLocation=\"http://docs.uobia.net/2012/benote/XMLSchema-instance-1.0\
                http://docs.uobia.net/2012/benote/XMLSchema-instance-1.0/benote-1.0.xsd\">\n";

NSString *const kBeNoteClose = @"</benote>\n";

NSString *const kCreated = @"created-date";
NSString *const kLastUpdated = @"last-updated-date";
NSString *const kText = @"text";

NSString *const kNote = @"note";
NSString *const kNoteColor = @"color";
NSString *const kSubject = @"subject";
NSString *const kSummary = @"summary";
NSString *const kTopicName = @"topic";
NSString *const kAssociatedTopicName = @"associated-topic";

NSString *const kKeyPoint = @"key-point";
NSString *const kPhoto = @"photo";
NSString *const kLocation = @"location";
NSString *const kFormat = @"format";
NSString *const kJpeg = @"image/jpeg";

NSString *const kDecision = @"decision";

NSString *const kQuestion = @"question";
NSString *const kAnswer = @"answer";

NSString *const kActionItem = @"action-item";
NSString *const kDueDate = @"due-date";
NSString *const kCompletedDate = @"completed-date";

NSString *const kResponsibility = @"responsibility";
NSString *const kFirstName = @"firstname";
NSString *const kLastName = @"lastname";
NSString *const kEmail = @"email";

static NSString *kDateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'";
static NSString *kDateLocale = @"en_US_POSIX";

@implementation BNoteXmlConstants


+ (NSString *)colorToString:(long)color
{
    return [[[NSNumberFormatter alloc] init] stringFromNumber:[NSNumber numberWithLong:color]];
}

+ (long)longFromString:(NSString *)color
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *number = [formatter numberFromString:color];

    return [number longValue];
}

+ (NSString *)toString:(NSTimeInterval)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:kDateLocale];
    
    [formatter setLocale:enUSPOSIXLocale];
    [formatter setDateFormat:kDateFormat];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:time]];
}

+ (NSTimeInterval)toTimeInterval:(NSString *)time
{
    if ([BNoteStringUtils nilOrEmpty:time]) {
        return 0;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:kDateLocale];
    
    [formatter setLocale:enUSPOSIXLocale];
    [formatter setDateFormat:kDateFormat];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
 
    return [[formatter dateFromString:time] timeIntervalSinceReferenceDate];;
}

@end
