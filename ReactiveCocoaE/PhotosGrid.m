//
//  PhotosGrid.m
//  PhotosGrid
//
//  Created by WorkHarder on 4/13/16.
//  Copyright © 2016 Kidney. All rights reserved.
//

#import "PhotosGrid.h"
//#import "BlocksKit+UIKit.h"
//#import "ImageDealer.h"
//#import "Chameleon.h"
//#import "BL_ImagePicker.h"
#import "NewChange.h"
#import "ReactiveCocoa.h"
#import <BlocksKit+UIKit.h>

#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import "TZImagePickerController.h"
#import "PhotosGridCell.h"

#define DEL_WIDTH (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 36 : 26)
@interface GridCell ()

@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;

@end

#define DEL_WIDTH (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 36 : 26)

@implementation GridCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _btnDelete.layer.cornerRadius = _btnDelete.bounds.size.width/2;
    
//    [_btnDelete setBackgroundColor:FlatRed];
    [_btnDelete setBackgroundImage:[UIImage imageNamed:@"delete-circular.png"] forState:UIControlStateNormal];
    
    _deleteBtnWidth.constant = DEL_WIDTH;
    _topMargin.constant = _deleteBtnWidth.constant/2;
    _rightMargin.constant = _deleteBtnWidth.constant/2;
}

- (void)bindData:(id)data atIndex:(NSIndexPath *)index{
    
}

@end


#pragma mark - PhotosGrid

typedef void (^PhotosGridAddCellClick)(void);

@interface PhotosGrid ()<UICollectionViewDataSource, UICollectionViewDelegate>


@property (nonatomic, copy) PhotosGridAddCellClick block;

@end

static NSString *CellIdentifier = @"";

@implementation PhotosGrid{
    NSUInteger itemNumLimit;
}
- (NSMutableArray *)gridSource1{
    if (!_gridSource1) {
        self.gridSource1 = [NSMutableArray arrayWithCapacity:0];
    }return _gridSource1;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self setBackgroundColor:[UIColor whiteColor]];
    [self configWithData:@[]];
}

- (void)configWithData:(NSArray *)data{
    [self configWithData:data withColNum:3 numLimit:9 verticalPadding:0 cellName:@"PhotosGridCell" withBlock:nil];
}

- (void)configWithData:(NSArray *)data withColNum:(NSUInteger)colItems numLimit:(NSUInteger)numLimit verticalPadding:(CGFloat)vPadding cellName:(NSString *)cellID withBlock:(void (^)(void))block{
    self.gridSource = [data mutableCopy];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    layout.sectionInset = UIEdgeInsetsMake(12, 12+DEL_WIDTH/2, 12, 12);
    layout.minimumInteritemSpacing = 12;
    layout.minimumLineSpacing = 12;
    
    CGFloat itemWidth = ([UIScreen mainScreen].bounds.size.width - layout.sectionInset.left - layout.sectionInset.right - (colItems-1)*layout.minimumInteritemSpacing)/colItems;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth+vPadding);
    
    itemNumLimit = numLimit;
    if (!cellID) {
        cellID = @"PhotosGridCell";
    }
    CellIdentifier = cellID;
    _block = nil;
    [self registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"PhotosGridAddCell"];
    
    self.delegate = self;
    self.dataSource = self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return MIN(_gridSource.count + 1, itemNumLimit) ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_gridSource.count < itemNumLimit && indexPath.row == _gridSource.count) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotosGridAddCell" forIndexPath:indexPath];
        
        if (![cell.contentView viewWithTag:3]) {
            UIButton *btn = [[UIButton alloc] init];
            UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
            
            [btn setFrame:(CGRect){0, DEL_WIDTH/2, layout.itemSize.width-DEL_WIDTH/2, layout.itemSize.height-DEL_WIDTH/2}];
            [cell.contentView addSubview:btn];
            
            [btn setImage:[UIImage imageNamed:@"image-add-icon"] forState:UIControlStateNormal];
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btn.layer.borderWidth = 2;
            [btn setContentEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
            [btn setUserInteractionEnabled:NO];
        }
        
        return cell;
    } else {
        PhotosGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        id model = _gridSource[indexPath.row];
        
        [cell bindData: self.gridSource atIndex:indexPath];
        [cell.btnPhoto bk_whenTapped:^{
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_gridSource1 selectedPhotos:_gridSource index:indexPath.row];
            imagePickerVc.maxImagesCount = 9;
            imagePickerVc.allowPickingOriginalPhoto =YES;
            imagePickerVc.isSelectOriginalPhoto = YES;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                _gridSource = [NSMutableArray arrayWithArray:photos];
                _gridSource1 = [NSMutableArray arrayWithArray:assets];
                [self reloadData];
               float _margin = 4;
               float _itemWH = (self.frame.size.width - 2 * _margin - 4) / 3 - _margin;
                self.contentSize = CGSizeMake(0, ((_gridSource.count + 2) / 3 ) * (_margin + _itemWH));
            }];
            UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
            
            [root presentViewController:imagePickerVc animated:YES completion:nil];

        }];
        
//        // 删除事件
//        [cell.btnDelete bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
//        [cell.btnDelete bk_addEventHandler:^(id sender) {
//            NSIndexPath *path = [NSIndexPath indexPathForItem:[_gridSource indexOfObject:model] inSection:0];
//            self.gridSource = [[[self.gridSource.rac_sequence filter:^BOOL(id value) {
//                return [self.gridSource indexOfObject:value] != path.row;
//            }] array] mutableCopy];
//            if (self.gridSource.count == itemNumLimit-1) {
//                [collectionView reloadData];
//            } else {
//                [collectionView deleteItemsAtIndexPaths:@[path]];
//            }
//        } forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_gridSource.count < itemNumLimit && indexPath.row == _gridSource.count) {
        if ( _block ) {
            _block();
        } else {
            // 添加打开ImagePicker的代码
            
            [NewChange showImagePickerFor:nil phoneNum:1 videoNum:0 sourceArr:self.gridSource1 finishPick:^(NSArray *sourceArr,NSArray *date) {
                // 这里 的 gridSource 是 ALAsset 类型的数组
                self.gridSource = [sourceArr mutableCopy];
                self.gridSource1 = [date mutableCopy];
                
                [self reloadData];

            }];
        }
    }else{
     
    }
}

- (void)setGridSource:(NSMutableArray *)gridSource{
    _gridSource = gridSource;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    if (_gridSource.count == 0) {
        self.contentHeight = 0;
    } else {
        self.contentHeight = MIN(([self collectionView:self numberOfItemsInSection:0]/3+1),3)*(layout.itemSize.height+layout.minimumLineSpacing)-layout.minimumLineSpacing + 2*layout.sectionInset.top;
    }
}

@end


