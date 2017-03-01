//
//  ViewController.m
//  LineDemo
//
//  Created by 宋俊红 on 17/2/24.
//  Copyright © 2017年 Juny_song. All rights reserved.
//

/**
 我想实现的功能
 1、1条简单的K线图，（阴阳烛）
 2、2条折线的分时图（折线图）
 3、放大和缩小的功能
 4、长按显示十字线和相应的标签Label
 */
#import "ViewController.h"
#import "KLineView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#111111" withAlpha:1];
    KLineView *lineView = [[KLineView alloc]init];
    lineView.frame = CGRectMake(0, 100, 300, 450);
    [self.view addSubview:lineView];
    [lineView start];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
