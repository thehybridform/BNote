//
//  KeyPointButton.m
//  BNote
//
//  Created by Young Kristin on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KeyPointButton.h"
#import "BNoteWriter.h"
#import "BNoteFactory.h"
#import "BNoteImageUtils.h"
#import "BNoteEntryUtils.h"

@interface KeyPointButton()

@end

@implementation KeyPointButton
@synthesize keyPoint = _keyPoint;
@synthesize imagePickerController = _imagePickerController;

- (void)initCommon
{
    [self setImagePickerController:[[UIImagePickerController alloc] init]];
    [[self imagePickerController] setDelegate:self];
}

- (UIImage *)handlePhoto:(NSDictionary *)info
{
    KeyPoint *keyPoint = (KeyPoint *) [[self entryCellView] entry];
    return [BNoteEntryUtils handlePhoto:info forKeyPoint:keyPoint];
}

@end
