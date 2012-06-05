//
//  NoteView.h
//  BNote
//
//  Created by Young Kristin on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "NoteEditorViewController.h"

@protocol NoteViewDelegate;

@interface NoteView : UIView <UIActionSheetDelegate>

@property (strong, nonatomic) Note *note;
@property (assign, nonatomic) id<NoteViewDelegate> delegate;

@end

@protocol NoteViewDelegate <NSObject>

@required
- (void)deleteNote:(Note *)note;

@end
