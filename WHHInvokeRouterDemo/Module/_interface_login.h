//
//  _interface_login.h
//  WHHInvokeRouterDemo
//
//  Created by 吴煌辉 on 2018/1/10.
//  Copyright © 2018年 whh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface _interface_login : NSObject

- (void)loginWithUsername:(NSString *)usernamme Password:(NSInteger)password;

- (NSString *)testDict:(NSDictionary *)dic AndArray:(NSArray *)array andBlock:(void(^)(int status))block;

@end
