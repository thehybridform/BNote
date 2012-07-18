//
//  KeyPointContentViewController.h
//  BeNote
//
//  Created by Young Kristin on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntryContentViewController.h"

@interface KeyPointContentViewController : EntryContentViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (IBAction)presentPhotoEditor:(id)sender;
- (IBAction)presentCamera:(id)sender;
- (IBAction)presentPhotoAlbum:(id)sender;

@end

