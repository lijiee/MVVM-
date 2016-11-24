

//
//  NewChange.m
//  ReactiveCocoaE
//
//  Created by 李杰 on 2016/10/28.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import "NewChange.h"
#import "TZImagePickerController.h"

@interface NewChange ()<TZImagePickerControllerDelegate>

@end
@implementation NewChange

+ (void)showImagePickerFor:(UIView *)view phoneNum:(NSUInteger)pNum videoNum:(NSUInteger)vNum finishPick:(void (^)(NSArray *,NSArray *))finPick{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:pNum columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets,BOOL isOk) {
        finPick(photos,assets);
        
    }];
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;

    [root presentViewController:imagePickerVc animated:YES completion:nil];

}

+ (void)showImagePickerFor:(UIView *)view phoneNum:(NSUInteger)pNum videoNum:(NSUInteger)vNum sourceArr:(NSMutableArray *)sourceArr finishPick:(void (^)(NSArray *,NSArray *))finPick{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:pNum columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.isSelectOriginalPhoto =YES;
    imagePickerVc.selectedAssets = sourceArr;
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets,BOOL isOk) {
        finPick(photos,assets);
        
    }];
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    [root presentViewController:imagePickerVc animated:YES completion:nil];
}
@end
