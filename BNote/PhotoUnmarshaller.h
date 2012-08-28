//
//  PhotoUnmarshaller.h
//  BeNote
//
//  Created by kristin young on 8/27/12.
//
//

#import "EntryUnmarshallerBasis.h"
#import "KeyPoint.h"

@interface PhotoUnmarshaller : EntryUnmarshallerBasis
@property (strong, nonatomic) KeyPoint *keyPoint;

@end
