//
//  UIViewController.m
//  CLRPSDKDemo
//
//  Created by xx11dragon on 2019/8/23.
//  Copyright © 2019 wanglijun. All rights reserved.
//

#import "UIViewController.h"
#import "JRSwizzle.h"

@implementation UIViewController (x)

+ (void) load {
    [NSClassFromString(@"CLPRLivenessViewController") jr_swizzleMethod:@selector(s_faceProcesss:)
                                                            withMethod:@selector(faceProcesss:)
                                                                 error:nil];
    [NSClassFromString(@"CLPRLivenessViewController") jr_swizzleMethod:@selector(s_refreshUploadDictWithActionName:isRequired:)
                                                            withMethod:@selector(refreshUploadDictWithActionName:isRequired:)
                                                                 error:nil];
}

- (void)s_viewDidAppear:(BOOL)animated {
    [self s_viewDidAppear:animated];
    NSLog(@"%@", [self valueForKey:@"livenessArray"]);
    NSLog(@"%@", [self valueForKey:@"livenessArray"]);
    NSLog(@"%@", [self performSelector:NSSelectorFromString(@"clrpc_player")]);
}

- (void)s_faceProcesss:(id)obj {
    [self s_faceProcesss:obj];
    NSLog(@"%@", obj);
}


- (void)s_refreshUploadDictWithActionName:(id)lo isRequired:(id)ro {
//    [self s_refreshUploadDictWithActionName:lo isRequired:ro];
    NSLog(@"%@", lo);
    NSLog(@"%@", ro);
}
@end
