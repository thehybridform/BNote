//
//  TopicGroupManagementViewController.h
//  BeNote
//
//  Created by Young Kristin on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicGroupManagementViewController : UIViewController <UIPopoverControllerDelegate, UITextFieldDelegate>
@property (strong, nonatomic) UIPopoverController *popup;

- (IBAction)add:(id)sender;
- (IBAction)done:(id)sender;

@end
