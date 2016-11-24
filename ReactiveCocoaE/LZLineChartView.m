//
//  LZLineChartView.m
//  DrawChatDemo
//
//  Created by lizhong.cui on 7/11/16.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "LZLineChartView.h"
#import "LZLineChartSubView.h"

@interface LZLineChartView()

@property(nonatomic,strong)NSMutableArray *convertYdataArray;

@property(nonatomic,strong)NSMutableArray *YdataArray;

@property(nonatomic,strong)NSMutableArray *XdataArray;

/**
 y轴最大值
 */
@property(nonatomic,assign)CGFloat maxY;

/**
 基线值
 */
@property(nonatomic,assign)NSInteger basicValue;


/**
 转换之后的基线值
 */
@property(nonatomic,assign)CGFloat convertBasicValue;

/**
 x轴间距
 */
@property(nonatomic,assign)CGFloat XSpacing;

/**
 转换后的x轴间距
 */
@property(nonatomic,assign)CGFloat convertXSpacing;


/**
 转换后的计算
 */
@property(nonatomic,assign)CGFloat convertBase;


/**
 渐变的顶坐标
 */
@property(nonatomic,assign)CGFloat gradientTop;


@property(nonatomic,assign)LineChartType lineChartType;

/**
 touch的时候显示的线
 */
@property(nonatomic,strong)UIView *displayView;


/**
 touch的时候显示的文字
 */
@property(nonatomic,strong)UILabel *dispalyLabel;

@end

@implementation LZLineChartView

