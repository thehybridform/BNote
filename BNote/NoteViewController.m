//
//  NoteViewController.m
//  BeNote
//
//  Created by Young Kristin on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NoteViewController.h"
#import "NoteView.h"

@interface NoteViewController ()
@property (strong, nonatomic) IBOutlet UILabel *subject;
@property (strong, nonatomic) IBOutlet UILabel *month;
@property (strong, nonatomic) IBOutlet UILabel *day;
@property (strong, nonatomic) IBOutlet UILabel *year;
@property (strong, nonatomic) IBOutlet UILabel *time;

@end

@implementation NoteViewController
@synthesize subject = _subject;
@synthesize month = _month;
@synthesize day = _day;
@synthesize year = _year;
@synthesize time = _time;
@synthesize note = _note;
@synthesize detailViewController = _detailViewController;

- (id)initWithNote:(Note *)note
{
    self = [super initWithNibName:@"NoteViewController" bundle:nil];
    if (self) {

        [self setNote:note];
        
        NoteView *view = (NoteView *)[self view];
        [view setNote:note];
        
        [[self month] setFont:[BNoteConstants font:RobotoBold andSize:10]];
        [[self day] setFont:[BNoteConstants font:RobotoRegular andSize:23]];
        [[self year] setFont:[BNoteConstants font:RobotoLight andSize:13]];
        [[self time] setFont:[BNoteConstants font:RobotoRegular andSize:13]];
        [[self subject] setFont:[BNoteConstants font:RobotoRegular andSize:13]];
    
    
        UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(normalPressTap:)];
        [[self view] addGestureRecognizer:tap];

        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNote:)
                                                     name:NoteUpdated object:note];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setup];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setSubject:nil];
    [self setMonth:nil];
    [self setDay:nil];
    [self setYear:nil];
    [self setTime:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setup
{
    NSString *title = [[self note] subject];
    if ([BNoteStringUtils nilOrEmpty:title]) {
        [[self subject] setText:nil];
    } else {
        [[self subject] setText:title];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[[self note] created]];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterBehaviorDefault];
    
    [format setDateFormat:@"MM"];
    NSString *str = [format stringFromDate:date];
    NSNumber *num = [numberFormatter numberFromString:str];
    str = [BNoteStringUtils monthFor:[num intValue]];
    [[self month] setText:str];
    
    [format setDateFormat:@"dd"];
    str = [format stringFromDate:date];
    
    num = [numberFormatter numberFromString:str];
    str = [BNoteStringUtils ordinalNumberFormat:[num intValue]];
    [[self day] setText:str];
    
    [format setDateFormat:@"h:mm aaa"];
    str = [format stringFromDate:date];
    [[self time] setText:str];
    
    [format setDateFormat:@"yyyy"];
    str = [format stringFromDate:date];
    [[self year] setText:str];
}

- (void)updateNote:(id)sender
{
    [self setup];
}

-(void)normalPressTap:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NoteSelected object:[self note]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
