//
//  TopicManagementViewController.h
//  BeNote
//
//  Created by Young Kristin on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

typedef enum {
    ChangeMainTopic,
    AssociateTopic,
    CopyToTopic
} TopicSelectType;

@protocol TopicManagementViewControllerDelegate;

@interface TopicManagementViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) id<TopicManagementViewControllerDelegate> delegate;

- (id)initWithNote:(Note *)note forType:(TopicSelectType)type;

@end

@protocol TopicManagementViewControllerDelegate <NSObject>

- (void)finishedWithTopic:(Topic *)topic;

@end
