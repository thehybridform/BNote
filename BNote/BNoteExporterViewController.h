//
//  BNoteExporterViewController.h
//  BeNote
//
//  Created by kristin young on 8/15/12.
//
//

#import <UIKit/UIKit.h>
#import "BNoteExportFileWrapper.h"

@protocol BNoteExportedDelegate;

@interface BNoteExporterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) id<BNoteExportedDelegate> delegate;
@property (strong, nonatomic) Note *note;

- (id)initWithDefault;

- (IBAction)close:(id)sender;
- (IBAction)export:(id)sender;

@end

@protocol BNoteExportedDelegate <NSObject>

- (void)finishedWithFile:(BNoteExportFileWrapper *)file;

@end