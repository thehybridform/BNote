//
//  PeopleViewController.h
//  BeNote
//
//  Created by Young Kristin on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topic.h"

@interface PeopleViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) Topic *topic;

- (void)reset;
- (void)reload;
- (IBAction)pageChanged:(id)sender;

@end
