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
#import "SearchResultViewController.h"

@interface AddressbookViewController ()<EMChatManagerDelegate,UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating>

///搜索框
@property (nonatomic, strong) UISearchBar *searchBar;

///好友列表数据源
@property (strong, nonatomic) NSMutableArray *buddyList;

// 功能列表
@property (nonatomic, strong) NSMutableArray *functionGroup;
/** 格式化的好友列表数据 */
@property (nonatomic, strong) NSMutableArray *data;
/** 拼音首字母列表 */
@property (nonatomic, strong) NSMutableArray *section;

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) UIButton *cover;
@property (weak, nonatomic) SearchResultViewController *searchResultVC;

@end

@implementation AddressbookViewController

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
    
//    self.navigationController.navigationBar.hidden = YES;
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped] ;
//    self.tableView.backgroundColor = [UIColor redColor];
    
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

//- (UISearchController *)createSearchController{
//    self.searchController = [[UISearchController alloc] initWithSearchResultsController:[ContactResultController new]];
//    self.searchController.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
//    self.searchController.delegate = self;
//    self.searchController.searchResultsUpdater = self;
//    
//    UISearchBar *bar = self.searchController.searchBar;
//    bar.barStyle = UIBarStyleDefault;
//    bar.translucent = YES;
//    bar.barTintColor = [UIColor lightGrayColor];
//    bar.tintColor = [UIColor colorWithRed:0 green:(190 / 255.0) blue:(12 / 255.0) alpha:1];
//    UIImageView *view = [[[bar.subviews objectAtIndex:0] subviews] firstObject];
//    view.layer.borderColor = [UIColor whiteColor].CGColor;
//    view.layer.borderWidth = 1;
//    
//    bar.showsBookmarkButton = YES;
//    [bar setImage:[UIImage imageNamed:@"VoiceSearchStartBtn"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
//    bar.delegate = self;
//    CGRect rect = bar.frame;
//    rect.size.height = 44;
//    bar.frame = rect;
//    self.tableView.sectionIndexColor = [UIColor lightGrayColor];
//    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
//    return self.searchController;
//}

- (UISearchBar *)createSearchBar{
    UISearchBar *bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    bar.barStyle = UIBarStyleDefault;
    bar.translucent = YES;
    bar.barTintColor = [UIColor lightGrayColor];
    bar.tintColor = [UIColor colorWithRed:0 green:(190 / 255.0) blue:(12 / 255.0) alpha:1];
    UIImageView *view = [[[bar.subviews objectAtIndex:0] subviews] firstObject];
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.layer.borderWidth = 1;

    bar.showsBookmarkButton = YES;
    [bar setImage:[UIImage imageNamed:@"VoiceSearchStartBtn"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
    bar.delegate = self;
    bar.placeholder = @"请输入搜索信息";
    CGRect rect = bar.frame;
    rect.size.height = 44;
    bar.frame = rect;
    self.searchBar = bar;
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    return self.searchBar;

}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    // 1.隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // 2.修改搜索框的背景图片
    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield_hl"]];
    
    // 3.显示搜索框右边的取消按钮
    [searchBar setShowsCancelButton:YES animated:YES];
    
    // 4.显示遮盖
    [UIView animateWithDuration:0.5 animations:^{
        self.cover.alpha = 0.5;
    }];
}

/**
 *  键盘退下:搜索框结束编辑文字
 */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // 1.显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // 2.修改搜索框的背景图片
    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield"]];
    
    // 3.隐藏搜索框右边的取消按钮
    [searchBar setShowsCancelButton:NO animated:YES];
    
    // 4.隐藏遮盖
    [UIView animateWithDuration:0.5 animations:^{
        self.cover.alpha = 0.0;
    }];
    
    // 5.移除搜索结果
    self.searchResultVC.view.hidden = YES;
    searchBar.text = nil;
}

/**
 *  搜索框里面的文字变化的时候调用
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length) {
        self.searchResultVC.view.hidden = NO;
        self.searchResultVC.searchText = searchText;
    } else {
        self.searchResultVC.view.hidden = YES;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    
    searchBar.showsCancelButton = NO;
    
    searchBar.text = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    
    searchBar.showsCancelButton = NO;

    [self.tableView reloadData];
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
    if (section == 0) {
        return [self createSearchBar];
    }
    
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

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSLog(@"updateSearchResultsForSearchController");
//    NSString *searchString = [self.searchController.searchBar text];
//    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
//    if (self.searchList!= nil) {
//        [self.searchList removeAllObjects];
//    }
//    //过滤数据
//    self.searchList= [NSMutableArray arrayWithArray:[_dataList filteredArrayUsingPredicate:preicate]];
//    //刷新表格
//    [self.tableView reloadData];
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

#pragma mark - setter and getter
- (UIButton *)cover{
    if (!_cover) {
        UIButton *cover = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cover = cover;
        [self.view addSubview:_cover];
        [self.view bringSubviewToFront:_cover];
        _cover.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        [_cover addTarget:self action:@selector(coverClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cover mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
            make.height.mas_equalTo([UIScreen mainScreen].bounds.size.height - 64);
            make.left.equalTo(self.view);
            make.top.equalTo(self.searchBar.mas_bottom);
        }];
    }
    return _cover;
}

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

- (SearchResultViewController *)searchResultVC{
    if (!_searchResultVC) {
        SearchResultViewController *searchResult = [[SearchResultViewController alloc] init];
        self.searchResultVC = searchResult;
        [self addChildViewController:_searchResultVC];
        [self.view addSubview:_searchResultVC.view];
        [_searchResultVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
            make.height.mas_equalTo([UIScreen mainScreen].bounds.size.height - 64);
            make.left.equalTo(self.view);
            make.top.equalTo(self.searchBar.mas_bottom);
        }];
    }
    return _searchResultVC;
}

#pragma mark - event response
- (void)coverClick:(UIButton *)sender{
    [self.searchBar resignFirstResponder];
}

@end
