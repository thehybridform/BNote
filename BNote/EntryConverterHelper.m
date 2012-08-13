//
//  EntryConverterHelper.m
//  BeNote
//
//  Created by kristin young on 8/6/12.
//
//

#import "EntryConverterHelper.h"
#import "EntryConverter.h"
#import "BNoteSessionData.h"
#import "BNoteFactory.h"
#import "BNoteWriter.h"
#import "ActionItemToDecisionConverter.h"
#import "ActionItemToKeyPointConverter.h"
#import "ActionItemToQuestionConverter.h"
#import "ActionItemToKeyPointConverter.h"
#import "KeyPointToActionItemConverter.h"
#import "KeyPointToDecisionConverter.h"
#import "KeyPointToQuestionConverter.h"
#import "QuestionToActionItemConverter.h"
#import "QuestionToKeyPointConverter.h"
#import "QuestionToDecisionConverter.h"
#import "DecisionToActionItemConverter.h"
#import "DecisionToKeyPointConverter.h"
#import "DecisionToQuestionConverter.h"
#import "KeyPoint.h"
#import "Decision.h"

@interface EntryConverterHelper()
@property (strong, nonatomic) NSMutableArray *converters;
@property (strong, nonatomic) Entry *entry;

- (id)initSingleton;

@end

@implementation EntryConverterHelper
@synthesize converters = _converters;
@synthesize entry = _entry;

static NSString *convertToText;
static NSString *keyPointText;
static NSString *questionText;
static NSString *decisionText;
static NSString *actionItemText;

- (id)initSingleton
{
    self = [super init];
    
    if (self) {
        NSMutableArray *converters = [[NSMutableArray alloc] init];
        [self setConverters:converters];
        
        [converters addObject:[[KeyPointToActionItemConverter alloc] init]];
        [converters addObject:[[KeyPointToQuestionConverter alloc] init]];
        [converters addObject:[[KeyPointToDecisionConverter alloc] init]];

        [converters addObject:[[QuestionToActionItemConverter alloc] init]];
        [converters addObject:[[QuestionToDecisionConverter alloc] init]];
        [converters addObject:[[QuestionToKeyPointConverter alloc] init]];
        
        [converters addObject:[[DecisionToActionItemConverter alloc] init]];
        [converters addObject:[[DecisionToKeyPointConverter alloc] init]];
        [converters addObject:[[DecisionToQuestionConverter alloc] init]];
        
        [converters addObject:[[ActionItemToDecisionConverter alloc] init]];
        [converters addObject:[[ActionItemToKeyPointConverter alloc] init]];
        [converters addObject:[[ActionItemToQuestionConverter alloc] init]];
    }
    
    convertToText = NSLocalizedString(@"Convert Note Entry To", nil);
    keyPointText = NSLocalizedString(@"Key Point", nil);
    questionText = NSLocalizedString(@"Question", nil);
    decisionText = NSLocalizedString(@"Decision", nil);
    actionItemText = NSLocalizedString(@"Action Item", nil);
    
    return self;
}

- (void)handleConvertion:(Entry *)entry withinView:(UIView *)view
{
    if (!entry) {
        return;
    }
    
    [self setEntry:entry];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    [[BNoteSessionData instance] setActionSheet:actionSheet];
    [actionSheet setDelegate:[BNoteSessionData instance]];
    [[BNoteSessionData instance] setActionSheetDelegate:self];
    
    [actionSheet setTitle:convertToText];
    
    if (![entry isKindOfClass:[KeyPoint class]]) {
        [actionSheet addButtonWithTitle:keyPointText];
    }
    
    if (![entry isKindOfClass:[Question class]]) {
        [actionSheet addButtonWithTitle:questionText];
    }
    
    if (![entry isKindOfClass:[Decision class]]) {
        [actionSheet addButtonWithTitle:decisionText];
    }
    
    if (![entry isKindOfClass:[ActionItem class]]) {
        [actionSheet addButtonWithTitle:actionItemText];
    }
    
    CGRect rect = [view frame];
    [actionSheet showFromRect:rect inView:view animated:YES];
}

- (void)convert:(Entry *)from to:(Entry *)to
{
    for (id<EntryConverter> converter in [self converters]) {
        if ([converter convert:from to:to]) {
            break;
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0) {
        Note *note = [[self entry] note];
        Entry *entry;
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if (title == keyPointText) {
            entry = [BNoteFactory createKeyPoint:note];
        } else if (title == questionText) {
            entry = [BNoteFactory createQuestion:note];
        } else if (title == decisionText) {
            entry = [BNoteFactory createDecision:note];
        } else if (title == actionItemText) {
            entry = [BNoteFactory createActionItem:note];
        }
        
        if (entry) {
            [self convert:[self entry] to:entry];

            int index = [[note entries] indexOfObject:[self entry]];
            
            [[BNoteWriter instance] removeEntry:[self entry]];
            
            [note removeEntriesObject:entry];
            [note insertObject:entry inEntriesAtIndex:index];

            [[BNoteWriter instance] update];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNoteUpdated object:nil];
        }
    }
    
    [[BNoteSessionData instance] setActionSheet:nil];
    [self setEntry:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [[BNoteSessionData instance] setActionSheet:nil];
    [self setEntry:nil];
}

+ (EntryConverterHelper *)instance
{
    static EntryConverterHelper *_default = nil;
    
    if (_default != nil) {
        return _default;
    }
    
    static dispatch_once_t safer;
    dispatch_once(&safer, ^{
        _default = [[EntryConverterHelper alloc] initSingleton];
    });
    
    return _default;
}

@end
