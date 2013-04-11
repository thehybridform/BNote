//
// Created by kristinyoung on 4/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "KeyPointMigrator.h"
#import "Photo.h"
#import "SketchPath.h"


@implementation KeyPointMigrator {

}

- (NSString *)name {
    return @"KeyPoint";
}

- (void)clone:(KeyPoint *)from to:(KeyPoint *)to in:(NSManagedObjectContext *)context {
    to.created = from.created;
    to.lastUpdated = from.lastUpdated;
    to.text = from.text;

    Note *note = [self findEntity:@"Note" withId:from.note.id in:context];
    to.note = note;

    Photo *photo = from.photo;

    if (photo) {
        Photo *newPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        newPhoto.created = photo.created;
        newPhoto.original = photo.original;
        newPhoto.sketch = photo.sketch;
        newPhoto.small = photo.small;
        newPhoto.thumbnail = photo.thumbnail;
        to.photo = newPhoto;

        for (SketchPath *sketchPath in photo.sketchPaths) {
            SketchPath *newSketchPath = [NSEntityDescription insertNewObjectForEntityForName:@"SketchPath" inManagedObjectContext:context];
            newSketchPath.bezierPath = sketchPath.bezierPath;
            newSketchPath.pathColor = sketchPath.pathColor;
            [newPhoto addSketchPathsObject:newSketchPath];
        }
    }
}

@end