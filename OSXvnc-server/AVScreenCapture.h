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

extern const size_t BYTES_PER_PIXEL;

@interface AVScreenCapture : NSObject

@property (readonly) CGDirectDisplayID displayID;

- (instancetype)initWithDisplayID:(CGDirectDisplayID)displayID
                  refreshCallback:(CGScreenRefreshCallback)refreshCallback;
- (BOOL)startWithWidth:(size_t)width
                height:(size_t)height;
- (BOOL)retrieveLastFrame:(IOSurfaceRef *)surface
                timestamp:(nullable uint64_t *)timestamp;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
