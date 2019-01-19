//
//  AVSampleBuffer.h
//  OSXvnc-server
//
//  Created by Mykola Mokhnach on 19.01.19.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVSampleBufferHolder : NSObject

@property (assign, nonatomic, nullable) CMSampleBufferRef sampleBuffer;

@end

NS_ASSUME_NONNULL_END
