//
//  AVScreenCapture.h
//  OSXvnc
//
//  Created by Mykola Mokhnach on Mon Jan 14 2019.
//  Copyright (c) 2019 Sauce Labs Inc. All rights reserved.
//

#import "AVScreenCapture.h"

#import <AppKit/AppKit.h>
#import "AVSampleBufferHolder.h"

static const int32_t MIN_FPS = 15;
static const int32_t MAX_FPS = 60;

@interface AVScreenCapture() <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, retain, nullable) AVCaptureSession *session;
@property (nonatomic, retain, nullable) AVCaptureVideoDataOutput *output;
@property (nonatomic, retain, nullable) AVCaptureScreenInput *input;
@property (nonatomic, retain) AVSampleBufferHolder *sampleBufferHolder;
@property (nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic, nullable) dispatch_semaphore_t nextFrameSemaphore;

@end

@implementation AVScreenCapture

@synthesize displayID = _displayID;
@synthesize scaleFactor = _scaleFactor;

- (instancetype)initWithDisplayID:(CGDirectDisplayID)displayID scaleFactor:(CGFloat)scaleFactor
{
  if ((self = [super init])) {
    _session = nil;
    _output = nil;
    _input = nil;
    _sessionQueue = NULL;
    _displayID = displayID;
    _scaleFactor = scaleFactor;
    _nextFrameSemaphore = NULL;
    _sampleBufferHolder = [[AVSampleBufferHolder alloc] init];
  }
  return self;
}

- (void)dealloc {
  [self stop];

  [_sampleBufferHolder release];
  _sampleBufferHolder = nil;

  if (NULL != _sessionQueue) {
    dispatch_release(_sessionQueue);
    _sessionQueue = NULL;
  }

  [super dealloc];
}

- (void)startWithFps:(int32_t)fps
{
  if (nil != self.session) {
    return;
  }

  [self stop];

  self.session = [[AVCaptureSession alloc] init];

  self.input = [[AVCaptureScreenInput alloc] initWithDisplayID:self.displayID];
  self.input.capturesCursor = NO;
  self.input.scaleFactor = self.scaleFactor;
  self.input.minFrameDuration = CMTimeMake(1, MAX(MIN_FPS, MIN(fps, MAX_FPS)));
  [self.session addInput:self.input];
  self.output = [[AVCaptureVideoDataOutput alloc] init];
  self.output.videoSettings = @{
                                (id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)
                                };
  self.output.alwaysDiscardsLateVideoFrames = YES;
  [self.session addOutput:self.output];
  dispatch_queue_attr_t queueAttributes = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, DISPATCH_QUEUE_PRIORITY_HIGH);
  self.sessionQueue = dispatch_queue_create("de.uni-mannheim.VineServer.avscreencapture", queueAttributes);
  [self.output setSampleBufferDelegate:self queue:self.sessionQueue];

  [self.session startRunning];
}

- (void)stop
{
  if (nil == self.session) {
    return;
  }

  [self.session stopRunning];
  [self.session removeInput:self.input];
  [self.input release];
  self.input = nil;
  [self.session removeOutput:self.output];
  [self.output release];
  self.output = nil;
  [self.session release];
  self.session = nil;

  if (NULL != self.nextFrameSemaphore) {
    dispatch_release(self.nextFrameSemaphore);
    self.nextFrameSemaphore = NULL;
  }

}

- (CMSampleBufferRef)lastFrame
{
  if (nil == self.session) {
    return nil;
  }

  __block CMSampleBufferRef buffer = nil;
  dispatch_sync(self.sessionQueue, ^{
    buffer = self.sampleBufferHolder.sampleBuffer;
    if (nil != buffer) {
      CFRetain(buffer);
    }
  });
  return buffer;
}

- (CMSampleBufferRef)nextFrameWithTimeout:(NSTimeInterval)timeout
{
  if (nil == self.session) {
    return nil;
  }

  self.nextFrameSemaphore = dispatch_semaphore_create(0);
  BOOL didFrameArrive = 0 == dispatch_semaphore_wait(self.nextFrameSemaphore,
                                                     dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC)));
  dispatch_release(self.nextFrameSemaphore);
  self.nextFrameSemaphore = NULL;
  if (!didFrameArrive) {
    return nil;
  }

  return self.lastFrame;
}

- (void)captureOutput:(AVCaptureOutput *)output
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {
  self.sampleBufferHolder.sampleBuffer = sampleBuffer;
  if (NULL != self.nextFrameSemaphore) {
    dispatch_semaphore_signal(self.nextFrameSemaphore);
  }
}

@end
