//
//  BNoteUnarshallingManager.h
//  BeNote
//
//  Created by kristin young on 8/22/12.
//
//

#import <Foundation/Foundation.h>
#import "ZipFile.h"
#import "ZipReadStream.h"

@protocol UnmarshallerListener;

@interface BNoteUnarshallingManager : NSObject <NSXMLParserDelegate> 
@property (strong, nonatomic) ZipFile *zipFile;

+ (BNoteUnarshallingManager *)instance;
+ (void)writeZipReadStream:(ZipReadStream *)stream toFile:(NSString *)filename;

- (void)delegate:(id<UnmarshallerListener>)delegate unmarshallUrl:(NSURL *)url;

@end


@protocol UnmarshallerListener <NSObject>


@end