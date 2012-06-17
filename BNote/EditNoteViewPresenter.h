//
//  EditNoteViewPresenter.h
//  BeNote
//
//  Created by Young Kristin on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "Entry.h"

@interface EditNoteViewPresenter : NSObject

+ (void)presentNote:(Note *)note in:(UIViewController *)controller;
+ (void)presentEntry:(Entry *)entry in:(UIViewController *)controller;

@end
