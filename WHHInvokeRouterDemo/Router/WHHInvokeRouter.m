//
//  WHHInvokeRouter.m
//  WHHInvokeRouterDemo
//
//  Created by 吴煌辉 on 2018/1/10.
//  Copyright © 2018年 whh. All rights reserved.
//

#import "WHHInvokeRouter.h"
#import <Foundation/Foundation.h>

@implementation WHHInvokeRouter

static WHHInvokeRouter *_router = nil;

+ (instancetype)sharedInstance
{
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_router == nil) {
            _router = [super allocWithZone:zone];
        }
    });
    return _router;
}

+ (nullable id)dispatchInvokes:(nonnull NSString *)target action:(nullable NSString *)action error:(NSError * _Nullable __autoreleasing * _Nullable)error, ...
{
    
    NSString *targetName = [NSString stringWithFormat:@"_interface_%@", [target stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    Class targetClass = NSClassFromString(targetName);
    
    id targetObject = [[targetClass alloc] init];
    if (!targetObject) {
        NSLog(@"没有找到对应模块，跳转404页面");
        return nil;
    }
    
    SEL actionSelector = NSSelectorFromString([action stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
    if (![targetObject respondsToSelector:actionSelector]) {
        NSLog(@"对应模块没有相应的接口，跳转错误页面");
        return nil;
    }
    
    NSMethodSignature *methodSignature = [targetClass instanceMethodSignatureForSelector:actionSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    invocation.target = targetObject;
    invocation.selector = actionSelector;
    
    // 参数处理
    va_list argList;
    va_start(argList, error);
    for (int i = 2; i < [methodSignature numberOfArguments]; i++) {
        const char *argType = [methodSignature getArgumentTypeAtIndex:i];
        
#define WHH_SET_ARGUMENT(_encodeType,_valueType)      \
    if (strncmp(argType, _encodeType, 1) == 0) {                \
        _valueType value = va_arg(argList, _valueType);       \
        [invocation setArgument:&value atIndex:i];  \
        continue;                                      \
    }
        
        WHH_SET_ARGUMENT("c", int);
        WHH_SET_ARGUMENT("C", int);
        WHH_SET_ARGUMENT("s", int);
        WHH_SET_ARGUMENT("S", int);
        WHH_SET_ARGUMENT("i", int);
        WHH_SET_ARGUMENT("I", unsigned int);
        WHH_SET_ARGUMENT("l", long);
        WHH_SET_ARGUMENT("L", unsigned long);
        WHH_SET_ARGUMENT("q", long long);
        WHH_SET_ARGUMENT("Q", unsigned long long);
        WHH_SET_ARGUMENT("f", double);
        WHH_SET_ARGUMENT("d", double);
        WHH_SET_ARGUMENT("B", int);
        WHH_SET_ARGUMENT("@", id);
    }
    va_end(argList);

    [invocation invoke];
    
    id result = nil;
    if (methodSignature.methodReturnLength > 0) { // >0 说明有返回值
        const char *returnType = methodSignature.methodReturnType;
        if( !strcmp(returnType, @encode(id)) ){
            [invocation getReturnValue:&result];
        }
        else
        {
            //如果返回值为普通类型NSInteger  BOOL
            NSUInteger length = [methodSignature methodReturnLength];
            //根据长度申请内存
            void *buffer = (void *)malloc(length);
            //为变量赋值
            [invocation getReturnValue:buffer];
            
            if( !strcmp(returnType, @encode(BOOL)) ) {
                result = [NSNumber numberWithBool:*((BOOL*)buffer)];
            }
            else if( !strcmp(returnType, @encode(NSInteger)) ){
                result = [NSNumber numberWithInteger:*((NSInteger*)buffer)];
            }
            result = [NSValue valueWithBytes:buffer objCType:returnType];
        }
    }
    
    return result;
}


+ (nullable id)dispatchInvokesWithUrl:(nonnull NSString *)url
{
    NSURL *URL = [NSURL URLWithString:url];
    if (![URL.scheme isEqualToString:@"WHHRouterDemo"]) {
        
        return nil;
    }
    
    NSString *target = URL.host;
    NSString *targetName = [NSString stringWithFormat:@"_interface_%@", [target stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    Class targetClass = NSClassFromString(targetName);
    
    id targetObject = [[targetClass alloc] init];
    if (!targetObject) {
        NSLog(@"没有找到对应模块，跳转404页面");
        return nil;
    }
    
    NSMutableArray *paramNames = [[NSMutableArray alloc] init];
    NSMutableArray *paramValues = [[NSMutableArray alloc] init];
    NSString *urlString = [URL query];
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [paramNames addObject:[elts firstObject]];
        [paramValues addObject:[elts lastObject]];
    }
    
    NSString *actionName = [NSString stringWithFormat:@"remote_%@:", [URL.path substringFromIndex:1]];
    if (paramNames.count >1) {
        for (int i = 1; i<paramNames.count; i++) {
            NSString *name = [NSString stringWithFormat:@"%@:",paramNames[i]];
            actionName = [actionName stringByAppendingString:name];
        }
    }
    
    SEL actionSelector = NSSelectorFromString([actionName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
    if (![targetObject respondsToSelector:actionSelector]) {
        NSLog(@"对应模块没有相应的接口，跳转错误页面");
        return nil;
    }
    
    NSMethodSignature *methodSignature = [targetClass instanceMethodSignatureForSelector:actionSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    invocation.target = targetObject;
    invocation.selector = actionSelector;
    
    if (paramValues.count != methodSignature.numberOfArguments - 2) {
        NSLog(@"参数错误，跳转错误页面");
        return nil;
    }
    
    // 传递参数
    for (int i = 2; i < methodSignature.numberOfArguments; i++) {
        NSString *value = paramValues[i-2];
        [invocation setArgument:&value atIndex:i];
    }
    
    [invocation invoke];
    
    id result = nil;
    if (methodSignature.methodReturnLength > 0) { // >0 说明有返回值
        const char *returnType = methodSignature.methodReturnType;
        if( !strcmp(returnType, @encode(id)) ){
            [invocation getReturnValue:&result];
        }
        else
        {
            //如果返回值为普通类型NSInteger  BOOL
            NSUInteger length = [methodSignature methodReturnLength];
            //根据长度申请内存
            void *buffer = (void *)malloc(length);
            //为变量赋值
            [invocation getReturnValue:buffer];
            
            if( !strcmp(returnType, @encode(BOOL)) ) {
                result = [NSNumber numberWithBool:*((BOOL*)buffer)];
            }
            else if( !strcmp(returnType, @encode(NSInteger)) ){
                result = [NSNumber numberWithInteger:*((NSInteger*)buffer)];
            }
            result = [NSValue valueWithBytes:buffer objCType:returnType];
        }
    }
    
    return result;
}


@end
