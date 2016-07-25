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

@interface AddressbookViewController ()<EMChatManagerDelegate>

//好友列表数据源
@property (strong, nonatomic) NSArray *buddyList;

@end

@implementation AddressbookViewController

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
    
    self.buddyList = [[EaseMob sharedInstance].chatManager buddyList];
    
//    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:<#^(NSArray *buddyList, EMError *error)completion#> onQueue:<#(dispatch_queue_t)#>]
    
#warning buddyList没有值的情况是1.第一次登录 2.自动登录没有完成
//    if (self.buddyList.count == 0) {//数据库没有好友记录
//        
//    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.buddyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"BubbyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 获取好友模型
    EMBuddy *buddy = self.buddyList[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:@"chatListCellHead"];
    cell.textLabel.text = buddy.username;
    
    return cell;
}

#pragma mark 实现下列方法就会出现cell的delete按钮
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //获取移除好友的名字
        EMBuddy *buddy = self.buddyList[indexPath.row];
        NSString *username = buddy.username;
        
        [[EaseMob sharedInstance].chatManager removeBuddy:username removeFromRemote:YES error:nil];
    }
}

#pragma mark EMChatManagerDelegate方法
//监听自动登录成功
- (void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    if (!error) {//自动登录成功后此时的buddyList才有值
        self.buddyList = [[EaseMob sharedInstance].chatManager buddyList];
        NSLog(@"%@",self.buddyList);
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
-(void)loadBuddyListFromServer{
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        //赋值给数据源
        self.buddyList = buddyList;
        //刷新
        [self.tableView reloadData];
    } onQueue:nil];
}

#pragma mark 好友数据列表被更新
- (void)didUpdateBuddyList:(NSArray *)buddyList changedBuddies:(NSArray *)changedBuddies isAdd:(BOOL)isAdd
{
    NSLog(@"好友数据列表被更新:%@",buddyList);
    //赋值给数据源
    self.buddyList = buddyList;
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
