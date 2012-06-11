//
//  BNoteRenderer.h
//  BNote
//
//  Created by Young Kristin on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Topic.h"

@protocol BNoteRenderer <NSObject>

@required
- (NSString *)render:(Topic *)topic;

@end
