//
//  AVCaptureMovieFileOutput.m
//  CLRPSDKDemo
//
//  Created by xx11dragon on 2019/8/23.
//  Copyright © 2019 wanglijun. All rights reserved.
//

#import "AVCaptureMovieFileOutput.h"
#import <objc/runtime.h>

@implementation AVCaptureMovieFileOutput(Swizziling)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        // 原方法名和替换方法名
        SEL originalSelector = @selector(startRecordingToOutputFileURL:recordingDelegate:);
        SEL swizzledSelector = @selector(swizzle_startRecordingToOutputFileURL:recordingDelegate:);
        
        // 原方法结构体和替换方法结构体
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        // 如果当前类没有原方法的实现IMP，先调用class_addMethod来给原方法添加默认的方法实现IMP
        BOOL didAddMethod = class_addMethod(class,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {// 添加方法实现IMP成功后，修改替换方法结构体内的方法实现IMP和方法类型编码TypeEncoding
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else { // 添加失败，调用交互两个方法的实现
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)swizzle_startRecordingToOutputFileURL:(NSURL *)outputFileURL
                            recordingDelegate:(id<AVCaptureFileOutputRecordingDelegate>)delegate {
    [self swizzle_startRecordingToOutputFileURL:outputFileURL recordingDelegate:delegate];
    NSLog(@"%@", outputFileURL);
}


@end
