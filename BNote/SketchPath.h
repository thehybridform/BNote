//
//  SketchPath.h
//  BeNote
//
//  Created by Young Kristin on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface SketchPath : NSManagedObject

@property (nonatomic, retain) id bezierPath;
@property (nonatomic, retain) id pathColor;
@property (nonatomic, retain) Photo *photo;

@end
