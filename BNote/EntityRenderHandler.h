//
//  EntityRenderHandler.h
//  BNote
//
//  Created by Young Kristin on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entry.h"

@protocol EntityRenderHandler <NSObject>

- (BOOL)accept:(Entry *)entry;
- (NSString *)render:(Entry *)entry;

@end
