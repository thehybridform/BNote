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

@interface TopicManagementViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIPopoverController *popup;

- (id)initWithNote:(Note *)note forType:(TopicSelectType)type;
- (IBAction)done:(id)sender;

@end

