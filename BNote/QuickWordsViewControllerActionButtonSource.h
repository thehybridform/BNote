//
//  QuickWordsViewControllerActionButtonSource.h
//  BeNote
//
//  Created by kristin young on 9/6/12.
//
//

#import <Foundation/Foundation.h>

@protocol QuickWordsViewControllerActionButtonSource <NSObject>

@optional
- (BOOL)doNotResizeActionButton;

@required
- (NSArray *)quickActionButtons;

@end
