//
//  NoteEditorViewController.h
//  BNote
//
//  Created by Young Kristin on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "EntriesViewController.h"
#import "AttendantsViewController.h"
#import "DatePickerViewController.h"
#import "Entry.h"
#import "BNoteFilterDelegate.h"
#import "BNoteExporterViewController.h"

@interface NoteEditorViewController : UIViewController
    <DatePickerViewControllerListener,
     UIActionSheetDelegate,
     UIPopoverControllerDelegate,
     BNoteFilterDelegate,
     UITextFieldDelegate,
     BNoteExportedDelegate>

@property (strong, nonatomic) Note *note;

- (IBAction)done:(id)sender;
- (IBAction)editMode:(id)sender;

- (IBAction)addKeyPoint:(id)sender;
- (IBAction)addQuestion:(id)sender;
- (IBAction)addDecision:(id)sender;
- (IBAction)addActionItem:(id)sender;
- (IBAction)editEntries:(id)sender;
- (IBAction)addAttendies:(id)sender;

- (void)selectEntry:(Entry *)entry;

- (IBAction)addSummary:(id)sender;

- (IBAction)about:(id)sender;

@end

