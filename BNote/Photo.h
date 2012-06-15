//
//  Photo.h
//  BeNote
//
//  Created by Young Kristin on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KeyPoint;

@interface Photo : NSManagedObject

@property (nonatomic) NSTimeInterval created;
@property (nonatomic, retain) NSData * original;
@property (nonatomic, retain) NSData * small;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) KeyPoint *keyPoint;

@end
