//
//  MySelectPicCollectionView.m
//  ReactiveCocoaE
//
//  Created by 李杰 on 2017/1/4.
//  Copyright © 2017年 李杰. All rights reserved.
//

#import "MySelectPicCollectionView.h"
#import "PhotosGridCell.h"

@interface MySelectPicCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)NSMutableArray *gridSource1;
@end
static NSString *CellIdentifier = @"";
@implementation MySelectPicCollectionView
{
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
    self.gridSource1 = [data mutableCopy];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.scrollsToTop = NO;
    self.delegate = self;
    self.dataSource = self;
    itemNumLimit = numLimit;
    layout.sectionInset = UIEdgeInsetsMake(0, 2, 0, 2);

    layout.itemSize = CGSizeMake( [UIScreen mainScreen].bounds.size.width/3  - 12, 200);


    if (!cellID) {
        cellID = @"PhotosGridCell";
    }
    CellIdentifier = cellID;
    [self registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"PhotosGridAddCell"];
    [self reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _gridSource1.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

        PhotosGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        [cell bindData: self.gridSource1 atIndex:indexPath];
        
        
        return cell;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
