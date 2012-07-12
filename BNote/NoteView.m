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
#import "BNoteConstants.h"

@interface NoteView()
@property (strong, nonatomic) UIActionSheet *actionSheet;

@end

@implementation NoteView
@synthesize actionSheet = _actionSheet;
@synthesize note = _note;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        [self setBackgroundColor:[BNoteConstants appColor1]];
        
        UILabel *text = [[UILabel alloc] init];
        [text setText:@"Add New Note"];
        [text setFont:[BNoteConstants font:RobotoRegular andSize:14]];
        [text setFrame:CGRectMake(13, 40, 100, 30)];
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
    //[LayerFormater roundCornersForView:self];
    [LayerFormater setBorderWidth:1 forView:self];
    [LayerFormater setBorderColor:[BNoteConstants appHighlightColor1] forView:self];
    [LayerFormater addShadowToView:self ofSize:1.0];
    
//    UILongPressGestureRecognizer *longPress =
//    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTap:)];
//    [self addGestureRecognizer:longPress];
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
    if (![self actionSheet]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Note" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove" otherButtonTitles:nil];
        [self setActionSheet:actionSheet];
    
        CGRect rect = [self bounds];
        [actionSheet showFromRect:rect inView:self animated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [[BNoteWriter instance] removeNote:[self note]];
            [[NSNotificationCenter defaultCenter] postNotificationName:TopicUpdated object:nil];
            break;
            
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self setActionSheet:nil];
}

@end
