//
//  ChatViewController.m
//  Chat
//
//  Created by LI on 16/5/3.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatCell.h"
#import "TimeCell.h"
#import "AudioPlayTool.h"
#import "TimeTool.h"

#import "EMCDDeviceManager.h"

@interface ChatViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,EMChatManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
/** 输入工具条底部的约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputToolBarBottomConstraint;
/** tableView */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 数据源数组 */
@property (strong, nonatomic) NSMutableArray *dataArray;

/** 计算cell高度的工具类 */
@property (strong, nonatomic) ChatCell *cellTool;

/** intputToolBar的高度的约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputToolBarConstraint;
/** 录音按钮 */
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
/** 输入框 */
@property (weak, nonatomic) IBOutlet UITextView *textView;
/** 当前添加的时间 */
@property (strong, nonatomic) NSString *currentTimeStr;

/** 当前的会话对象 */
@property (strong, nonatomic) EMConversation *conversation;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景颜色
    self.tableView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    
    //加载本地数据库的聊记录(Messagev1)
    [self loadLocalChatRecords];
    
    //给计算cell高度的cell赋值
    self.cellTool = [self.tableView dequeueReusableCellWithIdentifier:ReceiveCell];
    
    //显示好友的名字
    self.title = self.buddy.username;
    
    //设置聊天管理器的代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    //1.监听键盘弹出,把输入工具条往上移动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //2.监听键盘的退出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)loadLocalChatRecords{
    
    //获取本地聊天记录使用,会话对象
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.buddy.username conversationType:eConversationTypeChat];
    
    self.conversation = conversation;
    
    //加载与当前这个聊天用户所有的聊天数据
    NSArray *messageArray = [conversation loadAllMessages];
    
    for (EMMessage *message in messageArray) {
        [self addDataArrayWithMessage:message];
    }
    
//    [self.dataArray addObjectsFromArray:messageArray];
}

