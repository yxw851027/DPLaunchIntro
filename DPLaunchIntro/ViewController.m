//
//  ViewController.m
//  DPLaunchIntro
//
//  Created by yxw on 15/8/15.
//  Copyright (c) 2015年 yxw. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.textColor = [UIColor  blackColor];
    label.font = [UIFont systemFontOfSize:24];
    label.text = @"这里是主页面!\nHere is main viewcontroller";
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
