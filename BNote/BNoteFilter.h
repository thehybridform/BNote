//
//  BNoteFilter.h
//  BNote
//
//  Created by Young Kristin on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BNoteFilter <NSObject>

- (BOOL)accept:(id)item;

@end
