//
//  Question.h
//  BeNote
//
//  Created by Young Kristin on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Entry.h"


@interface Question : Entry

@property (nonatomic, retain) NSString * answer;

@end
