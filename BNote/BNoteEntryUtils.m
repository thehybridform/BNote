//
//  BNoteEntryUtils.m
//  BNote
//
//  Created by Young Kristin on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteImageUtils.h"
#import "BNoteWriter.h"
#import "BNoteFactory.h"

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

+ (BOOL)topicContainsAttendants:(Topic *)topic
{
    for (Note *note in [topic notes]) {
        if ([BNoteEntryUtils noteContainsAttendants:note]) {
            return YES;
        }
    }
    for (Note *note in [topic associatedNotes]) {
        if ([BNoteEntryUtils noteContainsAttendants:note]) {
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL)noteContainsAttendants:(Note *)note
{
    return [self attendantsEntryForNote:note] != nil;
}

+ (Attendants *)attendantsEntryForNote:(Note *)note
{
    for (Entry *entry in [note entries]) {
        if ([entry isKindOfClass:[Attendants class]]) {
            return (Attendants *) entry;
        }
    }
    
    return nil;
}

+ (NSMutableArray *)attendants:(Note *)note
{
    return [BNoteEntryUtils filter:note with:[[BNoteFilterFactory instance] create:AttendantType]];
}

+ (NSMutableArray *)actionItems:(Note *)note
{
    return [BNoteEntryUtils filter:note with:[[BNoteFilterFactory instance] create:ActionItemType]];
}

+ (NSMutableArray *)decisions:(Note *)note
{
    return [BNoteEntryUtils filter:note with:[[BNoteFilterFactory instance] create:DecistionType]];
}

+ (NSMutableArray *)keyPoints:(Note *)note
{
    return [BNoteEntryUtils filter:note with:[[BNoteFilterFactory instance] create:KeyPointType]];
}

+ (NSMutableArray *)questions:(Note *)note
{
    return [BNoteEntryUtils filter:note with:[[BNoteFilterFactory instance] create:QuestionType]];
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kKeyPointPhotoUpdated object:keyPoint];
}

+ (BOOL)multipleTopics:(Note *)note
{
    for (TopicGroup *group in [[note topic] groups]) {
        if ([[group name] compare:kAllTopicGroupName] == NSOrderedSame) {
            return [[group topics] count] > 1;
        }
    }
    
    return NO;
}

+ (void)cleanUpEntriesForNote:(Note *)note
{
    NSMutableSet *emptyEntries = [[NSMutableSet alloc] init];
    
    for (Attendants *attendants in [BNoteEntryUtils attendants:note]) {
        if (![[attendants children] count]) {
            [emptyEntries addObject:attendants];
        }
    }

    for (KeyPoint *keyPoint in [BNoteEntryUtils keyPoints:note]) {
        BOOL emptyText = [BNoteStringUtils nilOrEmpty:[keyPoint text]];
        BOOL noPhoto = ![keyPoint photo];
        if (emptyText && noPhoto) {
            [emptyEntries addObject:keyPoint];
        }
    }

    for (Question *question in [BNoteEntryUtils questions:note]) {
        BOOL emptyQuestion = [BNoteStringUtils nilOrEmpty:[question text]];
        BOOL emptyAnswer = [BNoteStringUtils nilOrEmpty:[question answer]];
        
        if (emptyQuestion && emptyAnswer) {
            [emptyEntries addObject:question];
        }
    }

    [self collectEmptyEntries:[BNoteEntryUtils decisions:note] into:emptyEntries];
    [self collectEmptyEntries:[BNoteEntryUtils actionItems:note] into:emptyEntries];

    [[BNoteWriter instance] removeObjects:[emptyEntries allObjects]];
    
    BOOL noSubject = [BNoteStringUtils nilOrEmpty:[note subject]];
    BOOL noSummary = [BNoteStringUtils nilOrEmpty:[note summary]];
    BOOL noEntries = ![[note entries] count];
    
    if (noSubject && noSummary && noEntries) {
        [[BNoteWriter instance] removeNote:note];
    }
}

+ (void)collectEmptyEntries:(NSMutableArray *)entries into:(NSMutableSet *)emptyEntries
{
    for (Entry *entry in entries) {
        if ([BNoteStringUtils nilOrEmpty:[entry text]]) {
            [emptyEntries addObject:entry];
        }
    }
}

+ (NSString *)topicGroupName:(TopicGroup *)topicGroup
{
    if ([[topicGroup name] isEqualToString:kAllTopicGroupName]) {
        return NSLocalizedString(@"All", nil);
    }
    
    return [topicGroup name];
}

@end
