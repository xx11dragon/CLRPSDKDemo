//
//  VerifyResultViewController.h
//  CLRPSDKDemo
//
//  Created by wanglijun on 2018/12/24.
//  Copyright © 2018 wanglijun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VerifyResultViewController : UIViewController
@property(nonatomic,assign)BOOL isVerifySuccess;
@property(nonatomic,copy)NSString * verifyMessage;

@end

NS_ASSUME_NONNULL_END
