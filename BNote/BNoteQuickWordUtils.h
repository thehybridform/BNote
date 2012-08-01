//
//  BNoteQuickWordUtils.h
//  BeNote
//
//  Created by kristin young on 7/30/12.
//
//

#import <Foundation/Foundation.h>

@interface BNoteQuickWordUtils : NSObject

+ (NSString *)extractKeyWordFromTextView:(UITextView *)textView;
+ (BOOL)leftCharacterIsWord:(NSString *)text at:(int)position;

@end
