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
#import "AKSEncryptionManager.h"
#import "NSString+AKSNetWork.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *Btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    Btn.center = self.view.center;
    Btn.backgroundColor = [UIColor orangeColor];
    [Btn setTitle:@"请求" forState:UIControlStateNormal];
    [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:Btn];
    [Btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    textfield.center = CGPointMake(Btn.center.x, Btn.center.y - 100);
    textfield.keyboardType = UIKeyboardTypeNumberPad;
    textfield.backgroundColor = [UIColor whiteColor];
    textfield.textColor = [UIColor darkGrayColor];
    textfield.textAlignment = NSTextAlignmentCenter;
    textfield.tag = 100;
    [self.view addSubview:textfield];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tap];
}

- (void)btnClick {
    
    UITextField *textfield = [self.view viewWithTag:100];
    int rad = [textfield.text intValue];
    
    AKSNetWorkRequestConfig *config = [[AKSNetWorkRequestConfig alloc] init];
    config.method = @"POST";
    
    switch (rad) {
        case 0: {
            config.urlString = @"http://192.168.74.54:7019/api/Test/LoginTest";
            config.params = [NSMutableDictionary dictionaryWithDictionary:@{@"Phone":@"YPnjUzKsSnwLkVJRza65WA==",
                                                                            @"Password":@"kqJ8XcgMecizsUXoWyf33g==",
                                                                            @"AppTagID":@"1"
                                                                            }];
        }
            break;
        case 1: {
            config.urlString = @"http://192.168.74.54:7019/api/Test/CheckSignVerify";
            config.params = [NSMutableDictionary dictionaryWithDictionary:@{@"Phone":@"YPnjUzKsSnwLkVJRza65WA==",
                                                                            @"Password":@"kqJ8XcgMecizsUXoWyf33g==",
                                                                            @"AppTagID":@"1",
                                                                            }];
        }
            break;
        default:
            config.urlString = @"http://192.168.74.54:7019/api/Test/LoginWithSign";
            NSDictionary *dict = @{@"Phone":[AKSEncryptionManager AKS_AESEncryptWithValue:@"13975017846"],
                                   @"Password":[AKSEncryptionManager AKS_AESEncryptWithValue:@"123456"],
                                   @"AppTagID":@"1"};
            config.params = [NSMutableDictionary dictionaryWithDictionary:[AKSEncryptionManager AKS_SupplementParameter:dict]];
            break;
    }
    
    [[AKSApiRequestManager requestManager] AKS_networkRequestConfig:config completion:^(AKSURLResponse * _Nonnull response) {
        
        NSLog(@"%@",response.content);
    }];
}

- (void)tapClick {
    
    AKSHTTPEyeViewController *vc = [AKSHTTPEyeViewController new];
    
    [self presentViewController:vc animated:YES completion:nil];
}

@end
