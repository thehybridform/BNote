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

@implementation BNoteEntryUtils

+ (Attendant *)findMatch:(Attendants *)attendants withFirstName:(NSString *)first andLastName:(NSString *)last
{
    NSEnumerator *entries = [[attendants children] objectEnumerator];
    Entry *entry;
    
    while (entry = [entries nextObject]) {
        if ([entry isKindOfClass:[Attendant class]]) {
            Attendant *attendant = (Attendant *) entry;
            if ([[attendant firstName] isEqualToString:first] && [[attendant lastName] isEqualToString:last]) {
                return attendant;
            }
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
    NSEnumerator *entries = [[note entries] objectEnumerator];
    Entry *entry;
    
    while (entry = [entries nextObject]) {
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
    
    NSEnumerator *attendants = [[BNoteEntryUtils attendants:note] objectEnumerator];
    Attendants *parent;
    while (parent = [attendants nextObject]) {
        NSEnumerator *children = [[parent children] objectEnumerator];
        Attendant *child;
        while (child = [children nextObject]) {
            [data addObject:child];
        }
    }
    
    return data;
}


+ (NSMutableArray *)filter:(Note *)note with:(id<BNoteFilter>)filter
{
    NSMutableArray *filtered = [[NSMutableArray alloc] init];
    NSEnumerator *entries = [[note entries] objectEnumerator];
    Entry *entry;
    
    while (entry = [entries nextObject]) {
        if ([filter accept:entry]) {
            [filtered addObject:entry];
        }
    }
    
    return filtered;
}

+ (UIImage *)handlePhoto:(NSDictionary *)info forKeyPoint:(KeyPoint *)keyPoint
{
    [[BNoteWriter instance] removePhoto:[keyPoint photo]];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *originalImageData = UIImageJPEGRepresentation(image, 0.8);
    
    Photo *photo = [BNoteFactory createPhoto:keyPoint];
    [photo setOriginal:originalImageData];

    [BNoteEntryUtils updateThumbnailPhotos:image forKeyPoint:keyPoint];
    
    /*
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
    */
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


@end
