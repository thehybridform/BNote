//
//  KeyWordFinder.h
//  BeNote
//
//  Created by kristin young on 7/30/12.
//
//

#import <Foundation/Foundation.h>

@protocol KeyWordFinder <NSObject>

- (NSString *)find:(UITextView *)textView;

@end
