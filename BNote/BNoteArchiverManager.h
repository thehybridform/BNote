//
//  BNoteArchiverManager.h
//  BeNote
//
//  Created by kristin young on 8/15/12.
//
//

#import <Foundation/Foundation.h>

@interface BNoteArchiverManager : NSObject

+ (BNoteArchiverManager *)instance;

- (NSArray *)archivers;

@end
