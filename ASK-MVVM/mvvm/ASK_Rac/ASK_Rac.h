//
//  ASK_Rac.h
//  ASK-MVVM
//
//  Created by dajie chen on 2017/7/13.
//  Copyright © 2017年 dajie chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"

@interface ASK_Rac : NSObject

typedef void(^ASK_rac_change)(id x);

typedef void(^ASK_rac_notify)(NSNotification *notification);

+(void)observe:(id)obj key:(NSString *)property block:(ASK_rac_change)block;

//发送通知
+(void)postNotify:(id)notify object:(id)object;
//添加通知
+(void)addNotify:(NSString *)notify block:(ASK_rac_notify)block;
+(void)addNotify:(NSString *)notify dealloc:(id)dealloc block:(ASK_rac_notify)block;

//信号结束
+(RACSignal *)RACSingalComplete;

#define ASK_RAC_DEALLOC                             [self rac_willDeallocSignal]
#define ASK_RAC_MAP(responseObject)                 flattenMap:^RACStream *(responseObject)
#define ASK_RAC_NEXT(responseObject)                subscribeNext:^(id responseObject)

#define ASK_WEAK_SELF           @weakify(self)
#define ASK_STRONG_SELF         @strongify(self)

@end
