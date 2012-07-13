//
//  Cloner.h
//  BeNote
//
//  Created by Young Kristin on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Cloner <NSObject>

- (id)clone:(id)object into:(id)parent;

@end
