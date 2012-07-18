//
//  ActionItemContentViewController.h
//  BeNote
//
//  Created by Young Kristin on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntryContentViewController.h"
#import "ResponsibilityTableViewController.h"
#import "DatePickerViewController.h"

@interface ActionItemContentViewController : EntryContentViewController <DatePickerViewControllerListener, UIPopoverControllerDelegate, ResponsibilityTableViewControllerDelegate>

- (IBAction)showDatePicker:(id)sender;
- (IBAction)clearDueDate:(id)sender;

- (IBAction)showResponsibilityPicker:(id)sender;
- (IBAction)clearResponsibilityDate:(id)sender;

@end
