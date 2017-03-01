//
//  KLineView.m
//  LineDemo
//
//  Created by 宋俊红 on 17/2/28.
//  Copyright © 2017年 Juny_song. All rights reserved.
//
#define LefePad 50 //框框距离左边距
#define RightPad 20 //框框距离右边距
#import "KLineView.h"


@interface  KLineView()<UIScrollViewDelegate>{
    NSThread *_thread;
    UIView *_mainBoxView;
    BOOL _isUpdata;//是否是更新
    
    UIScrollView *_mainScrollView;
    getData *getdata;
    NSMutableArray *_candlesArray;
    NSMutableArray *_linesArray;
}

@property (nonatomic, strong) NSDate *endDate;//
@property (nonatomic,retain) NSString *req_freq;
@property (nonatomic,retain) NSString *req_type;
@property (nonatomic,retain) NSString *req_url;
@property (nonatomic,retain) NSString *req_security_id;
@property (nonatomic, strong) NSMutableArray *pointArray;//

@end

@implementation KLineView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}



- (void)initData{
    _isUpdata = NO;
    self.req_type = @"d"; // 日K线类型
    self.endDate = [NSDate date];
    self.req_freq = @"601888.SS"; // 股票代码 规则是：沪股代码末尾加.ss，深股代码末尾加.sz。如浦发银行的代号是：600000.SS
    self.req_url = @"http://ichart.yahoo.com/table.csv?s=%@&g=%@";
    _candlesArray = [NSMutableArray array];
    _linesArray = [NSMutableArray array];
}



//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}

#pragma mark------------------Public----------------------
- (void)start{
    //先画好外框线
    [self drawBox];
    _thread = [[NSThread alloc] initWithTarget:self selector:@selector(drawLine) object:nil];
    [_thread start];
}

-(void)updata{
    
}

#pragma mark------------------Private----------------------

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self drawLabels];
}
- (void)drawBox{
    //画个K线图的框框
    if (_mainBoxView == nil) {
        _mainBoxView = [[UIView alloc] initWithFrame:CGRectMake(LefePad, 20, self.frame.size.width-LefePad-RightPad, self.frame.size.height- 20)];
        _mainBoxView.backgroundColor = [UIColor colorWithHexString:@"#222222" withAlpha:1];
        _mainBoxView.layer.borderColor = [UIColor colorWithHexString:@"#444444" withAlpha:1].CGColor;
        _mainBoxView.layer.borderWidth = 0.5;
        _mainBoxView.userInteractionEnabled = YES;
        [self addSubview:_mainBoxView];
        
        
        //分割线
        CGFloat cellheigt = _mainBoxView.frame.size.height/PartationCount;
        for (int i = 1; i<PartationCount ; i++) {
            CGFloat y = cellheigt*i;
            UIView *view= [[UIView alloc]initWithFrame:CGRectMake(0.5, y, _mainBoxView.frame.size.width-1, 1)];
            view.backgroundColor = [UIColor colorWithHexString:@"#333333" withAlpha:1];
            [_mainBoxView addSubview:view];
        }
        
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _mainBoxView.frame.size.width, _mainBoxView.frame.size.height)];
        _mainScrollView.showsVerticalScrollIndicator = YES;
        _mainScrollView.delegate = self;
        _mainScrollView.scrollsToTop = YES;
        [_mainBoxView addSubview:_mainScrollView];
//        _mainScrollView.contentSize = _mainScrollView.frame.size;
    }
    
    
}


- (void)drawLine{
    //获取数据源

    dispatch_async(dispatch_get_main_queue(), ^{
        
        // 获取网络数据，来源于雅虎财经接口
        getdata = [[getData alloc] init];
        getdata.kCount = 0 ;
        getdata.req_type = self.req_type;
        getdata = [getdata initWithUrl:[self changeUrl]];
        self.data = getdata.data;
//        getdata.kCount = self.data.count;
        self.category = getdata.category;
        NSLog(@"当前：%i",self.data.count);
//        [self drawLabels];
        // 开始画K线图
        [self drawBoxWithKline];
        

    });
    NSLog(@"处理得dddd");
    // 清除旧的k线
//    if (lineOldArray.count>0 && _isUpdata) {
//        for (LinesView *line in lineOldArray) {
//            [line removeFromSuperview];
//        }
//    }
//    lineOldArray = lineArray.copy;
    [_thread cancel];
}

