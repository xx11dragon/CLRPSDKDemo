//
//  PrepairDataViewController.m
//  CLRPSDKDemo
//
//  Created by KevinChien on 2019/1/11.
//  Copyright © 2019 wanglijun. All rights reserved.
//

#import "PrepairDataViewController.h"
#import <Masonry.h>

#import <CLRPSDK/CLRPSDK.h>
#import "VerifyResultViewController.h"

#import <SVProgressHUD.h>
#import <YYModel.h>
#import <objc/runtime.h>
#import <objc/message.h>

@interface PrepairDataViewController ()
@property (nonatomic, strong) NSMutableArray *livenessArray;
@property (nonatomic, strong) NSMutableArray *editArray;

@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation PrepairDataViewController

- (NSMutableArray *)livenessArray{
    if (!_livenessArray) {
        NSArray *initArray = @[@(0),@(1),@(2),@(3),@(6)];
        _livenessArray = [[NSMutableArray alloc] initWithArray:initArray];
    }
    return _livenessArray;
}

- (NSMutableArray *)editArray{
    if (!_editArray) {
        NSArray *initArray = @[@(100),@(101),@(102)];
        _editArray = [[NSMutableArray alloc] initWithArray:initArray];
    }
    return _editArray;
}

- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self runTests];
    [self.navigationController.navigationBar setBarTintColor:UIColor.whiteColor];
    self.navigationItem.title = @"实人认证";
    
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD setMaximumDismissTimeInterval:1.5];
    [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
    [SVProgressHUD setHapticsEnabled:YES];
    [SVProgressHUD setMinimumSize:CGSizeMake(80, 80)];
    [SVProgressHUD setRingRadius:10];
    [SVProgressHUD setRingNoTextRadius:10];
    
}
- (IBAction)switchValueTagChanged:(UISwitch *)sender {
    
    if (sender.tag < 100) {
        if (sender.isOn) {
            [self.livenessArray addObject:@(sender.tag)];
        } else {
            [self.livenessArray removeObject:@(sender.tag)];
        }
    } else {
        if (sender.isOn) {
            [self.editArray addObject:@(sender.tag)];
        } else {
            [self.editArray removeObject:@(sender.tag)];
        }
    }
    
    //对数组进行排序
    NSArray *result = [self.livenessArray sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2){

        return [obj1 compare:obj2];//升序
        
    }];
    
    NSLog(@"result=%@",result);
    
    self.livenessArray = [[NSMutableArray alloc] initWithArray:result];
}

