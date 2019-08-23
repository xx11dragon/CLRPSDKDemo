//
//  VerifyResultViewController.m
//  CLRPSDKDemo
//
//  Created by wanglijun on 2018/12/24.
//  Copyright © 2018 wanglijun. All rights reserved.
//

#import "VerifyResultViewController.h"

#import <Masonry.h>

@interface VerifyResultViewController ()

@end

@implementation VerifyResultViewController

#define CLRPSCREENSCALE [UIScreen mainScreen].bounds.size.width/375.0

-(void)dismiss{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"认证结果";
    
    //返回按钮
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"title_back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(dismiss)];
    backItem.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = backItem;
    
    if (self.isVerifySuccess) {
        [self setSuccessView];
    }else{
        [self setFauileView];
    }
}


-(void)setSuccessView{
    
    UIButton * tryAgainButton = [UIButton new];
    UIImageView * stutasImageView = [UIImageView new];
    UILabel * tipLabel = [UILabel new];
    
    [self.view addSubview:tryAgainButton];
    [self.view addSubview:stutasImageView];
    [self.view addSubview:tipLabel];
    
    [stutasImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(140*CLRPSCREENSCALE);
        make.height.mas_equalTo(115*CLRPSCREENSCALE);
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-65*CLRPSCREENSCALE);
    }];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(25);
        make.top.mas_equalTo(stutasImageView.mas_bottom).offset(20);
    }];
    [tryAgainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(300*CLRPSCREENSCALE);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(tipLabel.mas_bottom).offset(40);
    }];
    
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont boldSystemFontOfSize:24];
    tipLabel.textColor = [UIColor colorWithRed:96/255.0 green:101/255.0 blue:129/255.0 alpha:1];
    tipLabel.text = @"认证成功";
    
    stutasImageView.contentMode = UIViewContentModeScaleAspectFit;
    stutasImageView.image = [UIImage imageNamed:@"认证成功"];
    
    tryAgainButton.layer.cornerRadius =4;
    [tryAgainButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [tryAgainButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [tryAgainButton setBackgroundColor:[UIColor colorWithRed:63/255.0 green:117/255.0 blue:252/255.0 alpha:1]];
    [tryAgainButton addTarget:self action:@selector(tryAgain:) forControlEvents:(UIControlEventTouchUpInside)];
    [tryAgainButton setTitle:@"再次体验" forState:(UIControlStateNormal)];
}

-(void)setFauileView{
    
    UIButton * tryAgainButton = [UIButton new];
    UIImageView * stutasImageView = [UIImageView new];
    UILabel * tipLabel = [UILabel new];
    UILabel * tipDescribeLabel = [UILabel new];

    [self.view addSubview:tryAgainButton];
    [self.view addSubview:stutasImageView];
    [self.view addSubview:tipLabel];
    [self.view addSubview:tipDescribeLabel];

    [stutasImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(140*CLRPSCREENSCALE);
        make.height.mas_equalTo(115*CLRPSCREENSCALE);
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-65*CLRPSCREENSCALE);
    }];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(25);
        make.top.mas_equalTo(stutasImageView.mas_bottom).offset(20);
    }];
    [tipDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_greaterThanOrEqualTo(20);
        make.top.mas_equalTo(tipLabel.mas_bottom).offset(18);
    }];
    [tryAgainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(300*CLRPSCREENSCALE);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(tipDescribeLabel.mas_bottom).offset(40);
    }];
    
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont boldSystemFontOfSize:24];
    tipLabel.textColor = [UIColor colorWithRed:96/255.0 green:101/255.0 blue:129/255.0 alpha:1];
    tipLabel.text = @"认证失败";
    
    tipDescribeLabel.textAlignment = NSTextAlignmentCenter;
    tipDescribeLabel.font = [UIFont systemFontOfSize:15];
    tipDescribeLabel.textColor = [UIColor colorWithRed:145/255.0 green:152/255.0 blue:170/255.0 alpha:1];
    tipDescribeLabel.numberOfLines = 0 ;
    tipDescribeLabel.text = self.verifyMessage;
//    tipDescribeLabel.text = @"姓名与身份证号不匹配\n活体照片与身份证照片不一致";
    
    stutasImageView.contentMode = UIViewContentModeScaleAspectFit;
    stutasImageView.image = [UIImage imageNamed:@"认证失败"];
    
    tryAgainButton.layer.cornerRadius =4;
    [tryAgainButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [tryAgainButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [tryAgainButton setBackgroundColor:[UIColor colorWithRed:63/255.0 green:117/255.0 blue:252/255.0 alpha:1]];
    [tryAgainButton addTarget:self action:@selector(tryAgain:) forControlEvents:(UIControlEventTouchUpInside)];
    [tryAgainButton setTitle:@"重新认证" forState:(UIControlStateNormal)];
}

-(void)tryAgain:(UIButton *)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
