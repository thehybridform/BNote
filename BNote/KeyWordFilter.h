//
//  KeyWordFilter.h
//  BeNote
//
//  Created by kristin young on 7/29/12.
//
//

#import <UIKit/UIKit.h>
#import "BNoteFilter.h"

@interface KeyWordFilter : NSObject <BNoteFilter>

- (id)initWithSearchString:(NSString *)text;

@end
