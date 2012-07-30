//
//  FilterButtonFactory.m
//  BeNote
//
//  Created by kristin young on 7/29/12.
//
//

#import "FilterButtonFactory.h"
#import "KeyPointFilterButton.h"
#import "QuestionFilterButton.h"
#import "DecisionFilterButton.h"
#import "ActionItemFilterButton.h"
#import "KeyWordFilterButton.h"
#import "BNoteFactory.h"
#import "BNoteReader.h"

@implementation FilterButtonFactory

+ (NSArray *)buildButtions:(id<BNoteFilterDelegate>)delegate
{
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    
    UIImageView *icon = [BNoteFactory createIcon:KeyPointIcon];
    [buttons addObject:[[KeyPointFilterButton alloc] initWithIcon:icon andBNoteFilterDelegate:delegate]];
    
    icon = [BNoteFactory createIcon:QuestionIcon];
    [buttons addObject:[[QuestionFilterButton alloc] initWithIcon:icon andBNoteFilterDelegate:delegate]];
    
    icon = [BNoteFactory createIcon:DecisionIcon];
    [buttons addObject:[[DecisionFilterButton alloc] initWithIcon:icon andBNoteFilterDelegate:delegate]];
    
    icon = [BNoteFactory createIcon:ActionItemIcon];
    [buttons addObject:[[ActionItemFilterButton alloc] initWithIcon:icon andBNoteFilterDelegate:delegate]];
    
    for (KeyWord *keyWord in [[BNoteReader instance] allKeyWords]) {
        [buttons addObject:[[KeyWordFilterButton alloc] initWithName:[keyWord word] andBNoteFilterDelegate:delegate]];
    }
    
    return buttons;
}

@end
