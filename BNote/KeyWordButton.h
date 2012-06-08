//
//  KeyWordButton.h
//  BNote
//
//  Created by Young Kristin on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuickWordButton.h"
#import "KeyWord.h"

@interface KeyWordButton : QuickWordButton <UIActionSheetDelegate>

@property (strong, nonatomic) KeyWord *keyWord;

@end