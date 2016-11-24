//
//  LZLineChartView.h
//  DrawChatDemo
//
//  Created by lizhong.cui on 7/11/16.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LineChartType)
{
    LineChartType_Step,
    
    LineChartType_Bust
    
};

@interface LZLineChartView : UIView

- (id)initWithFrame:(CGRect)frame YdataArray:(NSMutableArray<NSNumber *> *)YdataArray XdataArray:(NSMutableArray <NSString *> *)XdataArray currentTitle:(NSString *)currentTitle currentValue:(NSString *)currentValue lineChartType:(LineChartType)lineChartType;

@end