- (IBAction)start:(id)sender {
//    [self test];
    CLRPConfigure * config = [CLRPConfigure new];
//    config.navigationController = self.navigationController;//使用PUSH方式则传入当前navigationController，不传则使用Modal方式
    config.requestTimeOut = [NSNumber numberWithFloat:25];//单个请求超时设置
    //config.liveActionArray = @[@(CLRPFaceLivenessActionTypeLiveEye),@(CLRPFaceLivenessActionTypeLiveMouth),@(CLRPFaceLivenessActionTypeLiveYaw),@(CLRPFaceLivenessActionTypeLivePitchDown)].mutableCopy;
    config.liveActionArray = self.livenessArray.mutableCopy;
    config.isByOrder = YES;//是否按liveActionArray的设置顺序执行动作，默认为NO(随机顺序)
    config.numOfLiveness = 1;//设置了liveActionArray后此属性无效
    config.nameOpenEdit = [self.editArray containsObject:@(100)];
    config.addressOpenEdit = [self.editArray containsObject:@(101)];
    config.idCardOpenEdit = [self.editArray containsObject:@(102)];
    
    [CLRPSDKManager configure:config];
    
    //此处建议添加loading
    // 以下情况会出现短暂延迟
    //1：当初始化获取ticket失败后，调实人认证会尝试再次获取，此时若网络环境差会出现短暂延迟
    //2：当实人认证流程结束后，会重新生成ticketc供下次使用，若生成ticket失败，调实人认证会尝试再次获取，此时若网络环境差会出现短暂延迟
    //3：活体检测摄像头准备可能会有短暂延迟
//    [SVProgressHUD setContainerView:self.view];
//    [SVProgressHUD show];
    [CLRPSDKManager verify:self
              processBlock:^(CLRPCompleteResult *completeResult) {
        
    } complete:^(CLRPCompleteResult *completeResult) {
        
    }];
        
    return;
    [CLRPSDKManager verify:self processBlock:^(CLRPCompleteResult *completeResult) {
        
        //过程中的回调(多次回调)：
        
        if (completeResult.code == 1105) {
            NSLog(@"CLSDK_Progress_Log*****>身份证正面认证成功");
        } else if (completeResult.code == 1106) {
            NSLog(@"CLSDK_Progress_Log*****>身份证反面认证成功");
        } else if (completeResult.code == 1107) {
            NSLog(@"CLSDK_Progress_Log*****>人证合验成功");
        } else if (completeResult.code == 1108) {
            NSLog(@"CLSDK_Progress_Log*****>身份证二要素校验成功");
        }

        if (completeResult.code == 1005) {
            NSLog(@"CLSDK_Progress_Log*****>身份证正面认证失败");
        } else if (completeResult.code == 1006) {
            NSLog(@"CLSDK_Progress_Log*****>身份证反面认证失败");
        } else if (completeResult.code == 1007) {
            NSLog(@"CLSDK_Progress_Log*****>人证合验失败");
        } else if (completeResult.code == 1008) {
            NSLog(@"CLSDK_Progress_Log*****>身份证二要素验证失败");
        }
        
        if (completeResult.code == 1104) {
            //原始身份证图像信息识别完成回调(修改前)
            CLRPOcrIDCardModel * iDCardModel = completeResult.clModel;
            NSString * name = iDCardModel.name;
            NSString * address = iDCardModel.address;
            NSString * birth = iDCardModel.birth;
            NSString * cardNum = iDCardModel.cardNum;
            NSString * sex = iDCardModel.sex;
            NSString * nation = iDCardModel.nation;
            NSString * issuingAuthority = iDCardModel.issuingAuthority;
            NSString * issuingDate = iDCardModel.issuingDate;
            NSString * expiryDate = iDCardModel.expiryDate;
            NSString * riskType = iDCardModel.riskType;
            
            NSLog(@"CLSDK_Progress_Log*****>原始身份证图像信息识别完成回调：\n姓名：%@\n身份证号：%@\n性别：%@\n出生日期：%@\n名族：%@\n地址：%@\n签发机关：%@\n有效期限：%@~%@\n身份证风险提示类型:%@",name,cardNum,sex,birth,nation,address,issuingAuthority,issuingDate,expiryDate,riskType);
        }
        
    } complete:^(CLRPCompleteResult *completeResult) {
        //结果回调（实人认证结束，成功或者失败，只回调一次）：
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            //最终的身份证信息 从completeResult.clModel属性获取,为CLRPOcrIDCardModel类，即使失败，如果身份证OCR步骤成功依然可以获取到身份证信息
            CLRPOcrIDCardModel * iDCardModel = completeResult.clModel;
            if (iDCardModel) {
                
                NSString * name = iDCardModel.name;
                NSString * address = iDCardModel.address;
                NSString * birth = iDCardModel.birth;
                NSString * cardNum = iDCardModel.cardNum;
                NSString * sex = iDCardModel.sex;
                NSString * nation = iDCardModel.nation;
                NSString * issuingAuthority = iDCardModel.issuingAuthority;
                NSString * issuingDate = iDCardModel.issuingDate;
                NSString * expiryDate = iDCardModel.expiryDate;
                NSString * riskType = iDCardModel.riskType;
                
                NSLog(@"\n姓名：%@\n身份证号：%@\n性别：%@\n出生日期：%@\n名族：%@\n地址：%@\n签发机关：%@\n有效期限：%@~%@\n身份证风险提示类型:%@",name,cardNum,sex,birth,nation,address,issuingAuthority,issuingDate,expiryDate,riskType);
            }
            
            VerifyResultViewController * vc = [[VerifyResultViewController alloc]init];

            //认证分数从completeResult.clValue属性获取，建议分值大于80分为成功（也可以再结合身份证验证结果中的风险类型（riskType）自行判断）
            if (completeResult.error == nil && completeResult.clValue >= 80) {
                
                
                vc.isVerifySuccess = YES;
                
                NSDictionary * livenessImages = completeResult.data;
                
                //身份证正面
                UIImage * CLRPIDCard_Front = [UIImage imageWithContentsOfFile:livenessImages[@"CLRPIDCard_Front"]];
                //身份证反面
                UIImage * CLRPIDCard_Back = [UIImage imageWithContentsOfFile:livenessImages[@"CLRPIDCard_Back"]];
                //活体检测最优照片
                UIImage * livenessBestimage = [UIImage imageWithContentsOfFile:livenessImages[@"CLRPFaceLiveness"]];
                //活体检测动作照片：
                UIImage * livenessLiveEye = [UIImage imageWithContentsOfFile:livenessImages[@"CLRPFaceLivenessActionTypeLiveEye"]];
                UIImage * livenessLiveMouth = [UIImage imageWithContentsOfFile:livenessImages[@"CLRPFaceLivenessActionTypeLiveMouth"]];
                UIImage * livenessLiveYawRight = [UIImage imageWithContentsOfFile:livenessImages[@"CLRPFaceLivenessActionTypeLiveYawRight"]];
                UIImage * livenessLiveYawLeft = [UIImage imageWithContentsOfFile:livenessImages[@"CLRPFaceLivenessActionTypeLiveYawLeft"]];
//                UIImage * livenessLivePitchUp = [UIImage imageWithContentsOfFile:livenessImages[@"CLRPFaceLivenessActionTypeLivePitchUp"]];
//                UIImage * livenessLivePitchDown = [UIImage imageWithContentsOfFile:livenessImages[@"CLRPFaceLivenessActionTypeLivePitchDown"]];
                UIImage * livenessLiveYaw = [UIImage imageWithContentsOfFile:livenessImages[@"CLRPFaceLivenessActionTypeLiveYaw"]];
                
                NSLog(@"%@",completeResult);
                NSLog(@"%@",completeResult.data);
                
            } else {
                
                if (completeResult.code == 1010) {
                    //用户点击返回
                    return ;
                }
                
                vc.isVerifySuccess = NO;
                vc.verifyMessage = completeResult.message;
            }
            
            //清除缓存（清除后将不能取到活体检测照片等信息，建议在最后调用）
            [CLRPSDKManager cleanTempCache];
            
            [self.navigationController pushViewController:vc animated:YES];
        });
    }];
    
    
    
 
    
}

