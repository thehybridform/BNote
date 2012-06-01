//
//  DatePickerViewController.h
//  BNote
//
//  Created by Young Kristin on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerViewControllerListener;

@interface DatePickerViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (assign, nonatomic) id<DatePickerViewControllerListener> listener;

- (id)initWithDate:(NSDate *)date;

- (IBAction)updateDateTime:(id)sender;
- (void)didFinish:(id)sender;

@end

@protocol DatePickerViewControllerListener <NSObject>

@required
- (void)dateTimeUpdated:(NSDate *)date;
- (void)didFinishDatePicker;

@end
