//
//  ASKNetworkHelper.m
//  ASKNetworkHelper
//
//  Created by dajie chen on /8/12.
//  Copyright © 2017年 dajie chen. All rights reserved.
//
#import "ASKNetworkCache.h"

#import "ASKNetworkHelper.h"

#import "AFNetworkActivityIndicatorManager.h"

#import "AFNetworking.h"

#import "ReactiveCocoa.h"


@implementation ASKNetworkHelper

static AFHTTPSessionManager *_sessionManager;

#pragma mark - 开始监听网络
+ (void)networkStatusWithBlock:(ASKNetworkStatus)networkStatus {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    networkStatus ? networkStatus(ASKNetworkStatusUnknown) : nil;
                    NSLog(@"未知网络");
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    networkStatus ? networkStatus(ASKNetworkStatusNotReachable) : nil;
                    NSLog(@"无网络");
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    networkStatus ? networkStatus(ASKNetworkStatusReachableViaWWAN) : nil;
                    NSLog(@"手机自带网络");
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    networkStatus ? networkStatus(ASKNetworkStatusReachableViaWiFi) : nil;
                    NSLog(@"WIFI");
                    break;
            }
        }];
    });
}



+(void)dealWithError:(NSError *)error URL:(NSString *)URL parameters:(id)parameters{
    
    NSString *status;
    
    switch (error.code) {
        case NSURLErrorCannotFindHost:
             NSLog(@"NSURLErrorCannotFindHost");
            break;
            
        case NSURLErrorBadServerResponse:
            NSLog(@"NSURLErrorBadServerResponse");
            status = [error localizedDescription];
            if([status isEqualToString:@"Request failed: unauthorized (401)"]){
                NSLog(@"error 401");
            }else {
                NSLog(@"网络异常，请检查网络后重试");
            }
            break;
            
        default:
            NSLog(@"error:%@",error);
            break;
    }
}

#pragma mark - GET

+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(NSDictionary *)parameters
            responseCache:(BOOL)responseCache
                  success:(ASKHttpRequestSuccess)success
                  failure:(ASKHttpRequestFailed)failure {
    
    if (responseCache) {
        id cache = [ASKNetworkCache httpCacheForURL:URL parameters:parameters];
        if(cache){
            if (success) {
                
                success(cache);
            }
            NSLog(@"+++++++++++++ GET，使用缓存 +++++++++++++");
            return nil;
        }
    }
    NSLog(@"+++++++++++++ GET，不使用缓存 +++++++++++++");
    
    [_sessionManager GET:URL parameters:parameters progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     
                     if(success){
                         success(responseObject);
                     }
                     [ASKNetworkCache setHttpCache:responseObject URL:URL parameters:parameters];
                     return;
                     
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                     [self dealWithError:error URL:URL parameters:parameters];
                     if(failure){
                         failure(error);
                     }
                     return;
                 }];
    return nil;
}

#pragma mark - POST

+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(NSDictionary *)parameters
             responseCache:(BOOL)responseCache
                   success:(ASKHttpRequestSuccess)success
                   failure:(ASKHttpRequestFailed)failure {
    
    if (responseCache) {
        id cache = [ASKNetworkCache httpCacheForURL:URL parameters:parameters];
        if(cache){
            if (success) {
                
                success(cache);
            }
            NSLog(@"+++++++++++++ POST，使用缓存 +++++++++++++");
            return nil;
        }
    }
    NSLog(@"+++++++++++++ POST，不使用缓存 +++++++++++++");
    
    [_sessionManager POST:URL parameters:parameters progress:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      if(success){
                          success(responseObject);
                      }
                      [ASKNetworkCache setHttpCache:responseObject URL:URL parameters:parameters];
                      return;
                      
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      [self dealWithError:error URL:URL parameters:parameters];
                      if(failure){
                          failure(error);
                      }
                      return;
                  }];
    return nil;
}


#pragma mark - RAC GET


+ (RACSignal *)racGET:(NSString *)URL
           parameters:(NSDictionary *)parameters
        responseCache:(BOOL)responseCache
              success:(ASKHttpRequestSuccess)success
              failure:(ASKHttpRequestFailed)failure {
    
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber){
        
        if (responseCache) {
            id cache = [ASKNetworkCache httpCacheForURL:URL parameters:parameters];
            if(cache){
                if (success) {
                    success(cache);
                }
                NSLog(@"+++++++++++++ racGET，使用缓存 +++++++++++++");
                [subscriber sendNext:cache];
                [subscriber sendCompleted];
                return nil;
            }
        }
        NSLog(@"+++++++++++++ racGET，不使用缓存 +++++++++++++");
        [_sessionManager GET:URL parameters:parameters progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         if(success){
                             success(responseObject);
                         }
                         [ASKNetworkCache setHttpCache:responseObject URL:URL parameters:parameters];
                         
                         [subscriber sendNext:responseObject];
                         [subscriber sendCompleted];
                         return;
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         [self dealWithError:error URL:URL parameters:parameters];
                         
                         if(failure){
                             failure(error);
                         }
                         [subscriber sendCompleted];
                         return;
                     }];
        return [RACDisposable disposableWithBlock:^{
            //[self cancelRequestWithURL:URL];
        }];
    }];
    
}
#pragma mark - RAC POST

+ (RACSignal *)racPOST:(NSString *)URL
            parameters:(NSDictionary *)parameters
         responseCache:(BOOL)responseCache
               success:(ASKHttpRequestSuccess)success
               failure:(ASKHttpRequestFailed)failure {
    
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber){
        
        if (responseCache) {
            id cache = [ASKNetworkCache httpCacheForURL:URL parameters:parameters];
            if(cache){
                if (success) {
                    
                    success(cache);
                }
                NSLog(@"+++++++++++++ racPOST，使用缓存 +++++++++++++");
                [subscriber sendNext:cache];
                [subscriber sendCompleted];
                return nil;
            }
        }
        NSLog(@"+++++++++++++ racPOST，不使用缓存 +++++++++++++");

        [_sessionManager POST:URL parameters:parameters progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                          if(success){
                              success(responseObject);
                          }
                          [ASKNetworkCache setHttpCache:responseObject URL:URL parameters:parameters];
                          
                          [subscriber sendNext:responseObject];
                          [subscriber sendCompleted];
                          return;
                          
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          
                          if(failure){
                              failure(error);
                          }
                          [subscriber sendCompleted];
                          return;
                      }];
        return [RACDisposable disposableWithBlock:^{
            //[self cancelRequestWithURL:URL];
        }];
    }];
}

/**
 开始监测网络状态
 */
+ (void)load {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

//实现证书信任
+(void)initHttpsSecurity:(AFHTTPSessionManager *)sessionManager{
#ifdef ENABLE_HTTPS
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [securityPolicy setValidatesDomainName:NO];
    sessionManager.securityPolicy = securityPolicy;
#endif
}



+ (void)initialize {
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    _sessionManager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:config];
    
    _sessionManager = [AFHTTPSessionManager manager];
    
    _sessionManager.requestSerializer.timeoutInterval = 10.f;
    _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    
    [self initHttpsSecurity:_sessionManager];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}
@end


