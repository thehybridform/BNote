//
//  BNoteLiteViewController.h
//  BeNote
//
//  Created by kristin young on 8/4/12.
//
//

#import <UIKit/UIKit.h>
#import "TopicGroupSelector.h"

@protocol ShowHelpProtocol;

@interface BNoteLiteViewController : UIViewController

@property (strong, nonatomic) id<TopicGroupSelector> topicGroupSelector;
@property (assign, nonatomic) BOOL firstLoad;
@property (strong, nonatomic) id<ShowHelpProtocol> helpDelegate;

- (id)initWithDefault;

- (IBAction)close:(id)sender;
- (IBAction)ok:(id)sender;
- (IBAction)generateHelpNotes:(id)sender;
- (IBAction)openGoolePlus:(id)sender;
- (IBAction)showLicense:(id)sender;

@end
