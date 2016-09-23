//
//  TwoViewController.h
//  ReactiveCocoaE
//
//  Created by 李杰 on 16/9/8.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveCocoa.h"
@interface TwoViewController : UIViewController
@property(nonatomic,strong)RACSubject *delegateSignal;

@end
