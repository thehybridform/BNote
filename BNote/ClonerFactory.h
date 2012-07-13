//
//  ClonerFactory.h
//  BeNote
//
//  Created by Young Kristin on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cloner.h"

@interface ClonerFactory : NSObject

+ (id<Cloner>)clonerFor:(id)object;

@end
