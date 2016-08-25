//
//  AddressbookViewController.m
//  Chat
//
//  Created by LI on 16/5/3.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "AddressbookViewController.h"
#import "EaseMob.h"
#import "ChatViewController.h"
#import "ContacterTools.h"
#import "ContactCell.h"
#import "ContactModel.h"
#import "ApplyViewController.h"
#import "ContactResultController.h"

@interface AddressbookViewController ()<EMChatManagerDelegate,UISearchBarDelegate>

///搜索框
@property (nonatomic, strong) UISearchController *searchController;

//好友列表数据源
@property (strong, nonatomic) NSMutableArray *buddyList;

// 功能列表
@property (nonatomic, strong) NSMutableArray *functionGroup;
/** 格式化的好友列表数据 */
@property (nonatomic, strong) NSMutableArray *data;
/** 拼音首字母列表 */
@property (nonatomic, strong) NSMutableArray *section;

@end

@implementation AddressbookViewController
- (NSMutableArray *)data
{
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}
- (NSMutableArray *)section
{
    if (!_section) {
        _section = [NSMutableArray array];
    }
    return _section;
}
- (NSMutableArray *)functionGroup
{
    if (!_functionGroup) {
        _functionGroup = [NSMutableArray array];
    }
    return _functionGroup;
}
- (NSMutableArray *)buddyList
{
    if (!_buddyList) {
        _buddyList = [NSMutableArray array];
    }
    return _buddyList;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.rowHeight = 44;
    
    [self reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加聊天管理器的代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    
#warning 好友列表buddyList需要在自动登录成功后才有值
    // 获取好友列表的数据
    /* 注意
     1.好友列表buddyList需要在自动登录之后才有值
     2.buddyList数据是从本地数据库获取的
     3.要想从服务器获取好友数据调用这个方法- (void *)asyncFetchBuddyListWithCompletion:(void (^)(NSArray *buddyList, EMError *error))completion
     onQueue:(dispatch_queue_t)queue;
     4.如果当前有添加好友请求,环信的SDK内部会往数据库的buddy表添加好友记录
     5.如果程序删除或者用户第一次登录,buddyList表是没有记录的;
       解决方案:
       1.要从服务器获取好友列表记录
       2.用户第一次登录后,自动从服务器获取还有列表
     */
    
//    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:<#^(NSArray *buddyList, EMError *error)completion#> onQueue:<#(dispatch_queue_t)#>]
    
#warning buddyList没有值的情况是1.第一次登录 2.自动登录没有完成
//    if (self.buddyList.count == 0) {//数据库没有好友记录
//        
//    }
}

- (UISearchController *)createSearchController{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:[ContactResultController new]];
    self.searchController.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
    
    UISearchBar *bar = self.searchController.searchBar;
    bar.barStyle = UIBarStyleDefault;
    bar.translucent = YES;
    bar.barTintColor = [UIColor lightGrayColor];
    bar.tintColor = [UIColor colorWithRed:0 green:(190 / 255.0) blue:(12 / 255.0) alpha:1];
    UIImageView *view = [[[bar.subviews objectAtIndex:0] subviews] firstObject];
    view.layer.borderColor = [UIColor blueColor].CGColor;
    view.layer.borderWidth = 1;
    
    bar.layer.borderColor = [UIColor redColor].CGColor;
    
    bar.showsBookmarkButton = YES;
    [bar setImage:[UIImage imageNamed:@"VoiceSearchStartBtn"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
    bar.delegate = self;
    CGRect rect = bar.frame;
    rect.size.height = 44;
    bar.frame = rect;
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    return self.searchController;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
   
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)reloadData{
    [self.buddyList removeAllObjects];
    [self getData];
}

- (void)getData{
    NSArray *array = [[EaseMob sharedInstance].chatManager buddyList];
    for (EMBuddy *buddy in array) {
        [self.buddyList addObject:buddy.username];
    }
    self.functionGroup = [ContacterTools getFriensListItemsGroup];
    self.data = [ContacterTools getFriendListDataBy:self.buddyList];
    self.section = [ContacterTools getFriendListSectionBy:_data];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    if (section == 0) {
        return self.functionGroup.count;
    }
    NSArray *array = [self.data objectAtIndex:section - 1];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        ContactCell *cell = [ContactCell cellWithTableView:tableView];
        ContactModel *group = self.functionGroup[indexPath.row];
        cell.group = group;
        return cell;
    }else {
        ContactCell *cell = [ContactCell cellWithTableView:tableView];
        NSArray *array = [self.data objectAtIndex:indexPath.section - 1];
        cell.buddy = [array objectAtIndex:indexPath.row];
        return cell;
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self.navigationController pushViewController:[ApplyViewController shareController] animated:YES];
                break;
            case 1:
                break;
        }
    }else {
        NSArray *array = [self.data objectAtIndex:indexPath.section - 1];
        NSString *buddy = [array objectAtIndex:indexPath.row];
        ChatViewController *chatVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"chatpage"];
        chatVc.friendName = buddy;
        [self.navigationController pushViewController:chatVc animated:YES];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.section;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)return 44;
    return 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    return [self createSearchController].searchBar;
    
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    label.backgroundColor = [UIColor clearColor];
    [label setText:[self.section objectAtIndex:section]];
    [contentView addSubview:label];
    return contentView;
}
#pragma mark 实现下列方法就会出现cell的delete按钮
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //获取移除好友的名字
        NSArray *array = [self.data objectAtIndex:indexPath.section - 1];
        
        NSString *username = array[indexPath.row];
        [[EaseMob sharedInstance].chatManager removeBuddy:username removeFromRemote:YES error:nil];
        NSLog(@"被删除用户:%@",username);
        [self reloadData];
    }
}

#pragma mark EMChatManagerDelegate方法
//监听自动登录成功
- (void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    if (!error) {//自动登录成功后此时的buddyList才有值
        [self reloadData];
        //刷新表格
        [self.tableView reloadData];
    }
}

//监听到好友同意后就刷新好友列表
- (void)didAcceptedByBuddy:(NSString *)username
{
    //把新的好友添加到表格中
    NSArray *buddyList = [[EaseMob sharedInstance].chatManager buddyList];
    NSLog(@"好友添加同意:%@",buddyList);
#warning buddyList的个数,仍然是没有添加好友之前的个数,重新从服务器获取
    [self loadBuddyListFromServer];
}

//从服务器获取好友列表
- (void)loadBuddyListFromServer{
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        //赋值给数据源
        [self reloadData];
        //刷新
        [self.tableView reloadData];
    } onQueue:nil];
}

#pragma mark 好友数据列表被更新
- (void)didUpdateBuddyList:(NSArray *)buddyList changedBuddies:(NSArray *)changedBuddies isAdd:(BOOL)isAdd
{
    NSLog(@"好友数据列表被更新:%@",buddyList);
    //赋值给数据源
    [self reloadData];
    //刷新
    [self.tableView reloadData];
}
//被好友删除了
- (void)didRemovedByBuddy:(NSString *)username{
    //刷新表格
    [self loadBuddyListFromServer];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //往聊天控制器传递一个buddy的值
    id destVC = segue.destinationViewController;
    if ([destVC isKindOfClass:[ChatViewController class]]) {
        //获取点中的行
        NSInteger selectedRow = [self.tableView indexPathForSelectedRow].row;
        
        ChatViewController * chatVC = destVC;
        chatVC.buddy = self.buddyList[selectedRow];
    }
}

@end
