//
//  ToTheLeftKeyWordFinder.m
//  BeNote
//
//  Created by kristin young on 7/31/12.
//
//

#import "ToTheLeftKeyWordFinder.h"
#import "BNoteQuickWordUtils.h"
#import "ToTheRightKeyWordFinder.h"

@implementation ToTheLeftKeyWordFinder
@synthesize finder= _finder;

- (NSString *)find:(UITextView *)textView
{
    NSString *text = [textView text];
    NSRange cursorPosition = [textView selectedRange];

    int start = [self findEndOfPreviousWord:text from:cursorPosition.location];
    [textView setSelectedRange:NSMakeRange(start, 1)];
    
    return [[self finder] find:textView];
}

- (int)findEndOfPreviousWord:(NSString *)text from:(int)position
{
    int current = position;
    while (current > 0 && [BNoteQuickWordUtils leftCharacterIsWord:text at:current]) {
        current--;
    }
    
    return current;
}

@end
