//
//  AVSampleBuffer.m
//  OSXvnc-server
//
//  Created by Mykola Mokhnach on 19.01.19.
//

#import "AVSampleBufferHolder.h"


@implementation AVSampleBufferHolder

- (void)dealloc {
  if (_sampleBuffer != nil) {
    CFRelease(_sampleBuffer);
  }

  [super dealloc];
}

- (void)setSampleBuffer:(CMSampleBufferRef)sampleBuffer {
  if (_sampleBuffer != nil) {
    CFRelease(_sampleBuffer);
    _sampleBuffer = nil;
  }

  _sampleBuffer = sampleBuffer;

  if (nil != sampleBuffer) {
    CFRetain(sampleBuffer);
  }
}

@end
