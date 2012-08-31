//
//  TopicUnmarshaller.h
//  BeNote
//
//  Created by kristin young on 8/30/12.
//
//

#import "EntryUnmarshallerBasis.h"
#import "Topic.h"

@interface TopicUnmarshaller : EntryUnmarshallerBasis
@property (strong, nonatomic) Topic *topic;

- (Topic *)findOrCreateTopic:(NSString *)name;

@end
