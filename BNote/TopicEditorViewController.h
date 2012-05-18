//
//  TopicEditorViewController.h
//  BNote
//
//  Created by Young Kristin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topic.h"

@protocol TopicEditorViewControllerDelegate;

@interface TopicEditorViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (strong, nonatomic) id<TopicEditorViewControllerDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) Topic *topic;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonAction;

@property (strong, nonatomic) IBOutlet UIButton *button_1;
@property (strong, nonatomic) IBOutlet UIButton *button_2;
@property (strong, nonatomic) IBOutlet UIButton *button_3;
@property (strong, nonatomic) IBOutlet UIButton *button_4;
@property (strong, nonatomic) IBOutlet UIButton *button_5;
@property (strong, nonatomic) IBOutlet UIButton *button_6;
@property (strong, nonatomic) IBOutlet UIButton *button_7;
@property (strong, nonatomic) IBOutlet UIButton *button_8;
@property (strong, nonatomic) IBOutlet UIButton *button_9;
@property (strong, nonatomic) IBOutlet UIButton *selectedColor;
@property (strong, nonatomic) NSNumber *currentColor;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)color1Selected:(id)sender;
- (IBAction)color2Selected:(id)sender;
- (IBAction)color3Selected:(id)sender;
- (IBAction)color4Selected:(id)sender;
- (IBAction)color5Selected:(id)sender;
- (IBAction)color6Selected:(id)sender;
- (IBAction)color7Selected:(id)sender;
- (IBAction)color8Selected:(id)sender;
- (IBAction)color9Selected:(id)sender;

- (id)initWithDefaultNib;

@end

@protocol TopicEditorViewControllerDelegate <NSObject>

@required
- (void)didFinish:(TopicEditorViewController *)controller;
- (void)didCancel:(TopicEditorViewController *)controller;


@end
