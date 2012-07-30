//
//  KeyWordFilter.m
//  BeNote
//
//  Created by kristin young on 7/29/12.
//
//

#import "KeyWordFilter.h"
#import "Question.h"
#import "Entry.h"

@interface KeyWordFilter()
@property (strong, nonatomic) NSString *text;

@end

@implementation KeyWordFilter
@synthesize text = _text;

- (id)initWithSearchString:(NSString *)text
{
    self = [super init];
    
    if (self) {
        [self setText:text];
    }
    
    return self;
}

- (BOOL)accept:(Entry *)item
{
    if ([item isKindOfClass:[Question class]]) {
        Question *question = (Question *) item;
        if ([question answer]) {
            NSRange range = [[question answer] rangeOfString:[self text] options:NSCaseInsensitiveSearch];
            if (range.length) {
                return YES;
            }
        }
    }
    
    if ([item text]) {
        NSRange range = [[item text] rangeOfString:[self text] options:NSCaseInsensitiveSearch];
        return range.length;
    }
    
    return NO;
}

- (void)dealloc
{
    [self setText:nil];
}

@end
