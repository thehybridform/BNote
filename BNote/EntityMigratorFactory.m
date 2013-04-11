//
// Created by kristinyoung on 4/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EntityMigratorFactory.h"
#import "TopicGroupMigrator.h"
#import "TopicMigrator.h"
#import "NoteMigrator.h"
#import "KeyWordMigrator.h"
#import "QuestionMigrator.h"
#import "DecisionMigrator.h"
#import "AttendantsMigrator.h"
#import "AttendantMigrator.h"
#import "KeyPointMigrator.h"


@implementation EntityMigratorFactory {

}

+ (id <NSFastEnumeration>)migrators {
    NSMutableArray *migrator = [[NSMutableArray alloc] init];

    [migrator addObject:[[KeyWordMigrator alloc] init]];
    [migrator addObject:[[TopicGroupMigrator alloc] init]];
    [migrator addObject:[[TopicMigrator alloc] init]];
    [migrator addObject:[[NoteMigrator alloc] init]];
    [migrator addObject:[[QuestionMigrator alloc] init]];
    [migrator addObject:[[DecisionMigrator alloc] init]];
    [migrator addObject:[[AttendantsMigrator alloc] init]];
    [migrator addObject:[[AttendantMigrator alloc] init]];
    [migrator addObject:[[KeyPointMigrator alloc] init]];

    return migrator;
}

@end