//
//  AVSampleBufferHolder.h
//  OSXvnc
//
//  Created by Mykola Mokhnach on 19.01.19.
//  Copyright (c) 2019 Sauce Labs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVSampleBufferHolder : NSObject

@property (nonatomic, nullable, assign) IOSurfaceRef sampleBuffer;
@property (nonatomic) uint64_t timestamp;

@end

NS_ASSUME_NONNULL_END
