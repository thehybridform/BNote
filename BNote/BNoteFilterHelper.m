//
//  BNoteFilterHelper.m
//  BeNote
//
//  Created by kristin young on 7/29/12.
//
//

#import "BNoteFilterHelper.h"
#import "FilterButtonFactory.h"
#import "LayerFormater.h"

@implementation BNoteFilterHelper

+ (void)setupFilterButtonsFor:(id<BNoteFilterDelegate>)delegate inView:(UIScrollView *)scrollView
{
    for (UIView *view in [scrollView subviews]) {
        [view removeFromSuperview];
    }
    
    float height = [scrollView frame].size.height;
    
    NSArray *buttons = [FilterButtonFactory buildButtions:delegate];
    
    int spacing = 2;
    int x = 5;
    
    for (UIButton *button in buttons) {        
        float width = [button frame].size.width;

        int y = 0;

        CGRect frame = CGRectMake(x, y, width, height);
        [button setFrame:frame];
        
        [scrollView addSubview:button];
        
        x += spacing + width;
    }
    
    [scrollView setContentSize:CGSizeMake(x, height)];
}

@end
