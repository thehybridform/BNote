//
//  NoteSummaryViewController.h
//  BeNote
//
//  Created by kristin young on 7/31/12.
//
//

#import <UIKit/UIKit.h>
#import "EntryContent.h"

@interface NoteSummaryViewController : UIViewController <EntryContent>
@property (assign, nonatomic) UIViewController *parentController;

- (id)initWithNote:(Note *)note;

@end
