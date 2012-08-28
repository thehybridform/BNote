//
//  MainViewViewController.h
//  BeNote
//
//  Created by Young Kristin on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNoteExporterViewController.h"
#import "TopicGroupSelector.h"
#import "MasterViewController.h"

@interface MainViewViewController : UIViewController <UIPopoverControllerDelegate, UISearchBarDelegate, UIActionSheetDelegate, BNoteExportedDelegate, TopicGroupSelector, TopicSelector>

@property (strong, nonatomic) Topic *searchTopic;

- (id)initWithDefault;

- (IBAction)about:(id)sender;
- (IBAction)presentShareOptions:(id)sender;
- (IBAction)showTopicGroups:(id)sender;

- (void)presentImportController:(NSURL *)url;

@end
