//
//  PhotoEditorViewController.h
//  BeNote
//
//  Created by Young Kristin on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyPoint.h"

@interface PhotoEditorViewController : UIViewController
@property (assign, nonatomic) KeyPoint *keyPoint;

- (id)initDefault;

- (IBAction)done:(id)sender;
- (IBAction)selectColor:(UIButton *)button;
- (IBAction)selectPencil:(UIButton *)button;
- (IBAction)undo:(id)sender;
- (IBAction)redo:(id)sender;
- (IBAction)reset:(id)sender;

@end
