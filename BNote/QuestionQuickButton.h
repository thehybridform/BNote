//
//  QuestionQuickButton.h
//  BNote
//
//  Created by Young Kristin on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuickWordButton.h"
#import "Question.h"

@interface QuestionQuickButton : QuickWordButton

@property (strong, nonatomic) Question *question;
@property (strong, nonatomic) UITextView *textView;

@end
