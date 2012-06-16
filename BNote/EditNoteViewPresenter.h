//
//  EditNoteViewPresenter.h
//  BeNote
//
//  Created by Young Kristin on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"

@interface EditNoteViewPresenter : NSObject

+ (void)present:(Note *)note in:(UIViewController *)controller;

@end
