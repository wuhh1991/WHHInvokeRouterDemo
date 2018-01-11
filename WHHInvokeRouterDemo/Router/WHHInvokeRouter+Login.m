//
//  WHHInvokeRouter+Login.m
//  WHHInvokeRouterDemo
//
//  Created by 吴煌辉 on 2018/1/10.
//  Copyright © 2018年 whh. All rights reserved.
//

#import "WHHInvokeRouter+Login.h"

@implementation WHHInvokeRouter (Login)

- (void)loginWithUsename:(NSString *)usernamme Password:(NSInteger)password
{
    [WHHInvokeRouter dispatchInvokes:@"login" action:@"loginWithUsename:Password:" error:nil,usernamme,password];
}

- (NSString *)testDict:(NSDictionary *)dic AndArray:(NSArray *)array andBlock:(void(^)(int status))block
{
   return [WHHInvokeRouter dispatchInvokes:@"login" action:@"testDict:AndArray:andBlock:" error:nil,dic,array,block];
}
@end
