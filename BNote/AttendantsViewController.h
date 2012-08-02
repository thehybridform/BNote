//
//  AttendantsViewController.h
//  BNote
//
//  Created by Young Kristin on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "Attendants.h"


@interface AttendantsViewController : UIViewController

@property (strong, nonatomic) Attendants *attendants;

- (void)update;


@end
