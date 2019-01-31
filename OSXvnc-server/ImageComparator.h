//
//  ImageComparator.h
//  OSXvnc-server
//
//  Created by Mykola Mokhnach on 31.01.19.
//

#import "miscstruct.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageComparator : NSObject

+ (BOOL)compareImage1:(char *)img1Buffer
             toImage2:(char *)img2Buffer
                width:(size_t)width
               height:(size_t)height
        bytesPerPixel:(char)bytesPerPixel
           rectangles:(char **)rectangles
      rectanglesCount:(size_t *)rectanglesCount;
@end

NS_ASSUME_NONNULL_END
