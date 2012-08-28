//
//  ResponsibilityUnmarshaller.h
//  BeNote
//
//  Created by kristin young on 8/27/12.
//
//

#import "EntryUnmarshallerBasis.h"
#import "ActionItem.h"

@interface ResponsibilityUnmarshaller : EntryUnmarshallerBasis
@property (strong, nonatomic) ActionItem *actionItem;

@end
