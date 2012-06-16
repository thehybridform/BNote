//
//  EditNoteViewPresenter.m
//  BeNote
//
//  Created by Young Kristin on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditNoteViewPresenter.h"
#import "NoteEditorViewController.h"

@implementation EditNoteViewPresenter

+ (void)present:(Note *)note in:(UIViewController *)controller
{
    NoteEditorViewController *noteController = [[NoteEditorViewController alloc] initWithNote:note];
    [noteController setModalPresentationStyle:UIModalPresentationFullScreen];
    [noteController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];

    [controller presentModalViewController:noteController animated:YES];
}

@end
