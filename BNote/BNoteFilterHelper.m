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
#import "BNoteAnimation.h"

@implementation BNoteFilterHelper

+ (void)setupFilterButtonsFor:(id<BNoteFilterDelegate>)delegate inView:(UIScrollView *)scrollView
{
    for (UIView *view in [scrollView subviews]) {
        [view removeFromSuperview];
    }
    
    float height = [scrollView frame].size.height;
    
    NSArray *buttons = [FilterButtonFactory buildButtions:delegate];
    
    float delay = 0;
    float delayIncrement = 0.1;
    int spacing = 2;
    int x = 5;
    
    for (UIButton *button in buttons) {        
        float width = [button frame].size.width;

        int y = 0;

        CGRect frame = CGRectMake(x, y, width, height);
        [button setFrame:frame];
        
        [scrollView addSubview:button];
        
        [BNoteAnimation winkInView:button withDuration:0.03 andDelay:delay += delayIncrement spark:YES];
        
        x += spacing + width;
    }
    
    [scrollView setContentSize:CGSizeMake(x, height)];
}

@end
