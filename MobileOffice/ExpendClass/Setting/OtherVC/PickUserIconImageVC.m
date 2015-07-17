//
//  PickUserIconImageVC.m
//  MobileOffice
//
//  Created by MacAir2 on 15/7/17.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "PickUserIconImageVC.h"

@interface PickUserIconImageVC ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *images;

@end

@implementation PickUserIconImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"请选取图片";
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    self.images = @[[UIImage imageNamed:@"h0.jpg"],
                    [UIImage imageNamed:@"h1.jpg"],
                    [UIImage imageNamed:@"h2.jpg"],
                    [UIImage imageNamed:@"h3.jpg"],
                    [UIImage imageNamed:@"h4.jpg"],
                    [UIImage imageNamed:@"h5.jpg"],
                    [UIImage imageNamed:@"h6.jpg"],
                    [UIImage imageNamed:@"h7.jpg"],
                    [UIImage imageNamed:@"h8.jpg"],
                    [UIImage imageNamed:@"h9.jpg"],
                    [UIImage imageNamed:@"h10.jpg"],
                    [UIImage imageNamed:@"h11.jpg"],
                    [UIImage imageNamed:@"h12.jpg"],
                    [UIImage imageNamed:@"h13.jpg"],
                    [UIImage imageNamed:@"h14.jpg"],
                    [UIImage imageNamed:@"h15.jpg"],
                    [UIImage imageNamed:@"h16.jpg"],
                    [UIImage imageNamed:@"h17.jpg"],
                    [UIImage imageNamed:@"h18.jpg"]
                    ];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

#pragma mark - collectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UIView* selectedBGView = [[UIView alloc] initWithFrame:cell.bounds];
    selectedBGView.backgroundColor = [UIColor redColor];
    cell.selectedBackgroundView = selectedBGView;
    
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, cell.frame.size.width-10, cell.frame.size.height-10)];
    [cell.contentView addSubview:iv];
    
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height-0.5, cell.frame.size.width, 0.5)];
    bottomLine.backgroundColor = RGBCOLOR(210, 210, 210);
    [cell.contentView addSubview:bottomLine];
    
    UIView *rightLine = [[UIView alloc]initWithFrame:CGRectMake(cell.frame.size.width-0.5, 0, 0.5, cell.frame.size.height)];
    rightLine.backgroundColor = RGBCOLOR(210, 210, 210);
    [cell.contentView addSubview:rightLine];
    
    [iv setImage:_images[indexPath.row]];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(pickUserIconImageVCSelectedOneImage:)]) {
        [self.delegate pickUserIconImageVCSelectedOneImage:_images[indexPath.row]];
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.frame.size.width/3.0, self.view.frame.size.width/3.0);
}


@end
