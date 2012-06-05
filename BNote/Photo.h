//
//  Photo.h
//  BNote
//
//  Created by Young Kristin on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KeyPoint;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSData * original;
@property (nonatomic) NSTimeInterval created;
@property (nonatomic, retain) KeyPoint *keyPoint;

@end
