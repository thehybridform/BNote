//
//  ToTheLeftKeyWordFinder.h
//  BeNote
//
//  Created by kristin young on 7/31/12.
//
//

#import <Foundation/Foundation.h>
#import "KeyWordFinder.h"
#import "ToTheRightKeyWordFinder.h"

@interface ToTheLeftKeyWordFinder : NSObject <KeyWordFinder>

@property (strong, nonatomic) ToTheRightKeyWordFinder *finder;

@end
