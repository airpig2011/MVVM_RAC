//
//  MainView.m
//  ASK-MVVM
//
//  Created by dajie chen on 2017/7/13.
//  Copyright © 2017年 dajie chen. All rights reserved.
//

#import "MainView.h"
#import "MainVM.h"
#import "ASK_Rac.h"

#define SCREEN_WIDTH        ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT       ([UIScreen mainScreen].bounds.size.height)

@interface MainView()

@property(nonatomic,strong)MainVM *mainVM;

@property(nonatomic,strong)UITextView *warnText;

@property(nonatomic,strong)UITextView *racResObjText1;
@property(nonatomic,strong)UITextView *racResObjText2;
@end


@implementation MainView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addUI];
        [self bindModelView];
    }
    return self;
}

-(void)addUI{
    
    self.warnText =[[UITextView alloc] initWithFrame:CGRectMake(50, 20, SCREEN_WIDTH-50*2, 120)];
    self.warnText.backgroundColor = [UIColor yellowColor];
    self.warnText.text = @"测试mvvm程序，请到以下网址申请apikey完成网络数据请求测试,https://wx.jcloud.com/";
    [self addSubview:self.warnText];
    
    self.racResObjText1 =[[UITextView alloc] initWithFrame:CGRectMake(50, 150, SCREEN_WIDTH-50*2, 120)];
    self.racResObjText1.backgroundColor = [UIColor grayColor];
    [self addSubview:self.racResObjText1];
    
    
    self.racResObjText2 =[[UITextView alloc] initWithFrame:CGRectMake(50, 300, SCREEN_WIDTH-50*2, 120)];
    self.racResObjText2.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.racResObjText2];
}

-(void)bindModelView{
    
    self.mainVM=[[MainVM alloc]init];
    [self.mainVM requestWeatherDataAndAirData];
    
    ASK_WEAK_SELF;
    [ASK_Rac observe:self.mainVM key:@"rac_resObj2" block:^(id rac_responseObject) {
        ASK_STRONG_SELF;
        if (rac_responseObject) {
            NSString *jsonString1 = [self DataTOjsonString:self.mainVM.rac_resObj1];
            NSString *jsonString2 = [self DataTOjsonString:self.mainVM.rac_resObj2];
            self.racResObjText1.text = jsonString1;
            self.racResObjText2.text = jsonString2;
        }
        
    }];
}

-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
@end
