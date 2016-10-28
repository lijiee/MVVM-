//
//  PhotosGrid.h
//  PhotosGrid
//
//  Created by WorkHarder on 4/13/16.
//  Copyright © 2016 Kidney. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridCell : UICollectionViewCell

- (void)bindData:(id)data atIndex:(NSIndexPath *)index;

@end

@interface PhotosGrid : UICollectionView

@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, retain) NSMutableArray *gridSource;
@property (nonatomic, retain) NSMutableArray *gridSource1;


- (void)configWithData:(NSArray *)data;

@end