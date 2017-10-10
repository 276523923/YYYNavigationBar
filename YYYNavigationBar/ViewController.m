//
//  ViewController.m
//  YYYNavigationBar
//
//  Created by 叶越悦 on 2017/9/15.
//  Copyright © 2017年 叶越悦. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+YYYNavigationBar.h"
#import "BarBackgroundView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"1111";
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    } else {
        // Fallback on earlier versions
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.yyy_navigationBarBarTintColor = [UIColor redColor];
    self.yyy_navigationBarShadowImageColor = [UIColor redColor];
    self.yyy_customBarBackgroundView = [BarBackgroundView new];
    self.yyy_customBarBackgroundView.alpha = 0.8;
    
//    self.yyy_navigationBarShadowImageColor = [UIColor redColor];
//    self.yyy_navigationBarTintColor = [UIColor blackColor];
//    self.yyy_navigationBarAlpha = 1;
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
