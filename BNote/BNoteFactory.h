//
//  BNoteFactory.h
//  BNote
//
//  Created by Young Kristin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Topic.h"
#import "Note.h"
#import "Question.h"
#import "ActionItem.h"
#import "KeyPoint.h"
#import "Decision.h"

@interface BNoteFactory : NSObject

+ (Topic *)createTopic:(NSString *)name;
+ (Note *)createNote:(Topic *)topic;
+ (Question *)createQuestion:(Note *)note;
+ (ActionItem *)createActionItem:(Note *)note;
+ (KeyPoint *)createKeyPoint:(Note *)note;
+ (Decision *)createDecision:(Note *)note;

+(UIView *)createHighlightSliver:(UIColor *)color;

@end
