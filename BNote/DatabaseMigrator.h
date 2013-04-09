//
// Created by kristinyoung on 4/8/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface DatabaseMigrator : NSObject
+ (void)migrate:(NSManagedObjectContext *)destination;
@end