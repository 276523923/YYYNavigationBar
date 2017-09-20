//
//  ViewController.m
//  YYYNavigationBar
//
//  Created by 叶越悦 on 2017/9/15.
//  Copyright © 2017年 叶越悦. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+YYYNavigationBar.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"1111";
    self.view.backgroundColor = [UIColor whiteColor];
    self.yyy_navigationBarBarTintColor = [UIColor redColor];
    self.yyy_navigationBarShadowImageColor = [UIColor redColor];
    self.yyy_navigationBarTintColor = [UIColor blackColor];
    self.yyy_navigationBarHeight = 44;
//    self.yyy_backgroundImage = [UIImage imageNamed:@"lagou3"];
    self.yyy_navigationBarAlpha = 1;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%s",__func__);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
