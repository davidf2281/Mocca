//
//  UnavailableInitFactory.m
//  MoccaTests
//
//  Created by David Fearon on 23/07/2019.
//  Copyright © 2019 --. All rights reserved.
//

#import "UnavailableInitFactory.h"
@import AVFoundation;
@implementation UnavailableInitFactory

+ (id)instanceOfClassWithName:(NSString *)name {
        
    const id returnObject =  [[NSClassFromString(name) alloc] init];
    
    return returnObject;
}

+ (AVCaptureDevice *)instanceOfAVCaptureDevice {
    return (AVCaptureDevice *) [self instanceOfClassWithName:@"AVCaptureDevice"];
}

+ (AVCaptureDeviceFormat *)instanceOfAVCaptureDeviceFormat {
    return (AVCaptureDeviceFormat *) [self instanceOfClassWithName:@"AVCaptureDeviceFormat"];
}

+ (AVCapturePhoto *)instanceOfAVCapturePhoto {
    return (AVCapturePhoto *) [self instanceOfClassWithName:@"AVCapturePhoto"];
}

+ (AVCaptureDeviceInput *)instanceOfAVCaptureDeviceInput {
    return (AVCaptureDeviceInput *) [self instanceOfClassWithName:@"AVCaptureDeviceInput"];
}

@end
