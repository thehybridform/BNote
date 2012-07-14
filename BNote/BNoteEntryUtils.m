//
//  BNoteEntryUtils.m
//  BNote
//
//  Created by Young Kristin on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteEntryUtils.h"
#import "BNoteImageUtils.h"
#import "BNoteFilterFactory.h"
#import "BNoteFilter.h"
#import "BNoteWriter.h"
#import "BNoteFactory.h"
#import "Entry.h"
#import "Attendants.h"
#import "Photo.h"
#import "TopicGroup.h"

@implementation BNoteEntryUtils

+ (Attendant *)findMatch:(Attendants *)attendants withFirstName:(NSString *)first andLastName:(NSString *)last
{
    for (Attendant *attendant in [attendants children]) {
        if ([[attendant firstName] isEqualToString:first] && [[attendant lastName] isEqualToString:last]) {
            return attendant;
        }
    }
    
    return nil;
}

+ (NSString *)formatDetailTextForActionItem:(ActionItem *)actionItem
{
    NSString *detailText = @"";
    
    if ([actionItem responsibility]) {
        detailText = [BNoteStringUtils append:@" Responsibility: ", [actionItem responsibility], nil];
    }
    
    if ([actionItem dueDate]) {
        NSDate *dueDate = [NSDate dateWithTimeIntervalSinceReferenceDate:[actionItem dueDate]]; 
        detailText = [BNoteStringUtils append:detailText, @" - Due on ", [BNoteStringUtils dateToString:dueDate], nil];
    }
    
    if ([actionItem completed]) {
        NSDate *completed = [NSDate dateWithTimeIntervalSinceReferenceDate:[actionItem completed]]; 
        detailText = [BNoteStringUtils append:detailText, @" - Completed on ", [BNoteStringUtils dateToString:completed], nil];
    }
        
    return [BNoteStringUtils nilOrEmpty:detailText] ? nil : detailText;
}

+ (NSString *)formatDetailTextForQuestion:(Question *)question
{
    NSString *detailText = [question answer];
    
    return [BNoteStringUtils nilOrEmpty:detailText] ? nil : detailText;
}

+ (BOOL)containsAttendants:(Note *)note
{
    for (Entry *entry in [note entries]) {
        if ([entry isKindOfClass:[Attendants class]]) {
            return YES;
        }
    }
    
    return NO;
}

+ (NSMutableArray *)attendants:(Note *)note
{
    return [BNoteEntryUtils filter:note with:[BNoteFilterFactory create:AttendantType]];
}

+ (NSMutableArray *)attendees:(Note *)note
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    for (Attendants *parent in [BNoteEntryUtils attendants:note]) {
        for (Attendant *child in [parent children]) {
            [data addObject:child];
        }
    }
    
    return data;
}


+ (NSMutableArray *)filter:(Note *)note with:(id<BNoteFilter>)filter
{
    NSMutableArray *filtered = [[NSMutableArray alloc] init];
    for (Entry *entry in [note entries]) {
        if ([filter accept:entry]) {
            [filtered addObject:entry];
        }
    }
    
    return filtered;
}

+ (UIImage *)handlePhoto:(NSDictionary *)info forKeyPoint:(KeyPoint *)keyPoint saveToLibrary:(BOOL)save
{
    [[BNoteWriter instance] removePhoto:[keyPoint photo]];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *originalImageData = UIImageJPEGRepresentation(image, 0.8);

    Photo *photo = [BNoteFactory createPhoto:keyPoint];
    [photo setOriginal:originalImageData];

    [BNoteEntryUtils updateThumbnailPhotos:image forKeyPoint:keyPoint];

    if (save) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil , nil);
    }
    
    return image;
}

+ (void)updateThumbnailPhotos:(UIImage *)image forKeyPoint:(KeyPoint *)keyPoint;
{
    Photo *photo = [keyPoint photo];
    
    NSData *sketch = UIImageJPEGRepresentation(image, 0.8);
    [photo setSketch:sketch];
    
    CGSize thumbnailSize = CGSizeMake(75.0, 75.0);
    UIImage *thumb = [BNoteImageUtils image:image scaleAndCropToMaxSize:thumbnailSize];
    NSData *thumbImageData = UIImageJPEGRepresentation(thumb, 0.8);
    [photo setThumbnail:thumbImageData];
    
    CGSize smallSize = CGSizeMake(42.0, 42.0);
    UIImage *small = [BNoteImageUtils image:image scaleAndCropToMaxSize:smallSize];
    NSData *smallImageData = UIImageJPEGRepresentation(small, 0.8);
    [photo setSmall:smallImageData];
    
    [[BNoteWriter instance] update];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KeyPointPhotoUpdated object:keyPoint];
}

+ (BOOL)multipleTopics:(Note *)note
{
    for (TopicGroup *group in [[note topic] groups]) {
        if ([[group name] compare:@"All"] == NSOrderedSame) {
            return [[group topics] count] > 1;
        }
    }
    
    return NO;
}

@end
