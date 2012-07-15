//
//  TableCellHeaderViewController.m
//  BeNote
//
//  Created by Young Kristin on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TableCellHeaderViewController.h"
#import "LayerFormater.h"

@interface TableCellHeaderViewController ()
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation TableCellHeaderViewController
@synthesize titleLabel = _titleLabel;
@synthesize name = _name;

- (id)initWithTitle:(NSString *)title
{
    self = [super initWithNibName:@"TableCellHeaderViewController" bundle:nil];
    if (self) {
        [self setName:title];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    [LayerFormater addShadowToView:[self view] ofSize:5];
    [[self view] setBackgroundColor:[BNoteConstants appHighlightColor1]];
    [[self titleLabel] setFont:[BNoteConstants font:RobotoRegular andSize:13.0]];
    [[self titleLabel] setText:[self name]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setTitleLabel:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
