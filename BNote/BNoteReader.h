//
//  BNoteReader.h
//  BNote
//
//  Created by Young Kristin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNoteReader : NSObject

+ (NSMutableArray *)allTopicsInContext:(NSManagedObjectContext *)context;

@end
