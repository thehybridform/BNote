//
//  ActionItemMarshaller.m
//  BeNote
//
//  Created by kristin young on 8/17/12.
//
//

#import "ActionItemMarshaller.h"
#import "ActionItem.h"
#import "BNoteXmlFormatter.h"
#import "BNoteMarshallingManager.h"

@implementation ActionItemMarshaller

static NSString *kActionItem = @"action-item";

- (BOOL)accept:(id)obj
{
    return [obj isKindOfClass:[ActionItem class]];
}

- (void)marshall:(ActionItem *)actionItem into:(NSFileHandle *)file
{
    [self write:[BNoteXmlFormatter openTag:kActionItem] into:file];
    
    NSString *s = [BNoteXmlFormatter node:kText withText:actionItem.text];
    [self write:s into:file];
    
    s = [BNoteXmlFormatter node:kCreated withText:[self toString:actionItem.created]];
    [self write:s into:file];
    
    s = [BNoteXmlFormatter node:kLastUpdated withText:[self toString:actionItem.lastUpdated]];
    [self write:s into:file];
    
    [self write:[BNoteXmlFormatter closeTag:kActionItem] into:file];
}

@end
