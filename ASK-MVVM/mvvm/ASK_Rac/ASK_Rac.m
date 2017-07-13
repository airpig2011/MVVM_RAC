//
//  ASK_Rac.m
//  ASK-MVVM
//
//  Created by dajie chen on 2017/7/13.
//  Copyright © 2017年 dajie chen. All rights reserved.
//

#import "ASK_Rac.h"

@implementation ASK_Rac


+(void)observe:(id)obj key:(NSString *)property block:(ASK_rac_change)block{
    
    [[obj rac_valuesForKeyPath:property observer:nil] subscribeNext:^(id x) {
        if(block){
            block(x);
        }
    }];
    
}
+(void)addNotify:(NSString *)notify block:(ASK_rac_notify)block{
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:notify object:nil]
      
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(NSNotification *notification) {
         
         if(block){
             block(notification);
         }
     }];
}
+(void)addNotify:(NSString *)notify dealloc:(id)dealloc block:(ASK_rac_notify)block{
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:notify object:nil]
      
      takeUntil:[dealloc rac_willDeallocSignal]]
     subscribeNext:^(NSNotification *notification) {
         if(block){
             block(notification);
         }
     }];
}
+(void)postNotify:(id)notify object:(id)object{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notify object:object];
}

+(RACSignal *)RACSingalComplete{
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber){
        
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
        }];
    }];
}

@end
