//
//  ViewController.m
//  AKSNetWork
//
//  Created by simonssd on 2019/5/6.
//  Copyright © 2019年 Acadsoc. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    class_addMethod([ViewController class], @selector(findInSelf), class_getMethodImplementation([ViewController class], @selector(addFind:)), "v@:");
}

- (void)findInSelf {
    NSLog(@"%@",@"findInSelf");
}

- (void)addFind:(NSString *)object {
    
    NSLog(@"%@",object);
}

@end
