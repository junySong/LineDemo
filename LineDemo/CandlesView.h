//
//  CandlesView.h
//  LineDemo
//
//  Created by 宋俊红 on 17/2/28.
//  Copyright © 2017年 Juny_song. All rights reserved.
//阴阳烛图

#import <UIKit/UIKit.h>

@interface CandlesView : UIView

@property (nonatomic, strong)  NSMutableArray *pointArray;//数据源

@property (nonatomic, assign) CGFloat lineWidth;//折线的宽

@property (nonatomic, assign) CGFloat candleWidth;//烛线的宽

@end