- (void)drawLabels{
    CGFloat maxY = _mainBoxView.frame.origin.y+_mainBoxView.frame.size.height;
    CGFloat minY = _mainBoxView.frame.origin.y;
    CGFloat startX = 10;
    UIColor *color = [UIColor colorWithHexString:@"0x565a64"];
   
    //画最小值的标签
    NSString *minLabelString = [NSString stringWithFormat:@"%.3f",getdata.minValue];
    CGPoint pointMin = CGPointMake(startX, maxY-5);
    [minLabelString drawAtPoint:pointMin withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11],NSForegroundColorAttributeName :color} ];
//    UILabel *label = [self getlabel];
//    label.frame = CGRectMake(pointMin.x, pointMin.y, 50, 13);
//    [self addSubview:label];
//    label.text = minLabelString;
//    
//    label.backgroundColor = [UIColor yellowColor];
//    [label autoresizesSubviews];
//    
    //画最大值的标签
    NSString *maxLabelString = [NSString stringWithFormat:@"%.3f",getdata.maxValue];
    CGPoint pointMax = CGPointMake(startX, minY-5);
    [ maxLabelString drawAtPoint:pointMax withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11],NSForegroundColorAttributeName :color} ];
    
    CGFloat divideCount = (getdata.maxValue - getdata.minValue)/PartationCount;
    CGFloat dividePosition = (maxY-maxY)/PartationCount;
    
    //从上往下开始画标签
    for (int i = 1; i<PartationCount; i++) {
        NSString *LabelString = [NSString stringWithFormat:@"%.3f",(getdata.maxValue - i*divideCount)];
        CGPoint point = CGPointMake(startX, minY + i*dividePosition-5);
        [LabelString drawAtPoint:point withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11],NSForegroundColorAttributeName :color} ];
    
    }
    
    
    
}
- (void)drawBoxWithKline{
    // 开始画连K线
    // x轴从0 到 框框的宽度 mainboxView.frame.size.width 变化  y轴为每个间隔的连线，如，今天的点连接明天的点
    NSArray *ktempArray = [self changeKPointWithData:getdata.data]; // 换算成实际每天收盘价坐标数组
    CGSize size = CGSizeMake((KPad+KCandleWidth)*ktempArray.count, _mainBoxView.frame.size.height);
    _mainScrollView.contentSize = size;
    CandlesView *kline = [[CandlesView alloc] initWithFrame:CGRectMake(0, 0, size.width, _mainBoxView.frame.size.height)];
    kline.pointArray = ktempArray;
    [_mainScrollView addSubview:kline];
    [_candlesArray addObject:kline];
}
#pragma mark 把股市数据换算成实际的点坐标数组
-(NSArray*)changeKPointWithData:(NSArray*)data{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
   self.pointArray = [[NSMutableArray alloc] init];
    CGFloat PointStartX = KCandleWidth+KPad; // 起始点坐标
    for (NSArray *item in data) {
        CGFloat heightvalue = [[item objectAtIndex:1] floatValue];// 得到最高价
        CGFloat lowvalue = [[item objectAtIndex:2] floatValue];// 得到最低价
        CGFloat openvalue = [[item objectAtIndex:0] floatValue];// 得到开盘价
        CGFloat closevalue = [[item objectAtIndex:3] floatValue];// 得到收盘价
        CGFloat yHeight = getdata.maxValue - getdata.minValue ; // y的价格高度
        CGFloat yViewHeight = _mainBoxView.frame.size.height ;// y的实际像素高度
        // 换算成实际的坐标
        CGFloat heightPointY = yViewHeight * (1 - (heightvalue - getdata.minValue) / yHeight);
        CGPoint heightPoint =  CGPointMake(PointStartX, heightPointY); // 最高价换算为实际坐标值
        CGFloat lowPointY = yViewHeight * (1 - (lowvalue - getdata.minValue) / yHeight);;
        CGPoint lowPoint =  CGPointMake(PointStartX, lowPointY); // 最低价换算为实际坐标值
        CGFloat openPointY = yViewHeight * (1 - (openvalue - getdata.minValue) / yHeight);;
        CGPoint openPoint =  CGPointMake(PointStartX, openPointY); // 开盘价换算为实际坐标值
        CGFloat closePointY = yViewHeight * (1 - (closevalue - getdata.minValue) / yHeight);;
        CGPoint closePoint =  CGPointMake(PointStartX, closePointY); // 收盘价换算为实际坐标值
        // 实际坐标组装为数组
        NSArray *currentArray = [[NSArray alloc] initWithObjects:
                                 NSStringFromCGPoint(heightPoint),
                                 NSStringFromCGPoint(lowPoint),
                                 NSStringFromCGPoint(openPoint),
                                 NSStringFromCGPoint(closePoint),
                                 [self.category objectAtIndex:[data indexOfObject:item]], // 保存日期时间
                                 [item objectAtIndex:3], // 收盘价
                                 [item objectAtIndex:5], // MA5
                                 [item objectAtIndex:6], // MA10
                                 [item objectAtIndex:7], // MA20
                                 nil];
        [tempArray addObject:currentArray]; // 把坐标添加进新数组
        //[pointArray addObject:[NSNumber numberWithFloat:PointStartX]];
        currentArray = Nil;
        PointStartX += KCandleWidth + KPad; // 生成下一个点的x轴
        
        // 在成交量视图左右下方显示开始和结束日期
//        if ([data indexOfObject:item]==0) {
//            startDateLab.text = [self.category objectAtIndex:[data indexOfObject:item]];
//        }
//        if ([data indexOfObject:item]==data.count-1) {
//            endDateLab.text = [self.category objectAtIndex:[data indexOfObject:item]];
//        }
    }
    _pointArray = tempArray;
    return tempArray;
}

