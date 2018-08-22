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
#import "UINavigationController+YYYNavigationBar.h"
#import "TestTableViewController.h"

@interface ViewController ()<CAAnimationDelegate>
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"1111";
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    }
    self.view.backgroundColor = [UIColor greenColor];
    self.yyy_navigationManager.navigationBarShadowImageColor = [UIColor blueColor];
    self.yyy_navigationManager.navigationBarAlpha = 0.5;
    
    YYYNavigationManager *manager = self.yyy_navigationManager;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
