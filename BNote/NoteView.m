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
#import "BNoteWriter.h"
#import "TopicManagementViewController.h"
#import "BNoteSessionData.h"

@interface NoteView()
@property (assign, nonatomic) BOOL drawRibbon;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (strong, nonatomic) UIColor *highColor;

@end

@implementation NoteView
@synthesize note = _note;
@synthesize drawRibbon = _drawRibbon;
@synthesize associated = _associated;
@synthesize highColor = _highColor;
@synthesize gradientLayer = _gradientLayer;;

static NSString *copyNote = @"Copy";
static NSString *removeNote = @"Remove";
static NSString *moveNote = @"Move";
static NSString *associateNote = @"Associate";
static NSString *disassociateNote = @"Disassociate";

const static float x1 = 6;
const static float x2 = x1 + 10;
const static float x3 = x2 + 10;
const static float h1 = 44;
const static float h2 = h1 - 10;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDrawRibbon:NO];
        [self commonInit];
        [self setBackgroundColor:[BNoteConstants appColor1]];
        
        UILabel *text = [[UILabel alloc] init];
        [text setText:@"Add Note"];
        [text setFont:[BNoteConstants font:RobotoLight andSize:13]];
        [text setFrame:CGRectMake(5, 43, 90, 30)];
        [text setTextColor:[BNoteConstants appHighlightColor1]];
        [text setCenter:CGPointMake(50, 50)];
        [text setTextAlignment:UITextAlignmentCenter];
        [text setBackgroundColor:[UIColor clearColor]];
        [text setClipsToBounds:NO];
 
        [text setBackgroundColor:[BNoteConstants appColor1]];

        [self addSubview:text];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self) {
        [self setDrawRibbon:YES];
        [self commonInit];

        UILongPressGestureRecognizer *longPress =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTap:)];
        [self addGestureRecognizer:longPress];
    }
    
    return self;
}

- (void)commonInit
{
    [LayerFormater roundCornersForView:self to:5];
    [LayerFormater setBorderWidth:2 forView:self];
    [LayerFormater setBorderColor:[BNoteConstants appHighlightColor1] forView:self];
    
    [self setBackgroundColor:[BNoteConstants appColor1]];
    
    [self setGradientLayer:[self setupGradient]];
    
    [[self layer] insertSublayer:[self gradientLayer] atIndex:0];
    
    [self setHighColor:UIColorFromRGB(0xeeeeee)];
}

- (CAGradientLayer *)setupGradient
{
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    
    // Set its bounds to be the same of its parent
    CGRect bounds = CGRectMake(0, 0, 500, [self bounds].size.height);
    [gradientLayer setBounds:bounds];
    
    // Center the layer inside the parent layer
    [gradientLayer setPosition:
     CGPointMake([self bounds].size.width/2,
                 [self bounds].size.height/2)];
    
    return gradientLayer;
}

- (void)drawRect:(CGRect)rect
{
    if ([self drawRibbon]) {
        CGContextRef context = UIGraphicsGetCurrentContext();
    
        UIColor *color = UIColorFromRGB([[self note] color]);
    
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextSetLineWidth(context, 1.0);
        CGContextMoveToPoint(context, x1, 0.0);
        CGContextAddLineToPoint(context, x1, h1);
        CGContextAddLineToPoint(context, x2, h2);
        CGContextAddLineToPoint(context, x3, h1);
        CGContextAddLineToPoint(context, x3, 0);
        CGContextClosePath(context);
        CGContextFillPath(context);
        CGContextStrokePath(context);
    }
    if ([self highColor]) {
        // Set the colors for the gradient to the
        // two colors specified for high and low
        [[self gradientLayer] setColors:
         [NSArray arrayWithObjects:
          (id)[[self highColor] CGColor],
          (id)[UIColorFromRGB([[self note] color]) CGColor],
          nil]];
        
        [[self gradientLayer] setHidden:YES];
    }
    
    [super drawRect:rect];
}

-(void)longPressTap:(id)sender
{
    if ([[[self note] topic] color] == FilterColor) {
        return;
    }
    
    if (![[BNoteSessionData instance] actionSheet]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        [actionSheet setDelegate:[BNoteSessionData instance]];
        [[BNoteSessionData instance] setActionSheetDelegate:self];
        [[BNoteSessionData instance] setActionSheet:actionSheet];
        
        [actionSheet addButtonWithTitle:copyNote];
        
        if ([BNoteEntryUtils multipleTopics:[self note]] &&![self associated]) {
            [actionSheet addButtonWithTitle:moveNote];
            [actionSheet addButtonWithTitle:associateNote];
        }
        
        if ([self associated]) {
            [actionSheet addButtonWithTitle:disassociateNote];
        } else {
            NSInteger index = [actionSheet addButtonWithTitle:removeNote];
            [actionSheet setDestructiveButtonIndex:index];
        }
                
        [actionSheet setTitle:@"Note Options"];
        
        CGRect rect = [self bounds];
        [actionSheet showFromRect:rect inView:self animated:YES];
        
        [LayerFormater setBorderColor:[UIColor redColor] forView:self];
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
        } else if (title == associateNote) {
            [self presentTopicSelectionForType:AssociateTopic];
        } else if (title == disassociateNote) {
            Topic *topic = [[BNoteSessionData instance] selectedTopic];
            [[BNoteWriter instance] disassociateNote:[self note] toTopic:topic];
            [[NSNotificationCenter defaultCenter] postNotificationName:TopicUpdated object:topic];
        }
    }
    
    [LayerFormater setBorderColor:[BNoteConstants appHighlightColor1] forView:self];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self gradientLayer] setHidden:NO];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self gradientLayer] setHidden:YES];
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self gradientLayer] setHidden:YES];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self gradientLayer] setHidden:YES];
    [super touchesMoved:touches withEvent:event];
}

@end
