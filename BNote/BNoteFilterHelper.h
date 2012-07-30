//
//  BNoteFilterHelper.h
//  BeNote
//
//  Created by kristin young on 7/29/12.
//
//

#import <UIKit/UIKit.h>
#import "BNoteFilterDelegate.h"

@interface BNoteFilterHelper : NSObject

+ (void)setupFilterButtonsFor:(id<BNoteFilterDelegate>)delegate inView:(UIScrollView *)scrollView;

@end
