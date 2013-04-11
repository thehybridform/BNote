//
// Created by kristinyoung on 4/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "EntityMigrator.h"


@interface EntityMigratorBasis : NSObject <EntityMigrator>

- (id <NSFastEnumeration>)entities:(NSManagedObjectContext *)context;
- (NSString *)name;
- (void)clone:(id)from to:(id)to in:(NSManagedObjectContext *)context;
- (id)findEntity:(NSString *)name withId:(NSString *)id in:(NSManagedObjectContext *)context;

@end