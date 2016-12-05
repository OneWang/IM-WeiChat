//
//  FunctionView.m
//  Chat
//
//  Created by LI on 16/8/1.
//  Copyright © 2016年 LI. All rights reserved.
//  添加更多功能的 view


#define NUM_ROWS 2
#define NUM_COLS 4

#define CELL_SIZE 59

#import "FunctionView.h"
#import "UIViewExt.h"
#import "FunctionModel.h"

@interface ShareCell ()
///模型数据
@property (nonatomic,strong) FunctionModel *model;
///显示图片
@property (nonatomic,strong) UIImageView *imageView;
///显示文字
@property (nonatomic,strong) UILabel *label;

@end


@implementation ShareCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sharemore_other"]];
        
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sharemore_other_HL"]];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CELL_SIZE, CELL_SIZE)];
        self.imageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:self.imageView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0,CELL_SIZE + 6, CELL_SIZE,20)];
        self.label.textColor = [UIColor colorWithRed:93/255.0 green:93/255.0 blue:93/255.0 alpha:1];
        self.label.font = [UIFont systemFontOfSize:13];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.label];
        
        self.hidden = YES;
    }
    return self;
}

- (void)setContent:(FunctionModel *)model {
    if (_model == model) return;
    _model = model;
    
    if (_model) {
        self.imageView.image = [UIImage imageNamed:model.imageName];
        self.label.text = _model.text;
        self.tag = _model.tag;
        self.hidden = NO;
    }else {
        self.hidden = YES;
    }
}

@end

@interface FunctionView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIPageControl *pageControl;

@property (nonatomic,strong) NSMutableArray *itemModels;

@end

@implementation FunctionView{
    NSInteger pageNum;
    NSInteger totalSection;
}
static NSString *cellID = @"shareCell";
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDatas];
        [self setupViews];
        
        self.backgroundColor = [UIColor colorWithRed:242/255.0 green:244/255.0 blue:247/255.0 alpha:1];
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return self;
}

- (void)updateConstraints {
    NSDictionary *views = @{@"selfView":self};
    NSDictionary *metrics = @{@"height": @(217)};
    
    [NSLayoutConstraint activateConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[selfView]|" options:kNilOptions metrics:nil views:views]];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[selfView(==height)]" options:kNilOptions metrics:metrics views:views]];
    
    [super updateConstraints];
}


- (void)setupViews {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake (CELL_SIZE, CELL_SIZE);
    
    NSInteger gap = (kWeChatScreenWidth - CELL_SIZE * NUM_COLS) / (NUM_COLS + 1);
    layout.minimumLineSpacing = gap;
    layout.minimumInteritemSpacing = 0;
    NSInteger rgap = kWeChatScreenWidth - NUM_COLS * (gap + CELL_SIZE);
    layout.sectionInset = UIEdgeInsetsMake(14, gap, 25, rgap);
    
    self.collectionView = [[UICollectionView alloc]
                           initWithFrame:CGRectMake(0, 0, kWeChatScreenWidth, 192) collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    [self addSubview:self.collectionView];
    
    [self.collectionView registerClass:[ShareCell class] forCellWithReuseIdentifier:cellID];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 192, kWeChatScreenWidth, 20)];
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.hidesForSinglePage = YES;
    self.pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.defersCurrentPageDisplay = YES;
    [self addSubview:self.pageControl];
    
    self.pageControl.numberOfPages = totalSection;
    self.pageControl.currentPage = 0;
}


- (void)setupDatas {
    self.itemModels = [[NSMutableArray alloc] init];
    
    NSArray *items = @[@"sharemore_pic", @"照片", @(TAG_Photo),
                       @"sharemore_video", @"拍摄", @(TAG_Camera),
                       @"sharemore_sight", @"小视频", @(TAG_Sight),
                       @"sharemore_videovoip", @"视频聊天", @(TAG_VideoCall),
                       @"sharemore_wallet", @"红包", @(TAG_Redpackage),
                       @"sharemorePay", @"转账", @(TAG_MoneyTransfer),
                       @"sharemore_location", @"位置", @(TAG_Location),
                       @"sharemore_myfav", @"收藏", @(TAG_Favorites),
                       @"sharemore_friendcard", @"个人名片", @(TAG_Card),
                       @"sharemore_wallet", @"卡券", @(TAG_Wallet)];
    for(NSInteger i = 0, r = items.count; i < r; i += 3) {
        FunctionModel *model = [FunctionModel cellWithImageName:items[i]
                                                           text:items[i+1]
                                                            tag:[items[i+2] integerValue]];
        
        [self.itemModels addObject:model];
    }
    pageNum = NUM_COLS * NUM_ROWS;
    totalSection = ceil((CGFloat)self.itemModels.count / pageNum);
}


#pragma mark - PageControll

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger section = scrollView.contentOffset.x / kWeChatScreenWidth;
    self.pageControl.currentPage = section;
    [self.pageControl updateCurrentPageDisplay];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSInteger section = scrollView.contentOffset.x / kWeChatScreenWidth;
    self.pageControl.currentPage = section;
    [self.pageControl updateCurrentPageDisplay];
}

#pragma mark - CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return totalSection;
}

- (NSInteger)collectionView :(UICollectionView *)collectionView
      numberOfItemsInSection:(NSInteger)section {
    return pageNum;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    NSInteger row = indexPath.item % NUM_ROWS;
    NSInteger col = indexPath.item / NUM_ROWS;
    NSInteger position = NUM_COLS * row + col;
    NSInteger newItem = position + pageNum * indexPath.section;
    
    FunctionModel *model;
    if (newItem < self.itemModels.count)
        model = self.itemModels[newItem];
    [cell setContent:model];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    ShareCell *cell = (ShareCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self.delegate cellWithTagDidTapped:cell.tag];
    
}

@end





