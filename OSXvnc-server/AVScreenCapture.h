//
//  AVScreenCapture.h
//  OSXvnc
//
//  Created by Mykola Mokhnach on Mon Jan 14 2019.
//  Copyright (c) 2019 Sauce Labds Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVScreenCapture : NSObject

@property (readonly) CGDirectDisplayID displayID;

- (void)startForDisplay:(CGDirectDisplayID)displayID;
- (nullable CMSampleBufferRef)lastFrame;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
