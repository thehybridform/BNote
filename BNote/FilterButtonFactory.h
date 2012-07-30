//
//  FilterButtonFactory.h
//  BeNote
//
//  Created by kristin young on 7/29/12.
//
//

#import <UIKit/UIKit.h>
#import "BNoteFilterDelegate.h"

@interface FilterButtonFactory : NSObject

+ (NSArray *)buildButtions:(id<BNoteFilterDelegate>)delegate;

@end
