//
//  WHHInvokeRouter.h
//  WHHInvokeRouterDemo
//
//  Created by 吴煌辉 on 2018/1/10.
//  Copyright © 2018年 whh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHHInvokeRouter : NSObject

+ (nonnull instancetype)sharedInstance;

+ (nullable id)dispatchInvokes:(nonnull NSString *)target action:(nullable NSString *)action error:(NSError * _Nullable __autoreleasing * _Nullable)error, ...;
+ (nullable id)dispatchInvokesWithUrl:(nonnull NSString *)url;

@end
