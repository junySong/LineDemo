//
//  CandlesView.m
//  LineDemo
//
//  Created by 宋俊红 on 17/2/28.
//  Copyright © 2017年 Juny_song. All rights reserved.
//

#import "CandlesView.h"


@interface CandlesView(){
    
    
}




@end


@implementation CandlesView


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initData];
    }
    return self;
}

- (void)initData{
    
    self.lineWidth = KLineWidth;
    self.candleWidth = KCandleWidth;

    
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();// 获取绘图上下文
    for (NSArray *item in self.pointArray) {
        // 转换坐标
        CGPoint heightPoint,lowPoint,openPoint,closePoint;
        heightPoint = CGPointFromString([item objectAtIndex:0]);
        lowPoint = CGPointFromString([item objectAtIndex:1]);
        openPoint = CGPointFromString([item objectAtIndex:2]);
        closePoint = CGPointFromString([item objectAtIndex:3]);
        [self drawKWithContext:context height:heightPoint Low:lowPoint open:openPoint close:closePoint width:self.candleWidth];
    }

}

#pragma mark 画一根K线
-(void)drawKWithContext:(CGContextRef)context height:(CGPoint)heightPoint Low:(CGPoint)lowPoint open:(CGPoint)openPoint close:(CGPoint)closePoint width:(CGFloat)width{
    CGContextSetShouldAntialias(context, NO);
    // 首先判断是绿的还是红的，根据开盘价和收盘价的坐标来计算
    BOOL isKong = NO;
    UIColor *color = [UIColor colorWithHexString:@"#FF0000"  withAlpha:1];// 设置默认红色
    // 如果开盘价坐标在收盘价坐标上方 则为绿色 即空
    if (openPoint.y<closePoint.y) {
        isKong = YES;
        color = [UIColor colorWithHexString:@"#00FFFF"  withAlpha:1];// 设置为绿色
    }
    // 设置颜色
    
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    
    // 首先画一个垂直的线包含上影线和下影线
    // 定义两个点 画两点连线
    CGContextSetLineWidth(context, KLineWidth);
    const CGPoint points[] = {heightPoint,lowPoint};
    CGContextStrokeLineSegments(context, points, 2);  // 绘制线段（默认不绘制端点）
    // 再画中间的实体
   
    CGFloat halfWidth = 0;
    // 纠正实体的中心点为当前坐标
    openPoint = CGPointMake(openPoint.x-halfWidth, openPoint.y);
    closePoint = CGPointMake(closePoint.x-halfWidth, closePoint.y);
    // 开始画实体
    CGContextSetLineWidth(context, width); // 改变线的宽度
    const CGPoint point[] = {openPoint,closePoint};
    CGContextStrokeLineSegments(context, point, 2);  // 绘制线段（默认不绘制端点）
//    CGContextSetLineCap(context, kCGLineCapSquare) ;// 设置线段的端点形状，方形
    //开盘价格和收盘价格一样，画一条横线
    if ((openPoint.y-closePoint.y<=1) && (closePoint.y-openPoint.y<=1) ) {
        //这里设置开盘价和收盘价一样时候的颜色 CGContextSetStrokeColorWithColor(context, [color CGColor]);
        CGPoint pointLeft = CGPointMake(openPoint.x-KCandleWidth/2, openPoint.y);
        CGPoint pointRight = CGPointMake(openPoint.x+KCandleWidth/2, openPoint.y);
        CGContextSetLineWidth(context, 1); // 改变线的宽度
        const CGPoint point[] = {pointLeft,pointRight};
        CGContextStrokeLineSegments(context, point, 2);  // 绘制线段（默认不绘制端点）
    }
  
}


@end
