//
//  EmailViewController.h
//  BNote
//
//  Created by Young Kristin on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topic.h"
#import "Note.h"

@interface EmailViewController : MFMailComposeViewController <MFMailComposeViewControllerDelegate>

- (id)initWithAttachment:(NSData *)attachment mimeType:(NSString *)mimeType filename:(NSString *)filename;
- (id)initWithTopic:(Topic *)topic;
- (id)initWithNote:(Note *)note;

@end
