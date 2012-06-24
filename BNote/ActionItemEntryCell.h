//
//  ActionItemEntryCell.h
//  BeNote
//
//  Created by Young Kristin on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntryTableCellBasis.h"
#import "ResponsibilityTableViewController.h"

@interface ActionItemEntryCell : EntryTableCellBasis <UIActionSheetDelegate, DatePickerViewControllerListener, UIPopoverControllerDelegate, ResponsibilityTableViewControllerDelegate>


- (void)showDatePicker;

@end
