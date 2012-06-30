//
//  SketchPaths.h
//  BeNote
//
//  Created by Young Kristin on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface SketchPaths : NSManagedObject

@property (nonatomic, retain) NSData * color;
@property (nonatomic, retain) NSData * path;
@property (nonatomic, retain) Photo *photo;

@end
