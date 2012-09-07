//
//  QuickWordsViewController.h
//  BNote
//
//  Created by Young Kristin on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntryContent.h"
#import "Entry.h"
#import "EntryContentViewController.h"
#import "QuickWordsViewControllerActionButtonSource.h"

@interface QuickWordsViewController : UIViewController
@property (strong, nonatomic) id<QuickWordsViewControllerActionButtonSource> delegate;

- (id)initWithEntryContent:(id<EntryContent>)entryContentController;

- (IBAction)dates:(id)sender;
- (IBAction)keyWords:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)attendants:(id)sender;

- (void)selectFirstButton;

@end
