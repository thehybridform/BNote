//
//  TopicManagementViewController.h
//  BeNote
//
//  Created by Young Kristin on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@protocol TopicManagementViewControllerListener;

typedef enum {
    ChangeMainTopic,
    AssociateTopic
} TopicSelectType;

@interface TopicManagementViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (assign, nonatomic) id<TopicManagementViewControllerListener> listener;

- (id)initWithNote:(Note *)note forType:(TopicSelectType)type;
- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end

@protocol TopicManagementViewControllerListener <NSObject>

- (void)selectedTopics:(NSArray *)topics;
- (void)changeTopic:(Topic *)topic;

@end