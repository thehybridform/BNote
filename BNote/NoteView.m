//
//  NoteView.m
//  BNote
//
//  Created by Young Kristin on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NoteView.h"
#import "Topic.h"
#import "LayerFormater.h"
#import "NoteEditorViewController.h"
#import "EditNoteViewPresenter.h"
#import "BNoteWriter.h"
#import "TopicManagementViewController.h"
#import "BNoteSessionData.h"

@interface NoteView()
@end

@implementation NoteView
@synthesize note = _note;

static NSString *copyNote = @"Copy";
static NSString *removeNote = @"Remove";
static NSString *moveNote = @"Move";
static NSString *associateNote = @"Associate";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        [self setBackgroundColor:[BNoteConstants appColor1]];
        
        UILabel *text = [[UILabel alloc] init];
        [text setText:@"Add New Note"];
        [text setFont:[BNoteConstants font:RobotoRegular andSize:14]];
        [text setFrame:CGRectMake(13, 43, 100, 30)];
        [text setTextColor:[BNoteConstants appHighlightColor1]];
        
        [self addSubview:text];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    [LayerFormater setBorderWidth:1 forView:self];
    [LayerFormater setBorderColor:[BNoteConstants appHighlightColor1] forView:self];
    [LayerFormater addShadowToView:self ofSize:1.0];
    
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTap:)];
    [self addGestureRecognizer:longPress];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *color = UIColorFromRGB([[self note] color]);
    
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 1.0);
	CGContextMoveToPoint(context, 10, 0.0);
	CGContextAddLineToPoint(context, 10, 40);
	CGContextAddLineToPoint(context, 20, 32);
	CGContextAddLineToPoint(context, 30, 40);
	CGContextAddLineToPoint(context, 30, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
	CGContextStrokePath(context);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)longPressTap:(id)sender
{
    if (![[BNoteSessionData instance] actionSheet]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        [actionSheet setDelegate:[BNoteSessionData instance]];
        [[BNoteSessionData instance] setActionSheetDelegate:self];
        
        [actionSheet addButtonWithTitle:copyNote];
        
        if ([BNoteEntryUtils multipleTopics:[self note]]) {
            [actionSheet addButtonWithTitle:moveNote];
            [actionSheet addButtonWithTitle:associateNote];
        }
        
        NSInteger index = [actionSheet addButtonWithTitle:removeNote];
        [actionSheet setDestructiveButtonIndex:index];
        
        [actionSheet setTitle:@"Note Options"];
        [[BNoteSessionData instance] setActionSheet:actionSheet];
        
        CGRect rect = [self bounds];
        [actionSheet showFromRect:rect inView:self animated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0) {
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if (title == removeNote) {
            Topic *topic = [[self note] topic];
            [[BNoteWriter instance] removeNote:[self note]];
            [[NSNotificationCenter defaultCenter] postNotificationName:TopicUpdated object:topic];
        } else if (title == moveNote) {
            [self presentTopicSelectionForType:ChangeMainTopic];
        } else if (title == copyNote) {
            [self presentTopicSelectionForType:CopyToTopic];
        }
    }
}

- (void)presentTopicSelectionForType:(TopicSelectType)type
{
    TopicManagementViewController *controller = [[TopicManagementViewController alloc] initWithNote:[self note] forType:type];
    
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
    [[BNoteSessionData instance] setPopup:popup];
    [popup setDelegate:self];
    [controller setPopup:popup];
    
    [popup setPopoverContentSize:[[controller view] bounds].size];
    
    UIView *view = self;
    CGRect rect = [view bounds];
    
    [popup presentPopoverFromRect:rect inView:view
         permittedArrowDirections:UIPopoverArrowDirectionAny 
                         animated:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [[BNoteSessionData instance] setPopup:nil];
}

@end
