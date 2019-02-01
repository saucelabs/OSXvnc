//
//  AVSampleBuffer.m
//  OSXvnc
//
//  Created by Mykola Mokhnach on 19.01.19.
//  Copyright (c) 2019 Sauce Labs Inc. All rights reserved.
//

#import "AVSampleBufferHolder.h"


@implementation AVSampleBufferHolder

@synthesize timestamp = _timestamp;

- (instancetype)init
{
    if ((self = [super init])) {
        _timestamp = 0;
    }
    return self;
}

- (void)dealloc {
    if (nil != _sampleBuffer) {
        CFRelease(_sampleBuffer);
    }

    [super dealloc];
}

- (void)setSampleBuffer:(IOSurfaceRef)sampleBuffer {
    if (nil != _sampleBuffer) {
        CFRelease(_sampleBuffer);
        _sampleBuffer = nil;
    }

    _sampleBuffer = sampleBuffer;
    if (nil != sampleBuffer) {
        CFRetain(sampleBuffer);
    }
}

@end
