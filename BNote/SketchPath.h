//
//  SketchPath.h
//  BeNote
//
//  Created by kristin young on 10/4/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface SketchPath : NSManagedObject

@property (nonatomic, retain) id bezierPath;
@property (nonatomic, retain) id pathColor;
@property (nonatomic, retain) Photo *photo;

@end
