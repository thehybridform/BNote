//
// Created by kristinyoung on 4/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@protocol EntityMigrator <NSObject>

- (BOOL)migrateFrom:(NSManagedObjectContext *)context to:(NSManagedObjectContext *)to;

@end