//
//  SelectedKeyWordFinder.m
//  BeNote
//
//  Created by kristin young on 7/30/12.
//
//

#import "SelectedKeyWordFinder.h"

@implementation SelectedKeyWordFinder

- (NSString *)find:(UITextView *)textView
{
    UITextRange *range = [textView selectedTextRange];
    NSString *word = [textView textInRange:range];
    
    if (![BNoteStringUtils nilOrEmpty:word]) {
        return word;
    }

    return nil;
}

@end
