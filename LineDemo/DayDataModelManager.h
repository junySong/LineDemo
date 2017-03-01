//
//  DayDataModelManager.h
//  LineDemo
//
//  Created by 宋俊红 on 17/2/28.
//  Copyright © 2017年 Juny_song. All rights reserved.
//

/**
 数据操作类
 我想实现的操做
 1、获取线条颜色
 2、获取阴线长度
 3、获取烛线长度

 @param nonatomic <#nonatomic description#>
 @param strong <#strong description#>
 @return <#return value description#>
 */
#import <Foundation/Foundation.h>
#import "DayDataModel.h"

@interface DayDataModelManager : NSObject

@property (nonatomic, strong) DayDataModel *dayDataModel;//


@end
