//
//  BNoteMarshallingManager.h
//  BeNote
//
//  Created by kristin young on 8/16/12.
//
//

#import <Foundation/Foundation.h>
#import "BNoteMarshaller.h"
#import "BNoteMarshallerBasis.h"
#import "BNoteExportFileWrapper.h"

@interface BNoteMarshallingManager : BNoteMarshallerBasis <BNoteMarshaller>

+ (BNoteMarshallingManager *)instance;

- (BNoteExportFileWrapper *)marshall:(id)data;
- (void)marshall:(id)data into:(BNoteExportFileWrapper *)file;

@end
