//
//  BNoteFilterButton.m
//  BeNote
//
//  Created by kristin young on 7/29/12.
//
//

#import "BNoteFilterButton.h"

@interface BNoteFilterButton()
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIColor *highlightColor;
@property (strong, nonatomic) id<BNoteFilterDelegate> delegate;

@end

@implementation BNoteFilterButton
@synthesize delegate = _delegate;
@synthesize color = _color;
@synthesize highlightColor = _highlightColor;

- (id)initWithIcon:(UIImageView *)imageView andBNoteFilterDelegate:(id<BNoteFilterDelegate>)delegate
{
    self = [super init];
    if (self) {
        [self setDelegate:delegate];
        [self setIcon:imageView];
        
        float width = 45;
        float height = 35;
        
        [self setFrame:CGRectMake(0, 0, width, height)];

        float x = [self frame].size.width / 2.0 - [imageView frame].size.width / 2.0;
        float y = [self frame].size.height / 2.0 - [imageView frame].size.height / 2.0 + 2;
        width = [imageView frame].size.width;
        height = [imageView frame].size.height;
        
        [imageView setFrame:CGRectMake(x, y, width, height)];

        [self setupTouchEvents];
    }
    
    return self;
}

- (id)initWithName:(NSString *)name andBNoteFilterDelegate:(id<BNoteFilterDelegate>)delegate
{
    self = [super init];
    if (self) {
        [self setTitle:name forState:UIControlStateNormal];
        [self setDelegate:delegate];
        
        float width = MAX([[[self titleLabel] text] length] * 10 + 15, 40);
        [self setFrame:CGRectMake(0, 0, width, 35)];
        [self setAutoresizingMask:UIViewAutoresizingNone];
        
        [self setTitleColor:[BNoteConstants darkGray]
                   forState:(UIControlStateNormal)];
        [self setTitleColor:[BNoteConstants appColor1]
                   forState:(UIControlStateSelected)];

        [self setupTouchEvents];
    }
    
    return self;   
}

- (void)setupTouchEvents
{
    [self addTarget:self action:@selector(execute:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(unhighlight:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(highlight:) forControlEvents:UIControlEventTouchDown];
}

- (void)execute:(id)sender
{
    
}

- (void)highlight:(id)sender
{
    [self setColor:[self backgroundColor]];
    [self setBackgroundColor:[self highlightColor]];
}

- (void)unhighlight:(id)sender
{
    [self setBackgroundColor:[self color]];
}

- (id<BNoteFilterDelegate>)delegate
{
    return _delegate;
}

@end
