//
//  BNoteEntryUtils.h
//  BNote
//
//  Created by Young Kristin on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Attendant.h"
#import "Note.h"

@interface BNoteEntryUtils : NSObject

+ (Attendant *)findMatch:(Note *)note withFirstName:(NSString *)first andLastName:(NSString *)last;

@end
