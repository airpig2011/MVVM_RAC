//
//  MainVC.m
//  ASK-MVVM
//
//  Created by dajie chen on 2017/7/13.
//  Copyright © 2017年 dajie chen. All rights reserved.
//

#import "MainVC.h"

#import "MainView.h"

#define SCREEN_WIDTH        ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT       ([UIScreen mainScreen].bounds.size.height)


@interface MainVC ()

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MainView *mainView = [[MainView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [self.view addSubview:mainView];
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
