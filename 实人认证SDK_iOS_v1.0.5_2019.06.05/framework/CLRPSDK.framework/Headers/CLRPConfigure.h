//
//  CLRPConfigure.h
//  CLRPSDK
//
//  Created by wanglijun on 2018/12/21.
//  Copyright © 2018 wanglijun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CLRPFaceLivenessActionType) {
    CLRPFaceLivenessActionTypeLiveEye = 0,          // 眨眼
    CLRPFaceLivenessActionTypeLiveMouth = 1,        // 张嘴
    CLRPFaceLivenessActionTypeLiveYawRight = 2,     // 右转头
    CLRPFaceLivenessActionTypeLiveYawLeft = 3,      // 左转头
//    CLRPFaceLivenessActionTypeLivePitchUp = 4,      // 抬头
//    CLRPFaceLivenessActionTypeLivePitchDown = 5,    // 低头
    CLRPFaceLivenessActionTypeLiveYaw = 6,          // 左右摇头
    CLRPFaceLivenessActionTypeNoAction = 7,         //没有动作
};

@interface CLRPConfigure : NSObject
//pushNav
@property (nonatomic, weak)UINavigationController * navigationController;//设置后，使用此nav以push方式打开实人认证页面，完成认证后会从此nav的viewControllers中移除所有实人认证相关页面，如不设置，将使用modal方式

/**OCR 身份检测结果信息姓名是否可编辑； 默认不可编辑，YES：可编辑--NO：不可编辑*/
@property (nonatomic, assign) BOOL nameOpenEdit;
/**OCR 身份检测结果信息地址是否可编辑； 默认不可编辑，YES：可编辑--NO：不可编辑*/
@property (nonatomic, assign) BOOL addressOpenEdit;
/**OCR 身份检测结果信息身份证号是否可编辑； 默认不可编辑，YES：可编辑--NO：不可编辑*/
@property (nonatomic, assign) BOOL idCardOpenEdit;


/********活体检测配置**********/
@property (nonatomic, assign) BOOL isByOrder;//是否按设置的动作顺序执行，默认NO,顺序为随机
@property (nonatomic, assign) NSInteger numOfLiveness;//活体动作数目（array为nil时起作用，从所有动作中随机抽）
@property (nonatomic, retain) NSMutableArray *liveActionArray;//活体动作列表数组，eg:@[@(CLRPFaceLivenessActionTypeLiveEye),@(CLRPFaceLivenessActionTypeLiveMouth),@(CLRPFaceLivenessActionTypeLiveYaw)]


/**单个接口超时设置,单位秒，默认30s
 eg CLRPConfigure.requestTimeOut = [NSNumber numberWithFloat:10.0];
*/
@property (nonatomic, strong) NSNumber * requestTimeOut;

@end

