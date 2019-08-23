//
//  AppDelegate.m
//  CLRPSDKDemo
//
//  Created by wanglijun on 2018/12/18.
//  Copyright © 2018 wanglijun. All rights reserved.
//

#import "AppDelegate.h"
#import "PrepairDataViewController.h"
#import <objc/runtime.h>
#import <CLRPSDK/CLRPSDK.h>
#import "AVCaptureDevice.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /*集成步骤：
     1 设置工程bundleID
     2 导入与bundleID对应的授权证书文件idl-license.face-ios和aip.license
     3 初始化方法填入AppID、AppKey、授权licenseID
     4 在需要的地方调用开始认证
    */
    //初始化
    [CLRPSDKManager initWithAppId:@"ovfUKt4R"
                           appKey:@"p7HMOmtS"
                        licenseID:@"123-sdk-face-ios"
                         complete:nil];
//    [CLRPSDKManager setLogEnabled:YES];
    //查看TicketID
    [[NSNotificationCenter defaultCenter] addObserverForName:NSNOTIF_NAME_CL_DIDGETNEWTICKETID object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"ticket:%@",note.object);
    }];
    

    NSArray *patch = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *target = [NSString stringWithFormat:@"%@/CLRPSDK_TEMP__IMAGE", patch];
    NSArray *filePath  = [[NSFileManager defaultManager] subpathsAtPath:target];  // 取得目录下所有文件列表

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[PrepairDataViewController new]];
    [self.window makeKeyAndVisible];

    
    return YES;
}



//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

- (NSArray *)propertys
{
    unsigned int count = 0;
    //获取属性的列表
    
    objc_property_t *propertyList =  class_copyPropertyList(NSClassFromString(@"CLRPSDKManager"), &count);
    NSMutableArray *propertyArray = [NSMutableArray array];
    
    for(int i=0;i<count;i++)
    {
        //取出每一个属性
        objc_property_t property = propertyList[i];
        //获取每一个属性的变量名
        const char* propertyName = property_getName(property);
        
        NSString *proName = [[NSString alloc] initWithCString:propertyName encoding:NSUTF8StringEncoding];
        
        [propertyArray addObject:proName];
    }
    //c语言的函数，所以要去手动的去释放内存
    free(propertyList);
    
    return propertyArray.copy;
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
