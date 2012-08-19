//
//  BNoteExporterViewController.h
//  BeNote
//
//  Created by kristin young on 8/15/12.
//
//

#import <UIKit/UIKit.h>

@interface BNoteExporterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

- (id)initWithDefault;

- (IBAction)close:(id)sender;
- (IBAction)export:(id)sender;

@end
