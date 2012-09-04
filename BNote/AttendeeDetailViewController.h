//
//  AttendeeDetailViewController.h
//  BeNote
//
//  Created by Young Kristin on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Attendant.h"

@interface AttendeeDetailViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) UIPopoverController *popup;

- (id)initWithAttendant:(Attendant *)attendant;

- (void)focus;

@end
