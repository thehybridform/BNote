//
//  TopicEditorViewController.h
//  BNote
//
//  Created by Young Kristin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topic.h"
#import "TopicGroup.h"

@protocol TopicEditorDelegate;

@interface TopicEditorViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) Topic *topic;
@property (strong, nonatomic) id<TopicEditorDelegate> delegate;

- (IBAction)done:(id)sender;

- (IBAction)color1Selected:(id)sender;
- (IBAction)color2Selected:(id)sender;
- (IBAction)color3Selected:(id)sender;
- (IBAction)color4Selected:(id)sender;
- (IBAction)color5Selected:(id)sender;
- (IBAction)color6Selected:(id)sender;
- (IBAction)color7Selected:(id)sender;
- (IBAction)color8Selected:(id)sender;
- (IBAction)color9Selected:(id)sender;
- (IBAction)color10Selected:(id)sender;
- (IBAction)color11Selected:(id)sender;
- (IBAction)color12Selected:(id)sender;

- (id)initWithTopicGroup:(TopicGroup *)group;

@end


@protocol TopicEditorDelegate <NSObject>

- (void)finishedWith:(Topic *)topic;

@end