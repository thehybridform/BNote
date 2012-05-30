//
//  Attendant.h
//  BNote
//
//  Created by Young Kristin on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Entry.h"

@class Email, Phone;

@interface Attendant : Entry

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSOrderedSet *emails;
@property (nonatomic, retain) NSSet *phones;
@end

@interface Attendant (CoreDataGeneratedAccessors)

- (void)insertObject:(Email *)value inEmailsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromEmailsAtIndex:(NSUInteger)idx;
- (void)insertEmails:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeEmailsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInEmailsAtIndex:(NSUInteger)idx withObject:(Email *)value;
- (void)replaceEmailsAtIndexes:(NSIndexSet *)indexes withEmails:(NSArray *)values;
- (void)addEmailsObject:(Email *)value;
- (void)removeEmailsObject:(Email *)value;
- (void)addEmails:(NSOrderedSet *)values;
- (void)removeEmails:(NSOrderedSet *)values;
- (void)addPhonesObject:(Phone *)value;
- (void)removePhonesObject:(Phone *)value;
- (void)addPhones:(NSSet *)values;
- (void)removePhones:(NSSet *)values;

@end
