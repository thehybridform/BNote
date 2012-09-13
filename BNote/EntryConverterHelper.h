//
//  EntryConverterHelper.h
//  BeNote
//
//  Created by kristin young on 8/6/12.
//
//

#import <Foundation/Foundation.h>
#import "Entry.h"

@interface EntryConverterHelper : NSObject <UIActionSheetDelegate>

- (void)handleConvertion:(Entry *)entry withinView:(UIView *)view;

@end

