//
//  Migration.h
//  BeNote
//
//  Created by kristin young on 4/11/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Migration : NSManagedObject

@property (nonatomic) BOOL remote;
@property (nonatomic) BOOL local;

@end
