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

@end

@implementation AttendantView
@synthesize attendant = _attendant;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [BNoteFactory createIcon:AttendantIcon];
        [imageView setFrame:CGRectMake(36, 1, 45, 45)];
        [self addSubview:imageView];
    }
    return self;
}

- (void)setAttendant:(Attendant *)attendant
{
    _attendant = attendant;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 46, 109, 45)];
    [nameLabel setLineBreakMode:UILineBreakModeWordWrap];
    [nameLabel setTextAlignment:UITextAlignmentCenter];
    
    
    NSString *name = [[[attendant firstName] stringByAppendingString:@" "] stringByAppendingString:[attendant lastName]];
    [nameLabel setText:name];
    
    [self addSubview:nameLabel];
}
@end
