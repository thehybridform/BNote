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

@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (assign, nonatomic) id<DatePickerViewControllerListener> listener;

- (id)initWithDate:(NSDate *)date;
- (id)initWithDate:(NSDate *)date andMode:(UIDatePickerMode)mode;

- (IBAction)updateDateTime:(id)sender;
- (IBAction)didFinish:(id)sender;

@end

@protocol DatePickerViewControllerListener <NSObject>

@required
- (void)dateTimeUpdated:(NSDate *)date;
- (void)selectedDatePickerViewDone;

@end
