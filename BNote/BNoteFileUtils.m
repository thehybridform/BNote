//
//  BNoteFileUtils.m
//  BeNote
//
//  Created by kristin young on 8/27/12.
//
//

#import "BNoteFileUtils.h"

@implementation BNoteFileUtils

+ (void)primeFileForWriting:(NSString *)filename
{
    NSError *error;
    [@"" writeToFile:filename atomically:NO encoding:NSUnicodeStringEncoding error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
}

@end
