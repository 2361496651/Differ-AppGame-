//
//  PhotoBrowserVC.m
//  PhotoBrowserDemo
//
//  Created by  zengchunjun on 2017/5/13.
//  Copyright © 2017年  zengchunjun. All rights reserved.
//

#import "PhotoBrowserVC.h"
#import "PhotoBrowserCell.h"


@interface PhotoBrowserVC ()<UICollectionViewDataSource,PhotoBrowserCellDelegate>

@property (nonatomic,strong)UICollectionView *collectionView;

@end

static NSString *photoBrowserCell = @"PhotoBrowserCell";

@implementation PhotoBrowserVC

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        
        PhotoBrowserCollectionViewFlowLayout *layout = [[PhotoBrowserCollectionViewFlowLayout alloc]init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
//        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    
    return _collectionView;
}

- (void)loadView
{
    [super loadView];
    
    CGRect frame = self.view.frame;
    frame.size.width += 20;
    self.view.frame = frame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
    
    [self.collectionView scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void)setupUI
{
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[PhotoBrowserCell class] forCellWithReuseIdentifier:photoBrowserCell];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.picURLs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoBrowserCell forIndexPath:indexPath];
    cell.picUrl = self.picURLs[indexPath.item];
    cell.delegate = self;
    return cell;
}




- (void)photoBrowserCellimageViewClick:(PhotoBrowserCell *)cell
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark;PhotoAnimationDismissDelegate
- (UIImageView *)imageViewForDismissView
{
    UIImageView *imageView = [[UIImageView alloc]init];
    PhotoBrowserCell *cell = [self.collectionView visibleCells].firstObject;
    imageView.frame = cell.imageView.frame;
    imageView.image = cell.imageView.image;
    
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.clipsToBounds = YES;
    
    return imageView;
}

- (NSIndexPath *)indexPathForDismissView
{
    return [self.collectionView indexPathsForVisibleItems].firstObject;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


@implementation PhotoBrowserCollectionViewFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    
    // 1.设置itemSize
    self.itemSize = self.collectionView.frame.size;
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 2.设置collectionView的属性
    self.collectionView.pagingEnabled = true;
    self.collectionView.showsHorizontalScrollIndicator = false;
    self.collectionView.showsVerticalScrollIndicator = false;
}

@end



