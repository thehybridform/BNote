//
//  MainViewViewController.h
//  BeNote
//
//  Created by Young Kristin on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewViewController : UIViewController <UIPopoverControllerDelegate, UISearchBarDelegate>
@property (strong, nonatomic) Topic *searchTopic;

- (id)initWithDefault;

- (IBAction)about:(id)sender;
- (IBAction)presentShareOptions:(id)sender;
- (IBAction)addTopic:(id)sender;
- (IBAction)showTopicGroups:(id)sender;

@end
