//
//  BNoteStringUtils.h
//  BNote
//
//  Created by Young Kristin on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNoteStringUtils : NSObject

+ (NSString *)trim:(NSString *)string;
+ (BOOL)nilOrEmpty:(NSString *)string;

@end
