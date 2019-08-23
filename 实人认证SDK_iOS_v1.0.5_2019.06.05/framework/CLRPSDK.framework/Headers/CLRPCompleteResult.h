//
//  CLRPCompleteResult.h
//  CLRPSDK
//
//  Created by wanglijun on 2018/12/21.
//  Copyright © 2018 wanglijun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLRPCompleteResult;
typedef void(^CLRPComplete)(CLRPCompleteResult * completeResult);


/**
 code:
 | 1000  | 成功
 | 1010  |用户点击返回
 | 1101  |网络测异常
 | 1102  |业务接口报错
 | 1103  |其他错误
 */
@interface CLRPCompleteResult : NSObject
@property (nonatomic,assign)NSInteger code;//SDK外层code
@property (nonatomic,nullable,copy)NSString * message;//SDK外层msg
@property (nonatomic,nullable,copy)NSDictionary * data;//SDK外层data
@property (nonatomic,nullable,strong)NSError * error;//SDK内层Error

@property (nonatomic,nullable,strong)id clModel;
@property (nonatomic,assign)NSInteger clValue;

+(instancetype)cl_CompleteWithCode:(NSInteger)code message:(NSString *)message data:(nullable NSDictionary *)data  error:(nullable NSError *)error;
@end

//身份证信息Model
@interface CLRPOcrIDCardModel : NSObject
/**normal-正常身份证；copy-复印件；temporary-临时身份证；screen-翻拍；unknown-其他未知情况*/
@property(nonatomic,copy)NSString * riskType;
@property(nonatomic,copy)NSString * address;//地址
@property(nonatomic,copy)NSString * birth;//生日
@property(nonatomic,copy)NSString * name;//姓名
@property(nonatomic,copy)NSString * cardNum;//身份证号
@property(nonatomic,copy)NSString * sex;//性别
@property(nonatomic,copy)NSString * nation;//名族
@property(nonatomic,copy)NSString * issuingAuthority;//签发机关
@property(nonatomic,copy)NSString * issuingDate;//签发日期
/**有效日期*/
@property(nonatomic,copy)NSString * expiryDate;

@end
