//
//  BNoteFilterButton.h
//  BeNote
//
//  Created by kristin young on 7/29/12.
//
//

#import <UIKit/UIKit.h>
#import "BNoteFilterDelegate.h"
#import "BNoteButton.h"

@interface BNoteFilterButton : BNoteButton

- (id)initWithIcon:(UIImageView *)imageView andBNoteFilterDelegate:(id<BNoteFilterDelegate>)delegate;
- (id)initWithName:(NSString *)name andBNoteFilterDelegate:(id<BNoteFilterDelegate>)delegate;
- (void)execute:(id)sender;
- (id<BNoteFilterDelegate>)delegate;

@end
