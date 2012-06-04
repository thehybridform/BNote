//
//  AttendantsViewController.h
//  BNote
//
//  Created by Young Kristin on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "AttendantView.h"


@interface AttendantsViewController : UIViewController <AttendantViewDelegate>

@property (strong, nonatomic) Note *note;
@property (strong, nonatomic) IBOutlet UILabel *attendantHelpLable;

- (void)update;


@end
