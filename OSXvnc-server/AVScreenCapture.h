//
//  AVScreenCapture.h
//  OSXvnc
//
//  Created by Mykola Mokhnach on Mon Jan 14 2019.
//  Copyright (c) 2019 Sauce Labs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVScreenCapture : NSObject

@property (readonly) CGDirectDisplayID displayID;
@property (readonly) CGFloat scaleFactor;

- (instancetype)initWithDisplayID:(CGDirectDisplayID)displayID scaleFactor:(CGFloat)scaleFactor;
- (void)start;
- (nullable CMSampleBufferRef)lastFrame;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
