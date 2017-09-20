//
//  TestTableViewController.m
//  YYYNavigationBar
//
//  Created by 叶越悦 on 2017/9/15.
//  Copyright © 2017年 叶越悦. All rights reserved.
//

#import "TestTableViewController.h"
#import "UIViewController+YYYNavigationBar.h"
#import "ViewController.h"
#import <ARKit/ARKit.h>

@interface TestTableViewController ()

@end

@implementation TestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"2222";
    self.yyy_navigationBarBarTintColor = [UIColor yellowColor];
    self.yyy_navigationBarAlpha = 0;
    self.yyy_preferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.yyy_navigationBarShadowImageColor = [UIColor cyanColor];
    self.yyy_navigationBarTintColor = [UIColor redColor];
    self.yyy_navigationBarBarTintColor = [UIColor greenColor];
    self.yyy_navigationBarTitleColor = [UIColor greenColor];
    self.yyy_backgroundImage = [UIImage imageNamed:@"imageNav"];
    self.navigationItem.titleView =({
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
        textField.backgroundColor = [UIColor redColor];
        textField;
    });
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"row %@",@(indexPath.row)];
//    cell.contentView.backgroundColor = [UIColor redColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ViewController *vc = [ViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.yyy_navigationBarAlpha = scrollView.contentOffset.y/100;
}

@end
