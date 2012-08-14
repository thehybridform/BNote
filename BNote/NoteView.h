//
//  NoteView.h
//  BNote
//
//  Created by Young Kristin on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@interface NoteView : UIView <UIActionSheetDelegate, UIPopoverControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) Note *note;
@property (assign, nonatomic) BOOL associated;

@end

