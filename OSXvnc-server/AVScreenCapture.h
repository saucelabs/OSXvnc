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

extern const int32_t MIN_FPS;
extern const int32_t MAX_FPS;
extern const size_t BYTES_PER_PIXEL;

@interface AVScreenCapture : NSObject

@property (readonly) CGDirectDisplayID displayID;
@property (readonly) CGFloat scaleFactor;

- (instancetype)initWithDisplayID:(CGDirectDisplayID)displayID scaleFactor:(CGFloat)scaleFactor;
- (void)startWithFps:(int32_t)fps;
- (BOOL)retrieveLastFrame:(CMSampleBufferRef *)frame timestamp:(nullable uint64_t *)timestamp;
- (BOOL)retrieveNextFrame:(CMSampleBufferRef *)frame timestamp:(nullable uint64_t *)timestamp timeout:(NSTimeInterval)timeout;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
