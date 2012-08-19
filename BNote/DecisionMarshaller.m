//
//  DecisionMarshaller.m
//  BeNote
//
//  Created by kristin young on 8/17/12.
//
//

#import "DecisionMarshaller.h"
#import "Decision.h"
#import "BNoteXmlFormatter.h"
#import "BNoteMarshallingManager.h"

@implementation DecisionMarshaller

static NSString *kDecision = @"decision";

- (BOOL)accept:(id)obj
{
    return [obj isKindOfClass:[Decision class]];
}

- (void)marshall:(Decision *)decision into:(NSFileHandle *)file
{
    [self write:[BNoteXmlFormatter openTag:kDecision] into:file];
    
    NSString *s = [BNoteXmlFormatter node:kText withText:decision.text];
    [self write:s into:file];
    
    s = [BNoteXmlFormatter node:kCreated withText:[self toString:decision.created]];
    [self write:s into:file];
    
    s = [BNoteXmlFormatter node:kLastUpdated withText:[self toString:decision.lastUpdated]];
    [self write:s into:file];
    
    [self write:[BNoteXmlFormatter closeTag:kDecision] into:file];
}

@end
