//
//  EluaViewController.h
//  BeNote
//
//  Created by Young Kristin on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EluaViewController : UIViewController <UIScrollViewDelegate>

@property (assign, nonatomic) BOOL eula;

- (id)initWithDefault;

- (IBAction)done:(id)sender;
- (IBAction)accept:(id)sender;

@end