//#pragma mark 把股市数据换算成成交量的实际坐标数组
//-(NSArray*)changeVolumePointWithData:(NSArray*)data{
//    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
//    CGFloat PointStartX = KCandleWidth+KPad; // 起始点坐标
//    for (NSArray *item in data) {
//        CGFloat volumevalue = [[item objectAtIndex:4] floatValue];// 得到没份成交量
//        CGFloat yHeight = getdata.volMaxValue - getdata.volMinValue ; // y的价格高度
//        CGFloat yViewHeight = bottomBoxView.frame.size.height ;// y的实际像素高度
//        // 换算成实际的坐标
//        CGFloat volumePointY = yViewHeight * (1 - (volumevalue - getdata.volMinValue) / yHeight);
//        CGPoint volumePoint =  CGPointMake(PointStartX, volumePointY); // 成交量换算为实际坐标值
//        CGPoint volumePointStart = CGPointMake(PointStartX, yViewHeight);
//        // 把开盘价收盘价放进去好计算实体的颜色
//        CGFloat openvalue = [[item objectAtIndex:0] floatValue];// 得到开盘价
//        CGFloat closevalue = [[item objectAtIndex:3] floatValue];// 得到收盘价
//        CGPoint openPoint =  CGPointMake(PointStartX, closevalue); // 开盘价换算为实际坐标值
//        CGPoint closePoint =  CGPointMake(PointStartX, openvalue); // 收盘价换算为实际坐标值
//        
//        
//        // 实际坐标组装为数组
//        NSArray *currentArray = [[NSArray alloc] initWithObjects:
//                                 NSStringFromCGPoint(volumePointStart),
//                                 NSStringFromCGPoint(volumePoint),
//                                 NSStringFromCGPoint(openPoint),
//                                 NSStringFromCGPoint(closePoint),
//                                 nil];
//        [tempArray addObject:currentArray]; // 把坐标添加进新数组
//        currentArray = Nil;
//        PointStartX += KCandleWidth+KPad; // 生成下一个点的x轴
//        
//    }
//    NSLog(@"处理完成");
//    
//    return tempArray;
//}