#pragma mark-按照画布的比例计算y轴的最大值
- (void)calculationsMax{
    
    NSArray *array = [self.YdataArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        if ([obj1 floatValue] > [obj2 floatValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if ([obj1 floatValue] < [obj2 floatValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
        
        
    }];
    
    NSNumber *max = array.firstObject;
    
    self.basicValue = max.floatValue/2;
    
    self.maxY = max.floatValue;
    
    self.gradientTop = max.floatValue;
    
}

#pragma mark-将数据都按照画布的比例转换
- (void)convertScale{
    
    //只需要转换y轴的数据
    //计算比例(计算比例前需要计算y轴的最大值)
    CGFloat scale = (self.frame.size.height - buttomCuttingEdge - topCuttingEdge)*1.0 / self.maxY;
    
    //转换Y轴的数据
    for (NSNumber *YHeight in self.YdataArray) {
        
        CGFloat afterConvertYHeight = YHeight.floatValue*scale;
        
        [self.convertYdataArray addObject:[NSNumber numberWithFloat:afterConvertYHeight]];
    }
    
    self.convertBase = self.basicValue*scale;
    
    self.gradientTop = self.gradientTop*scale;
    
    self.convertBasicValue = self.basicValue * scale;
}

- (id)initWithFrame:(CGRect)frame YdataArray:(NSMutableArray<NSNumber *> *)YdataArray XdataArray:(NSMutableArray <NSString *> *)XdataArray currentTitle:(NSString *)currentTitle currentValue:(NSString *)currentValue lineChartType:(LineChartType)lineChartType{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.layer.cornerRadius = 5.0f;
        
        self.clipsToBounds = YES;
        
        self.lineChartType = lineChartType;
        
        self.YdataArray = YdataArray;
        
        self.XdataArray = XdataArray;
        
        self.convertYdataArray = [[NSMutableArray alloc]init];
        
        
        if (self.XdataArray.count == 1) {
            
            self.XSpacing = self.frame.size.width - rightCuttingEdge - leftCuttingEdge;
            
        }else{
            
            self.XSpacing = (self.frame.size.width - rightCuttingEdge - leftCuttingEdge)*1.0/(self.XdataArray.count-1);

        }
        
        //计算最大值
        [self calculationsMax];
        
        //转换数据
        [self convertScale];
        
        
        //加背景渐变色
        CAGradientLayer* backgroundGradientLayer = [CAGradientLayer layer];
        
        backgroundGradientLayer.frame = self.bounds;
        
        backgroundGradientLayer.startPoint = CGPointMake(0,0);
        
        backgroundGradientLayer.endPoint = CGPointMake(1.0,0);
        
        if (self.lineChartType == LineChartType_Step) {
            
            backgroundGradientLayer.colors = @[
                                               
                                               
                                               (__bridge id)[self setColorValue:0xffa201 alpha:1].CGColor,
                                               
                                               (__bridge id)[self setColorValue:0xec7165 alpha:1].CGColor
                                               
                                               ];
            
        }else{
            
            backgroundGradientLayer.colors = @[
                                               
                                               
                                               
                                               (__bridge id)[self setColorValue:0x75ba2b alpha:1].CGColor,
                                               
                                               (__bridge id)[self setColorValue:0xa7c225 alpha:1].CGColor
                                               
                                               ];
            
            
        }
        
        
        
        [self.layer insertSublayer:backgroundGradientLayer atIndex:0];
        
        
        //折线下面的渐变
        if (self.maxY>0 && self.XdataArray.count>1) {
            
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            
            gradientLayer.frame =CGRectMake(0,self.frame.size.height - self.gradientTop - buttomCuttingEdge,self.frame.size.width,self.gradientTop);
            
            [self.layer addSublayer:gradientLayer];
            
            gradientLayer.startPoint = CGPointMake(0,0);
            
            gradientLayer.endPoint = CGPointMake(0,1);
            
            gradientLayer.colors = @[
                                     
                                     (__bridge id)[self setColorValue:0xffffff alpha:0.3].CGColor,
                                     
                                     (__bridge id)[self setColorValue:0xffffff alpha:0.1].CGColor
                                     
                                     ];
            
            UIBezierPath * path=[[UIBezierPath alloc] init];
            
            //上面路径(这个路径的左边是相对于gradientLayer的坐标)
            for (int i = 0; i < self.convertYdataArray.count; i++) {
                
                CGFloat startX = leftCuttingEdge+self.XSpacing*i;
                
                CGFloat startY = gradientLayer.frame.size.height - ((NSNumber *)self.convertYdataArray[i]).floatValue;
                
                if (i == 0) {
                    
                    [path moveToPoint:CGPointMake(startX,startY)];
                    
                }else{
                    
                    if (self.lineChartType == LineChartType_Step) {
                        
                        [path addLineToPoint:CGPointMake(startX, startY)];
                        
                    }else{
                        
                        if (((NSNumber *)self.convertYdataArray[i]).floatValue == 0) {
                            
                            //如果是维度这个点不需要添加
                            
                            
                        }else{
                            
                            [path addLineToPoint:CGPointMake(startX, startY)];
                            
                        }
                        
                    }
                    
                    
                }
            }
            
            //下面路径
            for (NSInteger i = self.convertYdataArray.count-1; i >= 0; i--) {
                
                CGFloat startX = leftCuttingEdge + self.XSpacing*i;
                
                if (self.lineChartType == LineChartType_Step) {
                    
                    [path addLineToPoint:CGPointMake(startX, gradientLayer.frame.size.height)];
                    
                }else{
                    
                    if (((NSNumber *)(self.convertYdataArray[i])).floatValue == 0) {
                        
                    }else{
                        
                        [path addLineToPoint:CGPointMake(startX, gradientLayer.frame.size.height)];
                        
                    }
                    
                }
                
                
                
            }
            
            [path closePath];
            
            //渐变路径
            CAShapeLayer *arc = [CAShapeLayer layer];
            arc.path =path.CGPath;
            arc.fillColor = [UIColor yellowColor].CGColor;
            arc.strokeColor = [UIColor yellowColor].CGColor;
            arc.lineWidth = 1;
            gradientLayer.mask=arc;
            
        }
        
        
        //绘制折线及相关文字
        LZLineChartSubView *subView = [[LZLineChartSubView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) YdataArray:self.YdataArray XdataArray:self.XdataArray convertYdataArray:self.convertYdataArray XSpacing:self.XSpacing base:self.basicValue convertBase:self.convertBase currentTitle:currentTitle currentValue:currentValue lineChartType:lineChartType];
        
        subView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:subView];
    }
    return self;
}

-(UIColor *)setColorValue:(int)value alpha:(CGFloat)alpha{
    
    float red=((float)((value & 0xFF0000) >> 16))/255.0;
    
    float green   = ((float)((value & 0xFF00) >> 8))/255.0;
    
    float blue   = ((float)(value & 0xFF))/255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}



//#define TOUCH

#ifdef TOUCH
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    
    CGPoint beginPoint = [touch locationInView:self];
    
    NSInteger index = 0;
    
    //确保在视图内
    if (beginPoint.y>0 && beginPoint.y<self.frame.size.width) {
        
        for (int i = 0; i<self.YdataArray.count; i++) {
            
            CGFloat startX = self.XSpacing*i+leftCuttingEdge;
            
            if (beginPoint.x > (startX - self.XSpacing/2.0) && beginPoint.x < (startX + self.XSpacing/2.0)) {
                
                index = i;
                
            }
            
        }
        
        self.displayView = [[UIView alloc]initWithFrame:CGRectMake(beginPoint.x,0 ,0.5,self.frame.size.height)];
        
        self.displayView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.displayView];
        
        self.dispalyLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.displayView.frame.origin.x+5, topCuttingEdge, 50, 12)];
        self.dispalyLabel.backgroundColor = [UIColor clearColor];
        self.dispalyLabel.font = [UIFont systemFontOfSize:10];
        self.dispalyLabel.textColor = [UIColor whiteColor];
        self.dispalyLabel.text = ((NSNumber *)(self.YdataArray[index])).stringValue;
        [self addSubview:self.dispalyLabel];
        
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.displayView removeFromSuperview];
    [self.dispalyLabel removeFromSuperview];
}


#endif


@end
