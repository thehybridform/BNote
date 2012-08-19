//
//  BNoteMarshallerBasis.h
//  BeNote
//
//  Created by kristin young on 8/17/12.
//
//

#import <Foundation/Foundation.h>

@interface BNoteMarshallerBasis : NSObject

- (void)write:(NSString *)string into:(NSFileHandle *)file;
- (NSString *)toString:(NSTimeInterval)time;

@end
