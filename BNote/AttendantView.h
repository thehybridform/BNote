//
//  AttendantView.h
//  BNote
//
//  Created by Young Kristin on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Attendant.h"

@protocol AttendantViewDelegate;

@interface AttendantView : UIView <UIActionSheetDelegate>

@property (strong, nonatomic) Attendant *attendant;
@property (assign, nonatomic) id<AttendantViewDelegate> delegate;

@end

@protocol AttendantViewDelegate <NSObject>

@required

- (void)remove:(Attendant *)attendant;

@end