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
#import "UINavigationController+YYYNavigationBar.h"

#import "Test1TableViewCell.h"
#import "Test2TableViewCell.h"

@interface TestTableViewController ()

@end

@implementation TestTableViewController

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"2222";

    self.yyy_navigationManager.navigationBarTintColor = [UIColor greenColor];
    self.yyy_navigationManager.navigationBarTitleColor = [UIColor greenColor];
    self.yyy_navigationManager.navigationBarShadowImageColor = [UIColor blueColor];
    self.yyy_navigationManager.navigationBarAlpha = 0;
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor blueColor];
    self.yyy_navigationManager.customBarBackgroundView = view;
    self.yyy_navigationManager.statusBarStyle = UIStatusBarStyleLightContent;

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"item" style:UIBarButtonItemStylePlain target:self action:@selector(nextView)];

    [self.tableView registerClass:Test1TableViewCell.class forCellReuseIdentifier:@"Test1TableViewCell"];
    [self.tableView registerClass:Test2TableViewCell.class forCellReuseIdentifier:@"Test2TableViewCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    self.yyy_navigationManager.hiddenNavigationBar = YES;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nextView {
    ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"vc"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        return 100;
    }
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *idf = indexPath.row % 2 ? @"Test1TableViewCell" : @"Test2TableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idf forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"row %@",@(indexPath.row)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < 5) {
        ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"vc"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
//        TestTableViewController *vc = [TestTableViewController new];
//
//        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
//        if (@available(iOS 11, *)) {
//            nav.navigationBar.prefersLargeTitles = YES;
//        }
//        nav.yyy_enabled = NO;
//        nav.navigationBar.translucent = NO;
//        [vc.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
//        [self presentViewController:nav animated:YES completion:nil];
    }
}
//
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat alpha = (scrollView.contentOffset.y + scrollView.contentInset.top)/100.f;
    NSLog(@"change %@",@(alpha));
    self.yyy_navigationManager.navigationBarAlpha = alpha;
}

@end