#pragma mark 懒加载
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark 键盘显示时会触发的方法
- (void)kbWillShow:(NSNotification *)notif{
    //获取键盘高度
    //获取键盘结束时的位置
    CGRect kbEndFrame = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbHeight = kbEndFrame.size.height;
    
    //更改输入框的高度
    self.inputToolBarBottomConstraint.constant = kbHeight;
    //添加一个动画,让键盘和输入框一起升起
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark 键盘隐藏时会触发的方法
- (void)kbWillHide:(NSNotification *)notif{
    self.inputToolBarBottomConstraint.constant = 0;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //判断数据源类型
    if ([self.dataArray[indexPath.row] isKindOfClass:[NSString class]]) {//时间的cell
        TimeCell *time = [tableView dequeueReusableCellWithIdentifier:timeCell];
        time.timeLabel.text = self.dataArray[indexPath.row];
        return time;
    }
    ChatCell *cell = nil;
    //先获取消息模型
    EMMessage * message = self.dataArray[indexPath.row];
    if ([message.from isEqualToString:self.buddy.username]) {//接受方
        cell = [tableView dequeueReusableCellWithIdentifier:ReceiveCell];
    }else{//发送方
        cell = [tableView dequeueReusableCellWithIdentifier:SendCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.message = message;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //时间cell的高度是固定的
    if ([self.dataArray[indexPath.row] isKindOfClass:[NSString class]]) {
        return 28;
    }
    
    //设置label的数据
    //1.获取消息模型
    EMMessage *message = self.dataArray[indexPath.row];
   
    self.cellTool.message = message;
    
    return [self.cellTool cellHeight];
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    //计算textView的高度,调整整个输入工具条的高度
    CGFloat textViewH = 0;
    CGFloat minHeight = 33;
    CGFloat maxHeight = 68;
    
    //获取contentsize的高度
    CGFloat contentHeight = textView.contentSize.height;
    if (contentHeight < minHeight) {
        textViewH = minHeight;
    }else if (contentHeight > maxHeight){
        textViewH = maxHeight;
    }else{
        textViewH = contentHeight;
    }
    
    if ([textView.text hasSuffix:@"\n"]) {
        NSLog(@" 发送消息 ");
        [self sendText:textView.text];
        
        //清空textView的文字
        textView.text = nil;
        
        //发送时textView的的高度为33
        textViewH = minHeight;
    }
    //调整整个inputtoolbar的高度
    self.inputToolBarConstraint.constant = textViewH + 6 + 7;
    
    [UIView animateWithDuration:.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    //让光标回到原位
    [textView setContentOffset:CGPointZero animated:YES];
    [textView scrollRangeToVisible:textView.selectedRange];
}

#pragma mark 发送文本消息
- (void)sendText:(NSString *)text{
    
    //把最后一个换行字符去除
    text = [text substringToIndex:text.length - 1];
    
    //消息 = 消息头 + 消息体
    //每一种消息类型对应不同的消息体
//    EMTextMessageBody
//    EMVoiceMessageBody
//    EMLocationMessageBody
//    EMImageMessageBody
//    EMVideoMessageBody
    
    NSLog(@"要发送给谁的:%@",self.buddy.username);
    
    //创建一个聊天的文本对象
    EMChatText *chatText = [[EMChatText alloc] initWithText:text];
    
    //创建一个文本的消息体
    EMTextMessageBody *textBody = [[EMTextMessageBody alloc] initWithChatObject:chatText];
    
    [self sendMesssage:textBody];
    
    //消息类型
//    @constant eMessageTypeChat            单聊消息
//    @constant eMessageTypeGroupChat       群聊消息
//    @constant eMessageTypeChatRoom        聊天室消息
    
}

- (void)sendMesssage:(id<IEMMessageBody>)body{
    
    //2.构造消息对象
    EMMessage *msgObj = [[EMMessage alloc] initWithReceiver:self.buddy.username bodies:@[body]];
    msgObj.messageType = eMessageTypeChat;
    
    //3.发送消息
    [[EaseMob sharedInstance].chatManager asyncSendMessage:msgObj progress:nil prepare:^(EMMessage *message, EMError *error) {
        NSLog(@"准备发送");
    } onQueue:nil completion:^(EMMessage *message, EMError *error) {
        NSLog(@"发送成功");
    } onQueue:nil];
    
    //把消息添加到数据源数组,然后刷新表格
    [self addDataArrayWithMessage:msgObj];
    [self.tableView reloadData];
    
    //把消息滚动显示在最上面
    [self scrollToBottom];
}

//把消息滚动显示在最上面
- (void)scrollToBottom{
    
    //获取最后一行
    if (self.dataArray.count == 0) {
        return;
    }
    NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastIndex atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark 发送录音文件
- (void)sendVoice:(NSString *)recordPath duration:(NSInteger)duration{
    
    //1.构建一个语音的消息体
    EMChatVoice *chatVoice = [[EMChatVoice alloc] initWithFile:recordPath displayName:@"[语音]"];
//    chatVoice.duration = duration;
    
    EMVoiceMessageBody *voiceBody = [[EMVoiceMessageBody alloc] initWithChatObject:chatVoice];
    voiceBody.duration = duration;
    
    [self sendMesssage:voiceBody];
}
#pragma mark
- (void)sendImage:(UIImage *)selectedImage{
    //1.构造图片消息体
    EMChatImage *orginalImage = [[EMChatImage alloc] initWithUIImage:selectedImage displayName:@"图片"];
    
    EMImageMessageBody *imgBody = [[EMImageMessageBody alloc] initWithImage:orginalImage thumbnailImage:nil];
    
    [self sendMesssage:imgBody];
}

///WARN: 接受好友的回复消息
- (void)didReceiveMessage:(EMMessage *)message{
#warning from 一定要等于当前的聊天用户才可以刷新数据
    if ([message.from isEqualToString:self.buddy.username]) {
        //1.把接受的消息添加到数据源数组中
        [self addDataArrayWithMessage:message];
        //2.刷新表格
        [self.tableView reloadData];
        //3.显示数据到底部
        [self scrollToBottom];
    }
}

#pragma mark Action事件
- (IBAction)voiceAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    //1.显示录音按钮
    self.recordBtn.hidden = !self.recordBtn.hidden;
    self.textView.hidden = !self.textView.hidden;
    
    if (self.recordBtn.hidden == NO) {//录音按钮要显示
        btn.selected = YES;
        self.inputToolBarConstraint.constant = 46;
        //隐藏键盘
        [self.view endEditing:YES];
    }else{
        btn.selected = NO;
        //当不录音的时候键盘显示
        [self.textView becomeFirstResponder];
        //恢复inputtoolbar的高度
        [self textViewDidChange:self.textView];
    }
}
#pragma mark 按钮点击开始录音
- (IBAction)beginRecordAction:(id)sender {
    //文件名以时间命名
    int x = arc4random() % 100000;
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
    
    [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName completion:^(NSError *error) {
        if (!error) {
            NSLog(@"开始录音成功");
        }
    }];
}
#pragma mark 按钮松开结束录音
- (IBAction)endRecordAction:(id)sender {
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error) {
            NSLog(@"结束录音成功");
            NSLog(@"%@====%zd",recordPath,aDuration);
            //发送语音
            [self sendVoice:recordPath duration:aDuration];
        }
    }];
}
#pragma mark 手指移到按钮外部松开取消录音
- (IBAction)cancleARecordction:(id)sender {
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
}

#pragma mark 显示图片选择器
- (IBAction)showImagePicker:(id)sender {
    //显示图片选择的控制器
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    
    //设置源
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgPicker.delegate = self;
    [self presentViewController:imgPicker animated:YES completion:NULL];
}
#pragma mark 用户选中图片的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //获取用户选中的图片
    UIImage *selectedImg = info[UIImagePickerControllerOriginalImage];
    
    //发送图片
    [self sendImage:selectedImg];
    //隐藏当前图片选择器
    [self dismissViewControllerAnimated:picker completion:NULL];
}

#pragma mark 开会拖拽就停止语音播放
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [AudioPlayTool stop];
}

//往数据源数组中添加元素
- (void)addDataArrayWithMessage:(EMMessage *)message{
    //判断消息对象前面是否添加时间
    NSString *timeStr = [TimeTool timeStr:message.timestamp];
    if (![self.currentTimeStr isEqualToString:timeStr]) {
        [self.dataArray addObject:timeStr];
        self.currentTimeStr = timeStr;
    }
    //再添加message对象
    [self.dataArray addObject:message];
    
    //设置消息为已读
    [self.conversation markMessageWithId:message.messageId asRead:YES];
}

@end
