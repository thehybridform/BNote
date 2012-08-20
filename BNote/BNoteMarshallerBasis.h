//
//  BNoteMarshallerBasis.h
//  BeNote
//
//  Created by kristin young on 8/17/12.
//
//

#import <Foundation/Foundation.h>
#import "BNoteExportFileWrapper.h"

@interface BNoteMarshallerBasis : NSObject

- (void)write:(NSString *)string into:(BNoteExportFileWrapper *)file;
- (NSString *)toString:(NSTimeInterval)time;

@end
