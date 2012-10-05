//
//  Attendant.h
//  BeNote
//
//  Created by kristin young on 10/4/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Attendants;

@interface Attendant : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) Attendants *parent;

@end
