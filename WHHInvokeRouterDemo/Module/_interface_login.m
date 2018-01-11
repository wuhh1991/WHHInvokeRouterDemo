//
//  _interface_login.m
//  WHHInvokeRouterDemo
//
//  Created by 吴煌辉 on 2018/1/10.
//  Copyright © 2018年 whh. All rights reserved.
//

#import "_interface_login.h"
#import <UIKit/UIKit.h>

@implementation _interface_login

- (void)loginWithUsername:(NSString *)usernamme Password:(NSInteger)password
{
    NSLog(@"username:%@ password:%ld",usernamme,password);
    
    UIViewController *testVC = [[UIViewController alloc] init];
    testVC.title = @"登录";
    
    UIViewController *topmostVC = [self topViewController];
    [topmostVC.navigationController pushViewController:testVC animated:YES];
}

- (void)remote_loginWithUsername:(NSString *)username Password:(NSString *)password
{
    [self loginWithUsername:username Password:[password integerValue]];
}

- (NSString *)testDict:(NSDictionary *)dic AndArray:(NSArray *)array andBlock:(void(^)(int status))block
{
    if (dic) {
        NSLog(@"dic:%@",dic);
    }
    
    if (array.count>0) {
        NSLog(@"array:%@",array);
    }
    
    if (block) {
        block(1);
    }
    
    return @"Test";
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end