- (void)runTests
{
    NSLog(@"===========");
    unsigned int count;
    Method *methods = class_copyMethodList(NSClassFromString(@"CLRPVideoCaptureDevice"), &count);
    for (int i = 0; i < count; i++)
    {
        Method method = methods[i];
        SEL selector = method_getName(method);
        NSString *name = NSStringFromSelector(selector);
        NSLog(@"%@", name);
    }
    
    
    {
        unsigned int count;
        objc_property_t *properties = class_copyPropertyList(NSClassFromString(@"CLRPVideoCaptureDevice"), &count);
        for(int i = 0; i < count; i++)
        {
            objc_property_t property = properties[i];
            
            NSLog(@"property:%s",property_getName(property));
            

            
            
        }
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.imageView = [[UIImageView alloc] init];
    self.imageView.backgroundColor = UIColor.redColor;
    self.imageView.frame = CGRectMake(0, 100, 200, 200);
    [self.view addSubview:self.imageView];
}

- (void)test {

    dispatch_queue_t quque1 =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(quque1, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            
            UIViewController *vc = ((UINavigationController *)self.presentedViewController).viewControllers.firstObject;
            
            NSLog(@"%@", vc);
            for (UIView * view in vc.view.subviews) {
                if ([view isKindOfClass:[UIImageView class]]) {
                    UIImageView *imageview = (UIImageView *)view;
                    
                    
                    if (imageview.image) {
                        [self.view addSubview:view];
                        if (imageview.image.size.width > 1000) {
                
                            self.imageView.image = [[UIImage alloc] initWithCGImage:imageview.image.CGImage];
                        }
    
                        
                    }
                    view.hidden = YES;
                   
//                    NSLog(@"%@", imageview.image);
                }

            }
        });
    });
    
    

    
}

@end
