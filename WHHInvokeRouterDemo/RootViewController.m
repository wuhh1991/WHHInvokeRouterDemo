//
//  RootViewController.m
//  WHHInvokeRouterDemo
//
//  Created by 吴煌辉 on 2018/1/10.
//  Copyright © 2018年 whh. All rights reserved.
//

#import "RootViewController.h"
#import "WHHInvokeRouter.h"
#import "WHHInvokeRouter+Login.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"主页";
    [[WHHInvokeRouter sharedInstance] loginWithUsename:@"wuhh" Password:123];
    NSString *result = [[WHHInvokeRouter sharedInstance] testDict:@{@"T":@"Test"} AndArray:@[@"test"] andBlock:^(int status) {
        NSLog(@"%d",status);
    }];
    
    NSLog(@"result:%@",result);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