//#pragma mark 判断并在十字线上显示提示信息
//-(void)isKPointWithPoint:(CGPoint)point{
//    CGFloat itemPointX = 0;
//    for (NSArray *item in pointArray) {
//        CGPoint itemPoint = CGPointFromString([item objectAtIndex:3]);  // 收盘价的坐标
//        itemPointX = itemPoint.x;
//        int itemX = (int)itemPointX;
//        int pointX = (int)point.x;
//        if (itemX==pointX || point.x-itemX<=self.kLineWidth/2) {
//            movelineone.frame = CGRectMake(itemPointX,movelineone.frame.origin.y, movelineone.frame.size.width, movelineone.frame.size.height);
//            movelinetwo.frame = CGRectMake(movelinetwo.frame.origin.x,itemPoint.y, movelinetwo.frame.size.width, movelinetwo.frame.size.height);
//            // 垂直提示日期控件
//            movelineoneLable.text = [item objectAtIndex:4]; // 日期
//            CGFloat oneLableY = bottomBoxView.frame.size.height+bottomBoxView.frame.origin.y;
//            CGFloat oneLableX = 0;
//            if (itemPointX<movelineoneLable.frame.size.width/2) {
//                oneLableX = movelineoneLable.frame.size.width/2 - itemPointX;
//            }
//            if ((mainboxView.frame.size.width - itemPointX)<movelineoneLable.frame.size.width/2) {
//                oneLableX = -(movelineoneLable.frame.size.width/2 - (mainboxView.frame.size.width - itemPointX));
//            }
//            movelineoneLable.frame = CGRectMake(itemPointX - movelineoneLable.frame.size.width/2 + oneLableX, oneLableY,
//                                                movelineoneLable.frame.size.width, movelineoneLable.frame.size.height);
//            // 横向提示价格控件
//            movelinetwoLable.text = [[NSString alloc] initWithFormat:@"%@",[item objectAtIndex:5]]; // 收盘价
//            CGFloat twoLableX = movelinetwoLable.frame.origin.x;
//            // 如果滑动到了左半边则提示向右跳转
//            if ((mainboxView.frame.size.width - itemPointX) > mainboxView.frame.size.width/2) {
//                twoLableX = mainboxView.frame.size.width - movelinetwoLable.frame.size.width;
//            }else{
//                twoLableX = 0;
//            }
//            movelinetwoLable.frame = CGRectMake(twoLableX,itemPoint.y - movelinetwoLable.frame.size.height/2 ,
//                                                movelinetwoLable.frame.size.width, movelinetwoLable.frame.size.height);
//            
//            // 均线值显示
//            MA5.text = [[NSString alloc] initWithFormat:@"MA5:%.2f",[[item objectAtIndex:5] floatValue]];
//            [MA5 sizeToFit];
//            MA10.text = [[NSString alloc] initWithFormat:@"MA10:%.2f",[[item objectAtIndex:6] floatValue]];
//            [MA10 sizeToFit];
//            MA10.frame = CGRectMake(MA5.frame.origin.x+MA5.frame.size.width+10, MA10.frame.origin.y, MA10.frame.size.width, MA10.frame.size.height);
//            MA20.text = [[NSString alloc] initWithFormat:@"MA20:%.2f",[[item objectAtIndex:7] floatValue]];
//            [MA20 sizeToFit];
//            MA20.frame = CGRectMake(MA10.frame.origin.x+MA10.frame.size.width+10, MA20.frame.origin.y, MA20.frame.size.width, MA20.frame.size.height);
//            break;
//        }
//    }
//    
//}
#pragma mark 返回组装好的网址
-(NSString*)changeUrl{
    NSString *url = [[NSString alloc] initWithFormat:self.req_url,self.req_freq,self.req_type];
    return url;
}

- (UILabel*)getlabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:11];
    return label;
}
- (void)dealloc{
    _thread = nil;
}
@end
