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

@interface BNoteMarshallingManager : BNoteMarshallerBasis <BNoteMarshaller>

+ (BNoteMarshallingManager *)instance;

- (NSFileHandle *)marshall:(id)data;
- (void)marshall:(id)data into:(NSFileHandle *)strem;

@end
