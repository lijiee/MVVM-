//
//  NewChange.h
//  ReactiveCocoaE
//
//  Created by 李杰 on 2016/10/28.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NewChange : NSObject

+ (void)showImagePickerFor:(UIViewController *)view phoneNum:(NSUInteger)pNum videoNum:(NSUInteger)vNum
                finishPick:(void (^)(NSArray *sourceArr,NSArray *assets))finPick;

+ (void) showImagePickerFor:(UIViewController *)view phoneNum:(NSUInteger)pNum videoNum:(NSUInteger)vNum sourceArr:(NSMutableArray *)sourceArr finishPick:(void (^)(NSArray *,NSArray *))finPick;
@end
