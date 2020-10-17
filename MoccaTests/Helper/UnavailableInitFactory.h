//
//  UnavailableInitFactory.h
//  MoccaTests
//
//  Created by David Fearon on 23/07/2019.
//  Copyright © 2019 --. All rights reserved.
//

/**
 Many hardware-dependent AVFoundation classes have no publicly available initializers.
 This class is used to create correctly typed (empty) instances to facilitate testing
 */

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface UnavailableInitFactory : NSObject

+ (AVCapturePhoto *)       instanceOfAVCapturePhoto;
+ (AVCaptureDevice *)      instanceOfAVCaptureDevice;
+ (AVCaptureDeviceInput *) instanceOfAVCaptureDeviceInput;
+ (AVCaptureDeviceFormat *)instanceOfAVCaptureDeviceFormat;

@end

NS_ASSUME_NONNULL_END
