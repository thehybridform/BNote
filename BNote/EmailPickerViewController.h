//
//  EmailPickerViewController.h
//  BNote
//
//  Created by Young Kristin on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Attendant.h"

@protocol EmailPickerViewController;

@interface EmailPickerViewController : UITableViewController

@property (assign, nonatomic) id<EmailPickerViewController>delegate;

- (id)initWithEmails:(NSArray *)emails forAttendant:(Attendant *)attendant;

@end

@protocol EmailPickerViewController <NSObject>

@required
- (void)didFinishEmailPicker;

@end