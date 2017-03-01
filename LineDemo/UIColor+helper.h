//
//  UIColor+helper.h
//  LineDemo
//
//  Created by 宋俊红 on 17/2/27.
//  Copyright © 2017年 Juny_song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (helper)

+ (UIColor *) colorWithHexString: (NSString *)color;
+ (UIColor *) colorWithHexString: (NSString *)color withAlpha:(CGFloat)alpha;


@end
