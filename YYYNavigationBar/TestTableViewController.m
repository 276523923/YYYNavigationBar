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
    self.yyy_preferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.yyy_navigationBarTintColor = [UIColor redColor];
    self.yyy_navigationBarTitleColor = [UIColor redColor];
    
    self.yyy_navigationBarShadowImageColor = [UIColor cyanColor];
    self.yyy_navigationBarBarTintColor = [UIColor whiteColor];
//    self.yyy_navigationBarAlpha = 0;
  
//    self.yyy_backgroundImage = [UIImage imageNamed:@"imageNav"];
//    self.navigationItem.titleView =({
//        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 375, 44)];
//        textField.backgroundColor = [UIColor redColor];
//        textField;
//    });
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

//    [self.navigationController setNavigationBarHidden:YES];
//    self.yyy_hiddenNavigationBar = YES;
    
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"vc"];
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    self.yyy_navigationBarAlpha = (scrollView.contentOffset.y + scrollView.contentInset.top)/100.f;
//}

@end
