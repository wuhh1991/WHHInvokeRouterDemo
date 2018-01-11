//
//  _interface_login.m
//  WHHInvokeRouterDemo
//
//  Created by 吴煌辉 on 2018/1/10.
//  Copyright © 2018年 whh. All rights reserved.
//

#import "_interface_login.h"

@implementation _interface_login

- (void)loginWithUsename:(NSString *)usernamme Password:(NSInteger)password
{
    NSLog(@"username:%@ password:%ld",usernamme,password);
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
@end
