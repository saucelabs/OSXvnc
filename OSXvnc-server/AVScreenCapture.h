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

#define DISPLAY_FPS 30
#define BYTES_PER_PIXEL 4

@interface AVScreenCapture : NSObject

@property (readonly) CGDirectDisplayID displayID;

- (instancetype)initWithDisplayID:(CGDirectDisplayID)displayID
                  refreshCallback:(CGScreenRefreshCallback)refreshCallback;
- (BOOL)startWithWidth:(size_t)width
                height:(size_t)height;
- (BOOL)retrieveLastFrame:(char **)frameData
               dataLength:(nullable size_t *)dataLength
                timestamp:(nullable uint64_t *)timestamp;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
