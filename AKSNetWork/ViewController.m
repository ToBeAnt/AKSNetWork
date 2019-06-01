//
//  ViewController.m
//  AKSNetWork
//
//  Created by simonssd on 2019/5/6.
//  Copyright © 2019年 Acadsoc. All rights reserved.
//

#import "ViewController.h"

#import "AKSApiProxy.h"
#import "AKSNetWorkRequestConfig.h"
#import "AKSApiRequestManager.h"
#import "AKSHTTPEyeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *Btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    Btn.center = self.view.center;
    Btn.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:Btn];
    [Btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tap];
}

- (void)btnClick {
    
    int rad = rand()%3;
    
    AKSNetWorkRequestConfig *config = [[AKSNetWorkRequestConfig alloc] init];
    config.method = @"POST";
    
    switch (rad) {
        case 0: {
            config.urlString = @"https://ies.acadsoc.com.cn/eci/PrimarySchool/PrimarySchool_Base.ashx";
            config.params = [NSMutableDictionary dictionaryWithDictionary:@{@"Action":@"PrimarySchool_IsVipUser",
                                                                            @"UID":@"610828",
                                                                            @"AppKey":@"049BD15C6FC04BD80808A601DC46E50515CBEEA33FB29AB4"
                                                                            }];
        }
            break;
        case 1: {
            config.urlString = @"https://ies.acadsoc.com.cn/eci/PrimarySchool/PrimarySchool_Base.ashx";
            config.params = [NSMutableDictionary dictionaryWithDictionary:@{@"Action":@"PrimarySchool_V_3_2_VipIndex",
                                                                            @"UCUID":@"1296587",
                                                                            @"AppTagID":@"7",
                                                                            @"AppKey":@"049BD15C6FC04BD80808A601DC46E50515CBEEA33FB29AB4"
                                                                            }];
        }
            break;
        default:
            config.urlString = @"http://ip.taobao.com/service/getIpInfo.php";
            config.params = [NSMutableDictionary dictionaryWithDictionary:@{@"ip":@"myip"}];
            break;
    }
    
    [[AKSApiRequestManager requestManager] AKS_networkRequestConfig:config completion:^(NSError * _Nonnull error, id  _Nonnull responseObject) {
        
        NSLog(@"%@",responseObject);
        
    }];
}

- (void)tapClick {
    
    AKSHTTPEyeViewController *vc = [AKSHTTPEyeViewController new];
    
    [self presentViewController:vc animated:YES completion:nil];
}

@end
