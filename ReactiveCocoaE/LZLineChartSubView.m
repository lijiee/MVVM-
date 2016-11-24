//
//  LZLineChartSubView.m
//  DrawChatDemo
//
//  Created by lizhong.cui on 7/11/16.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "LZLineChartSubView.h"

@interface LZLineChartSubView()

@property(nonatomic,strong)NSMutableArray *convertYdataArray;

@property(nonatomic,strong)NSMutableArray *YdataArray;

@property(nonatomic,strong)NSMutableArray *XdataArray;

//x轴间距
@property(nonatomic,assign)CGFloat XSpacing;

/**
 基数
 */
@property(nonatomic,assign)CGFloat base;

/**
 转换后的计算
 */
@property(nonatomic,assign)CGFloat convertBase;

@property(nonatomic,copy)NSString *currentTitle;

@property(nonatomic,copy)NSString *currentValue;

@property(nonatomic,assign)LineChartType lineChartType;

@end

@implementation LZLineChartSubView

- (CGFloat)getTextWidth:(NSString *)text textSize:(CGFloat)textSize{
    
    NSDictionary *attributesDic = @{NSFontAttributeName:[UIFont systemFontOfSize:textSize],NSForegroundColorAttributeName:[UIColor blackColor]};
    
    NSAttributedString *yTextAttributedString = [[NSAttributedString alloc] initWithString:text attributes:attributesDic];
    
    CGSize constraint = CGSizeMake(MAXFLOAT,100);
    
    CGRect rect = [yTextAttributedString.string boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributesDic context:nil];
    
    return rect.size.width;
}

- (CGFloat)getTextHeight:(NSString *)text textSize:(CGFloat)textSize{
    
    NSDictionary *attributesDic = @{NSFontAttributeName:[UIFont systemFontOfSize:textSize],NSForegroundColorAttributeName:[UIColor blackColor]};
    
    NSAttributedString *yTextAttributedString = [[NSAttributedString alloc] initWithString:text attributes:attributesDic];
    
    CGSize constraint = CGSizeMake(100,MAXFLOAT);
    
    CGRect rect = [yTextAttributedString.string boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributesDic context:nil];
    
    return rect.size.height;
}



- (id)initWithFrame:(CGRect)frame YdataArray:(NSMutableArray *)YdataArray XdataArray:(NSMutableArray *)XdataArray convertYdataArray:(NSMutableArray *)convertYdataArray XSpacing:(CGFloat)XSpacing base:(CGFloat)base convertBase:(CGFloat)convertBase currentTitle:(NSString *)currentTitle currentValue:(NSString *)currentValue lineChartType:(LineChartType)lineChartType
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.lineChartType = lineChartType;
        
        self.currentTitle = currentTitle;
        
        self.currentValue = currentValue;
        
        self.YdataArray = YdataArray;
        
        self.XdataArray = XdataArray;
        
        self.convertYdataArray = convertYdataArray;
        
        
        self.XSpacing = XSpacing;
        
        self.base = base;
        
        self.convertBase = convertBase;
        
    }
    
    return self;
}

