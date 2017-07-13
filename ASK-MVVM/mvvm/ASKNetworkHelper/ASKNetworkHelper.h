//
//  ASKNetworkHelper.h
//  ASKNetworkHelper
//
//  Created by dajie chen on 02/21/17.
//  Copyright © 2017年 dajie chen. All rights reserved.
//

@class AFHTTPSessionManager;
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RACSignal.h"

#ifndef kIsNetwork
#define kIsNetwork     [ASKNetworkHelper isNetwork]  // 一次性判断是否有网的宏
#endif

#ifndef kIsWWANNetwork
#define kIsWWANNetwork [ASKNetworkHelper isWWANNetwork]  // 一次性判断是否为手机网络的宏
#endif

#ifndef kIsWiFiNetwork
#define kIsWiFiNetwork [ASKNetworkHelper isWiFiNetwork]  // 一次性判断是否为WiFi网络的宏
#endif

#define MB_HUD

typedef NS_ENUM(NSUInteger, ASKNetworkStatusType) {
    /** 未知网络*/
    ASKNetworkStatusUnknown,
    /** 无网络*/
    ASKNetworkStatusNotReachable,
    /** 手机网络*/
    ASKNetworkStatusReachableViaWWAN,
    /** WIFI网络*/
    ASKNetworkStatusReachableViaWiFi
};

typedef NS_ENUM(NSUInteger, ASKRequestSerializer) {
    /** 设置请求数据为JSON格式*/
    ASKRequestSerializerJSON,
    /** 设置请求数据为二进制格式*/
    ASKRequestSerializerHTTP,
};

typedef NS_ENUM(NSUInteger, ASKResponseSerializer) {
    /** 设置响应数据为JSON格式*/
    ASKResponseSerializerJSON,
    /** 设置响应数据为二进制格式*/
    ASKResponseSerializerHTTP,
};

/** 请求成功的Block */
typedef void(^ASKHttpRequestSuccess)(id responseObject);

/** 请求失败的Block */
typedef void(^ASKHttpRequestFailed)(NSError *error);

/** 缓存的Block */
typedef void(^ASKHttpRequestCache)(id responseCache);

/** 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小*/
typedef void (^ASKHttpProgress)(NSProgress *progress);

/** 网络状态的Block*/
typedef void(^ASKNetworkStatus)(ASKNetworkStatusType status);



@interface ASKNetworkHelper : NSObject

/**
 实时获取网络状态,通过Block回调实时获取(此方法可多次调用)
 */
+ (void)networkStatusWithBlock:(ASKNetworkStatus)networkStatus;


+(void)initHttpsSecurity:(AFHTTPSessionManager *)sessionManager;

#pragma mark - POST GET

+ (__kindof NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(NSDictionary *)parameters
                     responseCache:(BOOL)responseCache
                           success:(ASKHttpRequestSuccess)success
                           failure:(ASKHttpRequestFailed)failure ;



+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                      responseCache:(BOOL)responseCache
                            success:(ASKHttpRequestSuccess)success
                            failure:(ASKHttpRequestFailed)failure ;

#pragma mark - POST GET RAC

+ (RACSignal *)racGET:(NSString *)URL
           parameters:(NSDictionary *)parameters
        responseCache:(BOOL)responseCache
              success:(ASKHttpRequestSuccess)success
              failure:(ASKHttpRequestFailed)failure;


+ (RACSignal *)racPOST:(NSString *)URL
            parameters:(NSDictionary *)parameters
         responseCache:(BOOL)responseCache
               success:(ASKHttpRequestSuccess)success
               failure:(ASKHttpRequestFailed)failure;
@end

