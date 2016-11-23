//
//  DiscoverViewController.m
//  Chat
//
//  Created by LI on 16/8/24.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "DiscoverViewController.h"
#import "MJRefresh.h"
#import "SettingItem.h"
#import "SettingCell.h"
#import "SettingGroupItem.h"
#import "MomentsController.h"

@interface DiscoverViewController ()


@end

@implementation DiscoverViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupGroup0];
    
    [self setupGroup1];
    
    [self setupGroup2];
    
    [self setupGroup3];
}

- (void)setupGroup0{
    SettingItem * friend = [SettingItem itemWithIcon:@"ff_IconShowAlbum" title:@"朋友圈" destVcClass:[MomentsController class]];
    friend.type = SettingTypeArrow;
    SettingGroupItem * group = [[SettingGroupItem alloc] init];
    group.items = @[friend];
    [self.dataArray addObject:group];
}

- (void)setupGroup1{
    SettingItem * QRCode = [SettingItem itemWithIcon:@"ff_IconQRCode" title:@"扫一扫" destVcClass:[MomentsController class]];
    QRCode.type = SettingTypeArrow;
    SettingItem * shake = [SettingItem itemWithIcon:@"ff_IconShake" title:@"摇一摇" destVcClass:[MomentsController class]];
    shake.type = SettingTypeArrow;
    SettingGroupItem * group = [[SettingGroupItem alloc] init];
    group.items = @[QRCode,shake];
    [self.dataArray addObject:group];
}

- (void)setupGroup2{
    SettingItem * location = [SettingItem itemWithIcon:@"ff_IconLocationService" title:@"附近的人" destVcClass:[MomentsController class]];
    location.type = SettingTypeArrow;
    SettingGroupItem * group = [[SettingGroupItem alloc] init];
    group.items = @[location];
    [self.dataArray addObject:group];
}

- (void)setupGroup3{
    SettingItem * shop = [SettingItem itemWithIcon:@"CreditCard_ShoppingBag" title:@"购物" destVcClass:[MomentsController class]];
    shop.type = SettingTypeArrow;
    SettingItem *  game = [SettingItem itemWithIcon:@"MoreGame" title:@"游戏" destVcClass:[MomentsController class]];
    game.type = SettingTypeArrow;
    SettingGroupItem * group = [[SettingGroupItem alloc] init];
    group.items = @[shop,game];
    [self.dataArray addObject:group];
}

///设置分割线的偏移量将15像素的横线全部显示出来
- (void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
