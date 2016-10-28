//
//  PhotosGridCell.m
//  PhotosGrid
//
//  Created by WorkHarder on 4/13/16.
//  Copyright © 2016 Kidney. All rights reserved.
//

#import "PhotosGridCell.h"
#import "PhotosGrid.h"
//#import "PhotoBrowser.h"
//#import "BlocksKit+UIKit.h"

#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/AssetsLibrary.h>



#define DEL_WIDTH (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 36 : 26)
@interface PhotosGridCell ()



@end

@implementation PhotosGridCell

- (void)bindData:(id)data atIndex:(NSIndexPath *)path{
    
    
        UIImage *set = data[path.row];
        
        [self.btnPhoto setImage: set forState:UIControlStateNormal];
    self.btnPhoto.userInteractionEnabled = YES;
    
    
}

#pragma mark - 修改 uiimage 的 Size
- (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize {
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    // 目标位图的 上下文
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointZero;
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    // 以上 为 创建一个目标位图
    
    // 将目标画到 指定
    [sourceImage drawInRect:thumbnailRect];
    // 创建一个 当前位图的 图形
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束 上下文
    UIGraphicsEndImageContext();
    return newImage ;
}

@end
