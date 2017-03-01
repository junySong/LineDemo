//
//  KLineView.h
//  LineDemo
//
//  Created by 宋俊红 on 17/2/28.
//  Copyright © 2017年 Juny_song. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CandlesView.h"
#import "LinesView.h"
#import "getData.h"
@interface KLineView : UIView

@property (nonatomic, strong) NSMutableArray *data;//
@property (nonatomic, strong) NSMutableArray *category;//

- (void)start;

- (void)updata;


@end
