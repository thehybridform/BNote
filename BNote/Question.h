//
//  Question.h
//  BeNote
//
//  Created by kristin young on 10/4/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Entry.h"


@interface Question : Entry

@property (nonatomic, retain) NSString * answer;

@end
