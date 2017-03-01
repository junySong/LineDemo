//
//  LinesView.m
//  LineDemo
//
//  Created by 宋俊红 on 17/2/28.
//  Copyright © 2017年 Juny_song. All rights reserved.
//

#import "LinesView.h"

@interface LinesView() {
    UIColor *_defaultColor;//真正的颜色
    CGFloat _lineWidth;//线宽
}

@end

@implementation LinesView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initData];
        
    }
    return self;
}

- (void)initData{
    _defaultColor = [UIColor redColor];
    _lineWidth = 1;
}





- (void)drawRect:(CGRect)rect {
    
    if (self.pointsArray) {
        // 画连接线
        CGContextRef context = UIGraphicsGetCurrentContext();// 获取绘图上下文
        CGContextSetLineWidth(context, _lineWidth);//设置线宽
        CGContextSetShouldAntialias(context, YES);//设置反锯齿边缘
        UIColor *color = _lineColor?_lineColor:_defaultColor;
        CGContextSetStrokeColorWithColor(context, [color CGColor]);//设置线的颜色
        //定义多个点，画多点连线
        
        for (id item in self.pointsArray) {
            CGPoint currentPoint = CGPointFromString(item);
            if ((int)currentPoint.y<(int)self.frame.size.height && currentPoint.y>0) {
                if ([self.pointsArray indexOfObject:item]==0) {
                    CGContextMoveToPoint(context, currentPoint.x, currentPoint.y);
                    continue;
                }
                CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
                CGContextStrokePath(context); //开始画线
                if ([self.pointsArray indexOfObject:item]<self.pointsArray.count) {
                    CGContextMoveToPoint(context, currentPoint.x, currentPoint.y);
                }
                
            }
        }
    }
  
}


@end
