//
//  BNoteMarshaller.h
//  BeNote
//
//  Created by kristin young on 8/16/12.
//
//

#import <Foundation/Foundation.h>
#import "BNoteExportFileWrapper.h"

static NSString *const kBeNoteOpen =
    @"<?xml version=\"1.0\" encoding=\"UTF-16\"?>\
      <benote xmlns=\"http://docs.uobia.net/2012/benote/XMLSchema-instance-1.0\"\
              xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\
              xsi:schemaLocation=\"http://docs.uobia.net/2012/benote/XMLSchema-instance-1.0\
                                  http://docs.uobia.net/2012/benote/XMLSchema-instance-1.0/benote-1.0.xsd\">\n";

static NSString *const kBeNoteClose = @"</benote>\n";

static NSString *const kId = @"id";
static NSString *const kCreated = @"created-date";
static NSString *const kLastUpdated = @"last-updated-date";
static NSString *const kText = @"text";

@protocol BNoteMarshaller <NSObject>

- (BOOL)accept:(id)obj;

- (void)marshall:(id)data into:(BNoteExportFileWrapper *)file;

@end
