//
//  AttendantView.m
//  BNote
//
//  Created by Young Kristin on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AttendantView.h"
#import "BNoteFactory.h"

@interface AttendantView()
@property (strong, nonatomic) UIActionSheet *sheet;

@end

@implementation AttendantView
@synthesize attendant = _attendant;
@synthesize sheet = _sheet;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [BNoteFactory createIcon:AttendantIcon];
        [imageView setFrame:CGRectMake(32, 1, 35, 35)];
        [self addSubview:imageView];
        
        UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(normalPressTap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)normalPressTap:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Attendant" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove" otherButtonTitles:@"Details", nil];

    CGRect rect = [self bounds];
    [sheet showFromRect:rect inView:self animated:YES];
    
    [self setSheet:sheet];
}

- (void)setAttendant:(Attendant *)attendant
{
    _attendant = attendant;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 35, 90, 45)];
    [nameLabel setLineBreakMode:UILineBreakModeWordWrap];
    [nameLabel setTextAlignment:UITextAlignmentCenter];
    [nameLabel setFont:[UIFont systemFontOfSize:12]];
    [nameLabel setNumberOfLines:1];
    
    
    NSString *name = [[[attendant firstName] stringByAppendingString:@" "] stringByAppendingString:[attendant lastName]];
    [nameLabel setText:name];
    
    [self addSubview:nameLabel];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [[self delegate] remove:[self attendant]];
            break;
            
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self setSheet:nil];
}

@end
