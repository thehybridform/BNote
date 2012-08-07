//
//  EntryConverter.h
//  BeNote
//
//  Created by kristin young on 8/6/12.
//
//

#import <Foundation/Foundation.h>

#import "Entry.h"

@protocol EntryConverter <NSObject>

@required

- (BOOL)convert:(Entry *)entryFrom to:(Entry *)entryTo;

@end
