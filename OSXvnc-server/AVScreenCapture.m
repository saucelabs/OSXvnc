//
//  AVScreenCapture.h
//  OSXvnc
//
//  Created by Mykola Mokhnach on Mon Jan 14 2019.
//  Copyright (c) 2019 Sauce Labs Inc. All rights reserved.
//

#import "AVScreenCapture.h"

#import <AppKit/AppKit.h>
#import <mach/mach_time.h>
#import "AVSampleBufferHolder.h"

const int32_t MIN_FPS = 15;
const int32_t MAX_FPS = 60;
const size_t BYTES_PER_PIXEL = 4;

@interface AVScreenCapture() <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, retain) AVSampleBufferHolder *sampleBufferHolder;
@property (nonatomic) CGDisplayStreamRef displayStream;

@end

@implementation AVScreenCapture

@synthesize displayID = _displayID;

- (instancetype)initWithDisplayID:(CGDirectDisplayID)displayID
{
    if ((self = [super init])) {
        _displayID = displayID;
        _displayStream = nil;
        _sampleBufferHolder = [[AVSampleBufferHolder alloc] init];
    }
    return self;
}

- (void)dealloc {
    [self stop];

    [_sampleBufferHolder release];
    _sampleBufferHolder = nil;

    [super dealloc];
}

- (BOOL)startWithWidth:(size_t)width height:(size_t)height refreshCallback:(CGScreenRefreshCallback)refreshCallback
{
    if (nil != self.displayStream) {
        return YES;
    }

    CGDisplayStreamFrameAvailableHandler handler = ^(CGDisplayStreamFrameStatus status, uint64_t displayTime,
                                                     IOSurfaceRef __nullable frameSurface,
                                                     CGDisplayStreamUpdateRef __nullable updateRef) {
        if (kCGDisplayStreamFrameStatusStopped == status) {
            if (self.displayStream) {
                CFRelease(self.displayStream);
                self.displayStream = nil;
            }
        }
        // Only pay attention to frame updates.
        if (status != kCGDisplayStreamFrameStatusFrameComplete || !frameSurface || !updateRef) {
            return;
        }
        @synchronized (self.sampleBufferHolder) {
            self.sampleBufferHolder.sampleBuffer = frameSurface;
            self.sampleBufferHolder.timestamp = displayTime;
        }
        size_t count = 0;
        const CGRect* rects = CGDisplayStreamUpdateGetRects(updateRef, kCGDisplayStreamUpdateDirtyRects, &count);
        if (count > 0) {
            refreshCallback((uint32_t)count, rects, nil);
        }
    };

    CFDictionaryRef propertiesDict = CFDictionaryCreate(kCFAllocatorDefault,
                                                         (const void* []){kCGDisplayStreamShowCursor},
                                                         (const void* []){kCFBooleanFalse},
                                                         1,
                                                         &kCFTypeDictionaryKeyCallBacks,
                                                         &kCFTypeDictionaryValueCallBacks);
    self.displayStream = CGDisplayStreamCreate(self.displayID, width, height, 'BGRA', propertiesDict, handler);
    CFRelease(propertiesDict);
    if (self.displayStream) {
        CGError error = CGDisplayStreamStart(self.displayStream);
        if (error != kCGErrorSuccess) {
            self.displayStream = nil;
            return NO;
        }
        CFRunLoopSourceRef source = CGDisplayStreamGetRunLoopSource(self.displayStream);
        CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopCommonModes);
        return YES;
    }
    return NO;
}

- (void)stop
{
    if (nil == self.displayStream) {
        return;
    }

    CFRunLoopSourceRef source = CGDisplayStreamGetRunLoopSource(self.displayStream);
    CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, kCFRunLoopCommonModes);
    CGDisplayStreamStop(self.displayStream);
}

- (BOOL)retrieveLastFrame:(IOSurfaceRef *)surface timestamp:(uint64_t *)timestamp
{
    if (nil == self.displayStream) {
        return NO;
    }

    @synchronized (self.sampleBufferHolder) {
        if (surface) {
            *surface = self.sampleBufferHolder.sampleBuffer;
        }
        if (timestamp) {
            *timestamp = self.sampleBufferHolder.timestamp;
        }
    }
    if (nil == *surface) {
        return NO;
    }
    CFRetain(*surface);
    return YES;
}

@end
