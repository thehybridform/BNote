//
//  AttendantTableViewCell.m
//  BeNote
//
//  Created by Young Kristin on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AttendantTableViewCell.h"

@implementation AttendantTableViewCell
@synthesize entry = _entry;
@synthesize parentController = _parentController;

- (id)initWithIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

}

- (UIView *)view
{
    return self;
}

- (void)focus
{
    
}
@end
