//
//  DayDataModel.h
//  LineDemo
//
//  Created by 宋俊红 on 17/2/27.
//  Copyright © 2017年 Juny_song. All rights reserved.
//

/**
 单个的蜡烛的图的数据源，有两种画法
 1、阳烛空心的红烛，阴烛实心的绿烛
 2、阳烛实心的红烛，阴烛实心的绿烛
 ＊
 第一种，比较麻烦
 每个数据按日期排好之后，X轴坐标就已经确定，接下来要关注的是Y坐标（阴线和蜡烛的宽度提前约定好）
 首先，要确定线的颜色，收盘值－开盘值>0红线，收盘值－开盘值<0绿线，开盘值-收盘值=0白线
 第二，在最高值和次高值之间画一条线
 第三，在最低值和次低值之间画一条线
 第四，确定烛台的路径，（X - d/2,Y1）（X + d/2,Y1）（X + d/2,Y2）（X - d/2,Y2）四个点确定一个矩形，最后将这个矩形封口
 *
 第二种是比较好画，我们画的时候以第二种为例
 
 每个数据按日期排好之后，X轴坐标就已经确定，接下来要关注的是Y坐标（阴线和蜡烛的宽度提前约定好）
 首先，要确定线的颜色，收盘值－开盘值>0红线，收盘值－开盘值<0绿线，开盘值-收盘值=0白线
 其次，最高值和最低值之间画一条细线（阴线宽）
 第三，在开盘值和收盘值之间画一条宽线（烛线宽）
 
 */
#import <Foundation/Foundation.h>

@interface DayDataModel : NSObject

@property (nonatomic, strong) NSNumber *maxNumber;//最高值
@property (nonatomic, strong) NSNumber *minNumber;//最低值
@property (nonatomic, strong) NSNumber *startNumber;//开盘值
@property (nonatomic, strong) NSNumber *endNumber;//收盘值

@property (nonatomic, copy) NSString *dateString;//日期


/**
 获得差值，开盘值-收盘值

 @param dayDataModel 数据源的一个数据
 @return 开盘值-收盘值
 */
- (CGFloat)periodFromStartNumberToEndNumberWithDayDataModel:(DayDataModel*)dayDataModel;


/**
 获得主色调，开盘-收盘
 大于0，显示红色
 小于0，显示绿色
 等于0，显示白色

 @param dayDataModel 数据源的一个数据
 @return 颜色
 */
- (UIColor*)showColorWithDayDataModel:(DayDataModel*)dayDataModel;

/**获得差值，最大值-最小值，画阴线图的时候用的着
 

 @param dayDataModel 数据源的一个数据
 @return 最大值-最小值
 */
- (CGFloat)periodFromMaxNumberToMinNumberWithDayDataModel:(DayDataModel *)dayDataModel;


@end
