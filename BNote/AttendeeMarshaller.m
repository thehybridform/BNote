//
//  AttendeeMarshaller.m
//  BeNote
//
//  Created by kristin young on 8/27/12.
//
//

#import "AttendeeMarshaller.h"
#import "BNoteXmlFormatter.h"
#import "BNoteXmlConstants.h"

@implementation AttendeeMarshaller

- (BOOL)accept:(id)obj
{
    return [obj isKindOfClass:[Attendants class]];
}

- (void)marshall:(Attendants *)attendants into:(BNoteExportFileWrapper *)file
{
    for (Attendant *attendant in attendants.children) {
        [self write:[BNoteXmlFormatter openTag:kAttendee] into:file];
    
        NSString *s = [BNoteXmlFormatter node:kFirstName withText:attendant.firstName];
        [self write:s into:file];
    
        s = [BNoteXmlFormatter node:kLastName withText:attendant.lastName];
        [self write:s into:file];
    
        s = [BNoteXmlFormatter node:kEmail withText:attendant.email];
        [self write:s into:file];
        
        [self write:[BNoteXmlFormatter closeTag:kAttendee] into:file];
    }
}

@end
