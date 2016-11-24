//
//  LZLineChartSubView.h
//  DrawChatDemo
//
//  Created by lizhong.cui on 7/11/16.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZLineChartView.h"

static CGFloat topCuttingEdge = 80.0f;

static CGFloat buttomCuttingEdge = 30.0f;

static CGFloat leftCuttingEdge = 30.0f;

static CGFloat rightCuttingEdge = 70.0f;



#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface LZLineChartSubView : UIView

- (id)initWithFrame:(CGRect)frame YdataArray:(NSMutableArray *)YdataArray XdataArray:(NSMutableArray *)XdataArray convertYdataArray:(NSMutableArray *)convertYdataArray XSpacing:(CGFloat)XSpacing base:(CGFloat)base convertBase:(CGFloat)convertBase currentTitle:(NSString *)currentTitle currentValue:(NSString *)currentValue lineChartType:(LineChartType)lineChartType;

@end
