//
//  ToTheRightKeyWordFinder.m
//  BeNote
//
//  Created by kristin young on 7/30/12.
//
//

#import "ToTheRightKeyWordFinder.h"
#import "BNoteQuickWordUtils.h"

@implementation ToTheRightKeyWordFinder

static NSString *regex = @"^\\W*(\\w+)\\W?";

- (NSString *)find:(UITextView *)textView
{
    NSString *text = [textView text];
    NSRange cursorPosition = [textView selectedRange];
    
    if (cursorPosition.location < [text length] - 1) {
        int start = [self findStartOfWord:text from:cursorPosition.location];
        
        NSRange rangeToSearch = NSMakeRange((NSUInteger) start, [text length] - 1 - start);
        NSRange range = [text rangeOfString:regex options:NSRegularExpressionSearch range:rangeToSearch];
        
        [textView setSelectedRange:range];
        UITextRange *selectedRange = [textView selectedTextRange];
        NSString *word = [textView textInRange:selectedRange];
        return [BNoteStringUtils trim:word];
    }

    return nil;
}

- (int)findStartOfWord:(NSString *)text from:(int)position
{
    int current = position;
    while (current > 0 && [BNoteQuickWordUtils leftCharacterIsWord:text at:current]) {
        current--;
    }
    
    return current;
}

@end
