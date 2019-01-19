//
//  AVSampleBuffer.m
//  OSXvnc
//
//  Created by Mykola Mokhnach on 19.01.19.
//  Copyright (c) 2019 Sauce Labs Inc. All rights reserved.
//

#import "AVSampleBufferHolder.h"


@implementation AVSampleBufferHolder

- (void)dealloc {
  if (nil != _sampleBuffer) {
    CFRelease(_sampleBuffer);
  }

  [super dealloc];
}

- (void)setSampleBuffer:(CMSampleBufferRef)sampleBuffer {
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
