//
//  KeyPointButton.h
//  BNote
//
//  Created by Young Kristin on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuickWordButton.h"
#import "KeyPoint.h"

@interface KeyPointButton : QuickWordButton <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) KeyPoint *keyPoint;

- (UIImage *)handlePhoto:(NSDictionary *)info;

@end