- (UIColor *)setColorValue:(int)value alpha:(CGFloat)alpha{
    
    float red=((float)((value & 0xFF0000) >> 16))/255.0;
    
    float green   = ((float)((value & 0xFF00) >> 8))/255.0;
    
    float blue   = ((float)(value & 0xFF))/255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


- (void)drawRect:(CGRect)rect{
    
    //绘图必须使用转换过的数据
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //currentTitle
    CGFloat currentTitleSize = 18.0f;
    
    UIFont *currentTitleFont = [UIFont systemFontOfSize:currentTitleSize];

    CGFloat currentTitleWidth = [self getTextWidth:self.currentTitle textSize:currentTitleSize];
    
    CGFloat currentTitleHeight = [self getTextHeight:self.currentTitle textSize:currentTitleSize];
    
    CGFloat currentTitleTop = 10;
    
    CGFloat currentTitleLeft = leftCuttingEdge;
    
    [self.currentTitle drawInRect:CGRectMake(currentTitleLeft,currentTitleTop,currentTitleWidth,currentTitleHeight) withAttributes:@{NSForegroundColorAttributeName:[self setColorValue:0xffffff alpha:1],NSFontAttributeName:currentTitleFont}];
    
    
    //currentValue
    CGFloat currentValueHeight = [self getTextHeight:self.currentValue textSize:currentTitleSize];
    
    CGFloat currentValueWidth = [self getTextWidth:self.currentValue textSize:currentTitleSize];
    
    CGFloat currentValueLeft = self.frame.size.width - rightCuttingEdge - currentValueWidth;
    
    [self.currentValue drawInRect:CGRectMake(currentValueLeft,currentTitleTop,currentValueWidth,currentValueHeight) withAttributes:@{NSForegroundColorAttributeName:[self setColorValue:0xffffff alpha:1],NSFontAttributeName:currentTitleFont}];
    
    CGFloat spacingBetweenCurrentValueAndSplitline = 7.0f;
    
    //分割线
    CGContextSetLineWidth(context, 0.5);
    
    [self setColor:context colorValue:0xfffffff alpha:0.3];

    CGContextMoveToPoint(context,leftCuttingEdge,currentTitleTop + currentTitleHeight + spacingBetweenCurrentValueAndSplitline);
    
    CGContextAddLineToPoint(context,self.frame.size.width - rightCuttingEdge,currentTitleTop +currentTitleHeight + spacingBetweenCurrentValueAndSplitline);
    
    CGContextStrokePath(context);
    
    
    
    
    //绘制基线（虚线）
    CGContextSetLineWidth(context, 0.5);
    
    [self setColor:context colorValue:0xfffffff alpha:0.6];
    
    CGContextMoveToPoint(context,leftCuttingEdge,self.frame.size.height - self.convertBase - buttomCuttingEdge);
    
    CGContextAddLineToPoint(context,self.frame.size.width-rightCuttingEdge,self.frame.size.height - self.convertBase- buttomCuttingEdge);
    
    //设置虚线排列的宽度间隔:下面的arr中的数字表示先绘制3个点再绘制1个点
    CGFloat arr[] = {3,1};
    //下面最后一个参数“2”代表排列的个数。
    CGContextSetLineDash(context, 0, arr, 2);
    
    CGContextDrawPath(context, kCGPathStroke);
    
    //绘制基线值
    NSString *baseValueText = [NSString stringWithFormat:@"%.f",self.base];
    
    CGFloat baseValueTextSize = 11.0f;
    
    CGFloat baseValueTextHeight = [self getTextHeight:baseValueText textSize:baseValueTextSize];
    
    CGFloat baseValueTextWidth = [self getTextWidth:baseValueText textSize:baseValueTextSize];
    
    CGFloat spacingBetweenBaseTextAndPoint = 10.0f;
    
    UIFont *baseTextFont = [UIFont systemFontOfSize:baseValueTextSize];
    
    CGFloat baseTextTop = self.frame.size.height - self.convertBase- buttomCuttingEdge - baseValueTextHeight/2.0;
    
    [baseValueText drawInRect:CGRectMake(self.frame.size.width-leftCuttingEdge - rightCuttingEdge/2.0 +spacingBetweenBaseTextAndPoint,baseTextTop,baseValueTextWidth,baseValueTextHeight) withAttributes:@{NSForegroundColorAttributeName:[self setColorValue:0xffffff alpha:1],NSFontAttributeName:baseTextFont}];
    
    //恢复实线
    CGContextSetLineDash (context,0,NULL,0);
    
    //绘制x轴的text
    for (int i = 0; i<self.XdataArray.count; i++) {
        
        NSString *text = self.XdataArray[i];
        
        CGFloat textSize = 12.0f;
        
        CGFloat textHeight = [self getTextHeight:text textSize:textSize];
        
        CGFloat textWidth = [self getTextWidth:text textSize:textSize];
        
        UIFont *textFont = [UIFont systemFontOfSize:textSize];
        
        CGFloat textTop = self.frame.size.height - buttomCuttingEdge + (buttomCuttingEdge-textHeight)/2.0;
        
        [text drawInRect:CGRectMake(leftCuttingEdge + self.XSpacing*i - textWidth/2.0,textTop,textWidth,textHeight) withAttributes:@{NSForegroundColorAttributeName:[self setColorValue:0xffffff alpha:1],NSFontAttributeName:textFont}];
    }
    
    

    
    //绘制y轴(暂不需要)
//    [self setColor:context colorValue:0x6DF2D8 alpha:1];
//    
//    CGContextSetLineWidth(context, 0.5);
//    
//    CGContextMoveToPoint(context,leftCuttingEdge,topCuttingEdge);
//    
//    CGContextAddLineToPoint(context,leftCuttingEdge,self.frame.size.height - buttomCuttingEdge);
//    
//    CGContextStrokePath(context);
    
    //绘制x轴
    CGContextSetLineWidth(context,0.5);
    
    [self setColor:context colorValue:0xffffff alpha:0.3];

    CGContextMoveToPoint(context,leftCuttingEdge,self.frame.size.height - buttomCuttingEdge);
    
    CGContextAddLineToPoint(context,self.frame.size.width - rightCuttingEdge,self.frame.size.height - buttomCuttingEdge);
    
    CGContextStrokePath(context);
    
    //绘制折线
    CGContextSetLineCap(context,kCGLineCapSquare);
    
    CGContextSetLineWidth(context,1.5);
    
    [self setColor:context colorValue:0xffffff alpha:0.3];
    
    CGContextBeginPath(context);
    
    BOOL isBegin = NO;
    
    for (int i = 0; i < self.convertYdataArray.count; i++) {
        
        if (self.lineChartType == LineChartType_Step) {
            
            if (i == 0) {
                
                CGContextMoveToPoint(context,leftCuttingEdge+self.XSpacing*i, self.frame.size.height - ((NSNumber *)self.convertYdataArray[i]).floatValue - buttomCuttingEdge);

                
            }else{
                
                
                CGContextAddLineToPoint(context,leftCuttingEdge+self.XSpacing*i, self.frame.size.height - ((NSNumber *)self.convertYdataArray[i]).floatValue - buttomCuttingEdge);

            }
            
            
            
        }else{
            
            if (!isBegin && ((NSNumber *)(self.convertYdataArray[i])).floatValue>0) {
                
                isBegin = YES;
                
                CGContextMoveToPoint(context,leftCuttingEdge+self.XSpacing*i, self.frame.size.height - ((NSNumber *)self.convertYdataArray[i]).floatValue - buttomCuttingEdge);
                
            }else if (isBegin && ((NSNumber *)(self.convertYdataArray[i])).floatValue>0){
                
                CGContextAddLineToPoint(context,leftCuttingEdge+self.XSpacing*i, self.frame.size.height - ((NSNumber *)self.convertYdataArray[i]).floatValue - buttomCuttingEdge);
                
            }
            
        }
        
        
        
    }
    
    CGContextStrokePath(context);
    
    //绘制圆点和文字
    for (int i = 0; i< self.convertYdataArray.count; i++) {
        
        if (self.lineChartType == LineChartType_Step) {
            
            CGFloat startX = leftCuttingEdge+self.XSpacing*i;
            //画圆
            //颜色
            [self setCircularColor:context colorValue:0xffffff alpha:0.6];
            //半径
            CGFloat radius = 5.0f;
            //绘制
            CGContextFillEllipseInRect(context, CGRectMake(startX-radius/2.0, self.frame.size.height - ((NSNumber *)self.convertYdataArray[i]).floatValue - buttomCuttingEdge - radius/2.0, radius, radius));
            
            //文字
            //颜色
            NSString *text = ((NSNumber *)self.YdataArray[i]).stringValue;
            
            CGFloat textSize = 11.0f;
            
            CGFloat textHeight = [self getTextHeight:text textSize:textSize];
            
            CGFloat textWidth = [self getTextWidth:text textSize:textSize];
            
            CGFloat spacingBetweenTextAndPoint = 10.0f;
            
            UIFont *textFont = [UIFont systemFontOfSize:textSize];
            
            CGFloat textTop = self.frame.size.height - (((NSNumber *)self.convertYdataArray[i]).floatValue + radius/2.0 + spacingBetweenTextAndPoint + textHeight/2.0 + buttomCuttingEdge);
            
            [text drawInRect:CGRectMake(startX - textWidth/2.0,textTop,textWidth,textHeight) withAttributes:@{NSForegroundColorAttributeName:[self setColorValue:0xffffff alpha:1],NSFontAttributeName:textFont}];
            
        }else{
            
            if (((NSNumber *)(self.convertYdataArray[i])).floatValue>0) {
                
                CGFloat startX = leftCuttingEdge+self.XSpacing*i;
                //画圆
                //颜色
                [self setCircularColor:context colorValue:0xffffff alpha:0.6];
                //半径
                CGFloat radius = 5.0f;
                //绘制
                CGContextFillEllipseInRect(context, CGRectMake(startX-radius/2.0, self.frame.size.height - ((NSNumber *)self.convertYdataArray[i]).floatValue - buttomCuttingEdge - radius/2.0, radius, radius));
         
                //文字
                //颜色
                NSString *text = ((NSNumber *)self.YdataArray[i]).stringValue;
                
                CGFloat textSize = 11.0f;
                
                CGFloat textHeight = [self getTextHeight:text textSize:textSize];
                
                CGFloat textWidth = [self getTextWidth:text textSize:textSize];
                
                CGFloat spacingBetweenTextAndPoint = 10.0f;
                
                UIFont *textFont = [UIFont systemFontOfSize:textSize];
                
                CGFloat textTop = self.frame.size.height - (((NSNumber *)self.convertYdataArray[i]).floatValue + radius/2.0 + spacingBetweenTextAndPoint + textHeight/2.0 + buttomCuttingEdge);
                
                [text drawInRect:CGRectMake(startX - textWidth/2.0,textTop,textWidth,textHeight) withAttributes:@{NSForegroundColorAttributeName:[self setColorValue:0xffffff alpha:1],NSFontAttributeName:textFont}];
                
            }
            
            
        }
        
        
    }

}

-(void)setColor:(CGContextRef)context colorValue:(int)value alpha:(CGFloat)alpha{
    float red=((float)((value & 0xFF0000) >> 16))/255.0;
    float green   = ((float)((value & 0xFF00) >> 8))/255.0;
    float blue   = ((float)(value & 0xFF))/255.0;
    CGContextSetRGBStrokeColor(context,red,green,blue,alpha);
}

-(void)setCircularColor:(CGContextRef)context colorValue:(int)value alpha:(CGFloat)alpha{
    float red=((float)((value & 0xFF0000) >> 16))/255.0;
    float green   = ((float)((value & 0xFF00) >> 8))/255.0;
    float blue   = ((float)(value & 0xFF))/255.0;
    CGContextSetRGBFillColor(context,red,green,blue,alpha);
}

@end
