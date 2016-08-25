//
//  ConversationViewController.m
//  Chat
//
//  Created by LI on 16/5/3.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "ConversationViewController.h"
#import "EaseMob.h"
#import "MBProgressHUD+MJ.h"
#import "ChatViewController.h"
#import "ConversationCell.h"

@interface ConversationViewController ()<EMChatManagerDelegate>

/** 历史会话记录 */
@property (strong, nonatomic) NSArray *conversations;

@end

@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //获取历史会话记录
    [self loadConversations];
    
    self.tableView.rowHeight = 70;
    
}
//
- (void)loadConversations{
    //获取历史会话记录
    //1.从内存中获取历史会话记录
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    
    //2.如果内存中没有会话记录,从数据库中获取conversations
    if (conversations.count == 0) {
        conversations = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    }
    self.conversations = conversations;
    
    //显示总的未读数
    [self showTabbarBadge];
}

#pragma mark EMChatManagerDelegate
//监听网络状态
- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    if (connectionState == eEMConnectionDisconnected) {
        [MBProgressHUD showError:@"网络未连接"];
    }else{
        [MBProgressHUD showSuccess:@"网络连接成功"];
    }
}

- (void)willAutoReconnect
{
    [MBProgressHUD showSuccess:@"将自动重新连接"];
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error
{
    if (!error) {
        [MBProgressHUD showSuccess:@"自动重连接成功"];
    }else{
        [MBProgressHUD showError:@"自动重连接失败"];
        NSLog(@"%@",error);
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *concersations = @"conversationCell";
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:concersations];
    
    //获取会话模型
//    EMConversation *conversation = self.conversations[indexPath.row];
    //显示用户名
//    cell.textLabel.text = [NSString stringWithFormat:@"%@ ===未读的消息数: %ld",conversation.chatter,conversation.unreadMessagesCount ];
//    
//    //显示最新的一条记录
//    //获取消息体
//    id body = conversation.latestMessage.messageBodies[0];
//    if ([body isKindOfClass:[EMTextMessageBody class]]) {
//        EMTextMessageBody *textBody = body;
//        cell.detailTextLabel.text = textBody.text;
//    }else if ([body isKindOfClass:[EMVoiceMessageBody class]]){
//        EMVoiceMessageBody *voiceBody = body;
//        cell.detailTextLabel.text = voiceBody.displayName;
//    }else if([body isKindOfClass:[EMImageMessageBody class]]){
////        EMImageMessageBody *imageBody = body;
//        cell.detailTextLabel.text = @"未知的消息类型";
//    }
    
    ConversationCell *cell = [ConversationCell cellWithTableView:tableView];
    //获取会话模型
    EMConversation *conversation = self.conversations[indexPath.row];
    cell.conversaion = conversation;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //进入聊天控制器
    //从storyboard加载聊天控制器
    ChatViewController *chatVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"chatpage"];
    
    //会话
    EMConversation *conversation = self.conversations[indexPath.row];
    EMBuddy *buddy = [EMBuddy buddyWithUsername:conversation.chatter];
    //设置为好友属性
    chatVC.buddy = buddy;
    
    //展现聊天界面
    [self.navigationController pushViewController:chatVC animated:YES];
}


#pragma mark 好友添加的代理方法
#pragma mark 好友请求被同意
- (void)didAcceptedByBuddy:(NSString *)username
{
    //提醒好友你的请求被同意了
    NSString *message = [NSString stringWithFormat:@"%@ 同意了你的好友请求",username];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"好友添加消息" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 好友请求被拒绝
- (void)didRejectedByBuddy:(NSString *)username
{
    //提醒好友你的请求被同意了
    NSString *message = [NSString stringWithFormat:@"%@ 拒绝了你的好友请求",username];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"好友添加消息" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 接受好友的添加请求
- (void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"好友添加请求" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[EaseMob sharedInstance].chatManager rejectBuddyRequest:username reason:@"我不认识你" error:nil];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:nil];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 监听被好友删除
- (void)didRemovedByBuddy:(NSString *)username{
    NSString *message = [username stringByAppendingString:@"  被好友删除了"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"被删除了" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark 未读消息数改变
- (void)didUnreadMessagesCountChanged
{
    //直接更新表格
    [self.tableView reloadData];
    //显示总的未读数
    [self showTabbarBadge];
}
#pragma mark  历史会话列表更新了
- (void)didUpdateConversationList:(NSArray *)conversationList
{
    //给数据源重新复制
    self.conversations = conversationList;
    //刷新表格
    [self.tableView reloadData];
    //显示总的未读数
    [self showTabbarBadge];
}

#pragma mark TabBar的badge
- (void)showTabbarBadge{
    //遍历所有的会话记录,将未读消息数进行类加
    NSInteger totalUnreadCount = 0;
    for (EMConversation *conversation in self.conversations) {
        totalUnreadCount += conversation.unreadMessagesCount;
    }
    if (totalUnreadCount > 0) {
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",totalUnreadCount];
    }else{
        self.navigationController.tabBarItem.badgeValue = nil;
    }
}

- (void)dealloc{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

@end
