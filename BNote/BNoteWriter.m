//
//  BNoteWriter.m
//  BNote
//
//  Created by Young Kristin on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteWriter.h"

@implementation BNoteWriter

+ (void)removeTopic:(Topic *)topic inContext:(NSManagedObjectContext *)context
{
    [context deleteObject:topic];
    [BNoteWriter updateContext:context];
}


+ (void)updateContext:(NSManagedObjectContext *)context
{
    [context save:nil];    
}

@end
