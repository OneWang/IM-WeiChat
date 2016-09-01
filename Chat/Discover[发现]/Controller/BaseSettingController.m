//
//  BaseSettingController.m
//  Chat
//
//  Created by LI on 16/8/25.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "BaseSettingController.h"
#import "SettingGroupItem.h"
#import "SettingItem.h"
#import "SettingCell.h"

@implementation BaseSettingController
- (instancetype)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
}


#pragma mark - 懒加载
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark UITableviewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SettingGroupItem * group = self.dataArray[section];
    return [group.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建 cell
    SettingCell * cell = [SettingCell cellWithTableView:tableView];
    
    //传递数据
    SettingGroupItem * group = self.dataArray[indexPath.section];
    SettingItem * item = group.items[indexPath.row];
    
    //设置选择状态,返回 cell
    cell.item = item;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    SettingGroupItem * group = self.dataArray[section];
    return group.footer;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    SettingGroupItem * group = self.dataArray[section];
    return group.header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SettingGroupItem * group = self.dataArray[indexPath.section];
    SettingItem * item = group.items[indexPath.row];
    UIViewController * vc = [[item.destVcClass alloc] init];
    if (item.option) {//block 有值,在 block 中执行一段特定操作
        item.option();
    }else {
        if ([vc isKindOfClass:[UIViewController class]]){
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
@end
