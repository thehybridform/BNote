//
// Created by kristinyoung on 4/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "KeyWordMigrator.h"
#import "KeyWord.h"


@implementation KeyWordMigrator {

}

- (NSString *)name {
    return @"KeyWord";
}

- (void)clone:(KeyWord *)from to:(KeyWord *)to in:(NSManagedObjectContext *)context {
    to.word = from.word;
}

@end