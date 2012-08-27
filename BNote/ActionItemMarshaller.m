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
#import "BNoteXmlConstants.h"

@implementation ActionItemMarshaller


- (BOOL)accept:(id)obj
{
    return [obj isKindOfClass:[ActionItem class]];
}

- (void)marshall:(ActionItem *)actionItem into:(BNoteExportFileWrapper *)file
{
    [self write:[BNoteXmlFormatter openTag:kActionItem] into:file];
    
    NSString *s = [BNoteXmlFormatter node:kText withText:actionItem.text];
    [self write:s into:file];
    
    s = [BNoteXmlFormatter node:kCreated withText:[BNoteXmlConstants toString:actionItem.created]];
    [self write:s into:file];
    
    s = [BNoteXmlFormatter node:kLastUpdated withText:[BNoteXmlConstants toString:actionItem.lastUpdated]];
    [self write:s into:file];
    
    if (actionItem.dueDate) {
        s = [BNoteXmlFormatter node:kDueDate withText:[BNoteXmlConstants toString:actionItem.dueDate]];
        [self write:s into:file];
    }
    
    if (actionItem.completed) {
        s = [BNoteXmlFormatter node:kCompletedDate withText:[BNoteXmlConstants toString:actionItem.completed]];
        [self write:s into:file];
    }
    
    [self write:[BNoteXmlFormatter closeTag:kActionItem] into:file];
}

@end
