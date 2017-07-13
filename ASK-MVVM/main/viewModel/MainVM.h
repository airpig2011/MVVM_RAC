//
//  MainVM.h
//  ASK-MVVM
//
//  Created by dajie chen on 2017/7/13.
//  Copyright © 2017年 dajie chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainVM : NSObject

-(void)requestWeatherData;
-(void)requestAirData;
-(void)requestWeatherDataAndAirData;

@property(nonatomic,strong)id rac_resObj1;
@property(nonatomic,strong)id rac_resObj2;

@end
