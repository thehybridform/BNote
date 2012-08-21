//
//  InformationViewController.h
//  BeNote
//
//  Created by Young Kristin on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicGroupSelector.h"

@interface InformationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) id<TopicGroupSelector> topicGroupSelector;

- (id)initWithDefault;

- (IBAction)done:(id)sender;

@end
