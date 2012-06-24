//
//  AttendantView.h
//  BNote
//
//  Created by Young Kristin on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Attendant.h"

@interface AttendantView : UIView <UIActionSheetDelegate, UIPopoverControllerDelegate>

@property (assign, nonatomic) Attendant *attendant;

@end

