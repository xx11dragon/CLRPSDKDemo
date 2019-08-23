//
//  CLRPSDKManager.h
//  CLRPSDK
//
//  Created by wanglijun on 2018/12/18.
//  Copyright © 2018 wanglijun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CLRPConfigure.h"
#import "CLRPCompleteResult.h"

//生成新的TicketID通知
#define NSNOTIF_NAME_CL_DIDGETNEWTICKETID @"NSNOTIF_NAME_CL_DIDGETNEWTICKETID"

@interface CLRPSDKManager : NSObject

/**
 初始化
 @param appID appID
 @param appKey appKey
 @param complete 结果回调：
    complete.error 错误信息
 
    complete.data 初始化结果原始数据
    complete.clModel 初始化结果ticket
 
 ticket: 初始化凭证
 */
+ (void)initWithAppId:(NSString * )appID appKey:(NSString *)appKey licenseID:(NSString *)licenseID complete:(CLRPComplete)complete;


//调起实人认证前的设置接口（可选实现）
+ (void)configure:(CLRPConfigure *)configure;


/**
 开始实人认证
 @param vc 将要调用实人认证的VC 必传
 @param complete 实人认证结果回调（只回调一次）
 completeResult->_error` `error`为空则为成功
 `completeResult->_clValue`: 认证分数(`int`),`0~100`，建议`80`分以上可认为成功
 
 `completeResult->_data`:  实人认证过程中的照片保存路径(包括身份证正反面，活体检测最优照片，活体检测动作照片)
 - 照片取值对应key：
 - 身份证正面：`CLRPIDCard_Front`
 - 身份证反面：`CLRPIDCard_Back`
 - 活体检测最优照片：`CLRPFaceLiveness`
 
 - 活体检测动作照片（如设置了活体动作，将只会取到相应动作的照片，如未设置，将取出活体中检测中随机检测的动作的照片）：
     - 眨眼：`CLRPFaceLivenessActionTypeLiveEye`
     - 张嘴：`CLRPFaceLivenessActionTypeLiveMouth`
     - 向右转头：`CLRPFaceLivenessActionTypeLiveYawRight`
     - 向左转头：`CLRPFaceLivenessActionTypeLiveYawLeft`
     - 左右摇头：`CLRPFaceLivenessActionTypeLiveYaw`
 
 */
+ (void)verify:(UIViewController *)vc complete:(CLRPComplete)complete;


/**
 @param processBlock 实人认证过程中的回调（多次回调）
 @param complete 实人认证结果回调（只回调一次）
 */
+ (void)verify:(UIViewController *)vc processBlock:(CLRPComplete)processBlock complete:(CLRPComplete)complete;

/**
 清除缓存
 注：清除后将不能取到活体检测照片等信息，建议在最后调用
 */
+ (void)cleanTempCache;


/**
 返回SDK版本号
 */
+ (NSString *)clrpSDKVersion;

/**
 实人认证日志开关
 @param flag YES:打开  NO:关闭 (默认关闭)
 */
+ (void)setLogEnabled:(BOOL)flag;
@end


