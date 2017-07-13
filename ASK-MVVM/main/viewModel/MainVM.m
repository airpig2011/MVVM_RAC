//
//  MainVM.m
//  ASK-MVVM
//
//  Created by dajie chen on 2017/7/13.
//  Copyright © 2017年 dajie chen. All rights reserved.
//

#import "MainVM.h"
#import "ReactiveCocoa.h"
#import "ASKNetworkHelper.h"

//https://wx.jcloud.com/, 请到京东万象注册申请appkey
#define APPKEY          @""

@implementation MainVM

//请求天气信息
-(void)requestWeatherData{

    [[self acquireWeatherData]subscribeNext:^(id responseObject) {
        if (responseObject) {
            self.rac_resObj1 = responseObject;
        }
    }];
    
}
//请求空气信息
-(void)requestAirData{
    
    [[self acquireWeatherData]subscribeNext:^(id responseObject) {
        if (responseObject) {
            self.rac_resObj2 = responseObject;
        }
    }];
    
}

-(void)requestWeatherDataAndAirData{
    
    //请求天气信息
    [[[self acquireWeatherData]
      
      flattenMap:^RACStream *(id responseObject) {
          
          self.rac_resObj1 = responseObject;
          return [self acquireAirData];
      }]
     //请求空气信息
     subscribeNext:^(id responseObject) {
         self.rac_resObj2 = responseObject;
     }];
}

-(RACSignal*)acquireWeatherData{

    NSString *urlStr = [NSString stringWithFormat:@"https://way.jd.com/he/freeweather?city=beijing&appkey=%@",APPKEY];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    return [ASKNetworkHelper racGET:urlStr
                         parameters:parameter
                      responseCache:NO
                            success:nil
                            failure:nil
            ];
}

-(RACSignal*)acquireAirData{
    
    NSString *urlStr = [NSString stringWithFormat:@"https://way.jd.com/jisuapi/weather?appkey=%@",APPKEY];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"city"] = @"安顺";
    parameter[@"cityid"] = @"111";
    parameter[@"citycode"] = @"101260301";
    parameter[@"appkey"] = APPKEY;
    return [ASKNetworkHelper racPOST:urlStr
                         parameters:parameter
                      responseCache:NO
                            success:nil
                            failure:nil
            ];
}

@end
