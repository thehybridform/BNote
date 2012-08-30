//
//  BNoteQuickWordUtils.m
//  BeNote
//
//  Created by kristin young on 7/30/12.
//
//

#import "BNoteQuickWordUtils.h"
#import "KeyWordFinder.h"
#import "ToTheRightKeyWordFinder.h"
#import "ToTheLeftKeyWordFinder.h"
#import "SelectedKeyWordFinder.h"


@implementation BNoteQuickWordUtils

static NSString *spaceRegex = @"^(\\w)";

+ (NSString *)extractKeyWordFromTextView:(UITextView *)textView
{
    
    NSString *text;
    for (id<KeyWordFinder> finder in [self finders]) {
        text = [finder find:textView];
        if (text) {
            return text;
        }
    }
    
    return nil;
}

+ (BOOL)leftCharacterIsWord:(NSString *)text at:(int)position
{
    NSRange range = NSMakeRange(position - 1, 1);
    NSString *character = [text substringWithRange:range];
    
    range = [character rangeOfString:spaceRegex options:NSRegularExpressionSearch];
    
    return range.length == 1;
}


+ (NSArray *)finders
{
    NSMutableArray *finders = [[NSMutableArray alloc] init];
    
    [finders addObject:[[SelectedKeyWordFinder alloc] init]];
    
    ToTheRightKeyWordFinder *rightFinder = [[ToTheRightKeyWordFinder alloc] init];
    [finders addObject:rightFinder];
    
    ToTheLeftKeyWordFinder *leftFinder = [[ToTheLeftKeyWordFinder alloc] init];
    [leftFinder setFinder:rightFinder];
    [finders addObject:leftFinder];
    
    return finders;
    
}

@end
