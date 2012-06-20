//
//  ActionItemEntryCell.h
//  BeNote
//
//  Created by Young Kristin on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntryTableCellBasis.h"

@interface ActionItemEntryCell : EntryTableCellBasis <DatePickerViewControllerListener, UIPopoverControllerDelegate>


- (void)showDatePicker;

@end
