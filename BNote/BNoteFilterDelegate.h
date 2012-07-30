//
//  BNoteFilterDelegate.h
//  BeNote
//
//  Created by kristin young on 7/29/12.
//
//

#import <Foundation/Foundation.h>
#import "BNoteFilter.h"

@protocol BNoteFilterDelegate <NSObject>

- (void)useFilter:(id<BNoteFilter>)filter sender:(UIButton *)button;

@end
