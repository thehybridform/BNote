//
//  Phone.h
//  BNote
//
//  Created by Young Kristin on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Attendant;

@interface Phone : NSManagedObject

@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Attendant *attendant;

@end
