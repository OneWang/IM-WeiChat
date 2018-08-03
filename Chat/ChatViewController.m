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

#import "EmojiView.h"
#import "AudioPlayTool.h"
#import "TimeTool.h"
#import "UIView+Extension.h"
#import "FunctionView.h"
#import "UIViewExt.h"
#import "UIViewController+BackButtonHandler.h"
#import "MBProgressHUD+MJ.h"

#import "EMCDDeviceManager.h"
#import "PhotoContainerView.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define MAX_VIDEO_DURATION_FOR_CHAT 15;

@interface ChatViewController ()<UITableViewDataSource,
                                 UITableViewDelegate,
                                 UITextViewDelegate,
                                 EMChatManagerDelegate,
                                 UIImagePickerControllerDelegate,
                                 UINavigationControllerDelegate,
                                 EmotionViewdelegate,
                                 ChatCellDelegate,
                                 ChatShareDelegate>

@property (strong, nonatomic) NSString * name;
/** emoji 键盘 */
@property (strong, nonatomic) EmojiView *emoji;

/** 键盘高度 */
@property(assign,nonatomic)CGFloat keyBoardH;

/** 输入工具条底部的约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputToolBarBottomConstraint;
/** tableView */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 数据源数组 */
@property (strong, nonatomic) NSMutableArray *dataArray;

/** 计算cell高度的工具类 */
@property (strong, nonatomic) ChatCell *cellTool;
/** emoji 按钮 */
@property (weak, nonatomic) IBOutlet UIButton *emojiBtn;

/** 更多功能所显示的 view */
@property (weak, nonatomic) FunctionView *functionView;

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

/// 消息模型
@property (strong, nonatomic)  EMMessage *imageMessage;

/// 图片浏览器
@property (strong, nonatomic)  PhotoContainerView *photoContainer;
/** 图片控制器 */
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@end

@implementation ChatViewController
- (PhotoContainerView *)photoContainer{
    if (!_photoContainer) {
        _photoContainer = [[PhotoContainerView alloc] init];
    }
    return _photoContainer;
}

- (EmojiView *)emoji
{
    if (!_emoji) {
        _emoji = [[EmojiView alloc] initWithFrame:emotionDownFrame];
        _emoji.IputView = self.textView;
        _emoji.delegate = self;
        [self.view addSubview:_emoji];
    }
    return _emoji;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    //设置背景颜色
    self.tableView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    
    //加载本地数据库的聊记录(Messagev1)
    [self loadLocalChatRecords];
    
    //给计算cell高度的cell赋值
    self.cellTool = [self.tableView dequeueReusableCellWithIdentifier:ReceiveCell];
    
    //显示好友的名字
    self.title = self.friendName;
    
    //设置聊天管理器的代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    //1.监听键盘弹出,把输入工具条往上移动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //2.监听键盘的退出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

//返回按钮被点击的时候
- (BOOL)navigationShouldPopOnBackButton
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //把消息滚动显示在最上面
    [self scrollToBottom];
}

/** 添加更多的功能 */
- (void)addMoreFunctionView{
    // 添加更多功能
    FunctionView *functionView = [[FunctionView alloc] initWithFrame:CGRectMake(0, screenH, kWeChatScreenWidth, 217)];
    functionView.delegate = self;
    self.inputToolBarBottomConstraint.constant = 217;
    [[UIApplication sharedApplication].keyWindow addSubview:functionView];
    self.functionView = functionView;
    
    if (self.textView.isFirstResponder) {
        [self.textView resignFirstResponder];
        functionView.top = screenH - 217;
        self.tableView.frame = CGRectMake(0, 0, screenW, screenH - 217);
    }else{
//        self.tableView.top = (functionView.top > screenH - 1)? - 200:0;
        functionView.top = (functionView.top > screenH - 1)?screenH - 217:screenH;
    }
}

#pragma mark - ChatShareDelegate
- (void)cellWithTagDidTapped:(NSInteger)tag
{
    switch (tag) {
        case TAG_Photo:
            self.functionView.top = screenH;
            self.inputToolBarBottomConstraint.constant = 0;
            [self presentImagePickerController];
            break;
        case TAG_Location:
            [self presendLocationViewController];
            break;
        case TAG_Camera:
            [self takePictureAndVideoAction];
            break;
        case TAG_Sight:
            [self presentSightController];
            break;
        default:
            break;
    }
}

#pragma mark -private method
- (void)presentImagePickerController {
    //    LLImagePickerController *vc = [[LLImagePickerController alloc] init];
    //    vc.pickerDelegate = self;
    //    [self.navigationController presentViewController:vc animated:YES completion:nil];
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)presendLocationViewController {
    //    LLGaoDeLocationViewController *locationVC = [[LLGaoDeLocationViewController alloc] init];
    //    locationVC.delegate = self;
    //
    //    LLNavigationController *navigationVC = [[LLNavigationController alloc] initWithRootViewController:locationVC];
    //
    //    [self.navigationController presentViewController:navigationVC animated:YES completion:nil];
}

- (void)takePictureAndVideoAction {
#if TARGET_IPHONE_SIMULATOR
    
#elif TARGET_OS_IPHONE
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
    self.imagePicker.videoMaximumDuration = MAX_VIDEO_DURATION_FOR_CHAT;
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
#endif
    
}


- (void)presentSightController {
    NSLog(@"小视频");
    
}


- (void)loadLocalChatRecords{
    
    //获取本地聊天记录使用,会话对象
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.friendName conversationType:eConversationTypeChat];
    
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
        time.selectionStyle = UITableViewCellSelectionStyleNone;
        time.timeLabel.text = self.dataArray[indexPath.row];
        return time;
    }
    ChatCell *cell = nil;
    //先获取消息模型
    EMMessage * message = self.dataArray[indexPath.row];
    if ([message.from isEqualToString:self.friendName]) {//接受方
        cell = [tableView dequeueReusableCellWithIdentifier:ReceiveCell];
    }else{//发送方
        cell = [tableView dequeueReusableCellWithIdentifier:SendCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
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

#pragma mark - 
#pragma mark - ChatCellDelegate
//- (void)chatCellShowImageWithMessage:(EMMessage *)msg
//{
//    self.imageMessage = msg;
//    
//    EMImageMessageBody *body = self.imageMessage.messageBodies[0];
//    // 预览图片的路径
//    NSString *imgPath = body.localPath;
//    // 判断本地图片是否存在
//    NSFileManager *file = [NSFileManager defaultManager];
//    // 使用SDWebImage设置图片
//    NSURL *url = nil;
//    if ([file fileExistsAtPath:imgPath]) {
//        self.photoContainer.picPathStringsArray = @[imgPath];
//    }else{
//        url = [NSURL URLWithString:body.remotePath];
//        NSString *path = url.absoluteString;
//        self.photoContainer.picPathStringsArray = @[path];
//    }
//    
//}

- (void)chatCellClickHeaderImageView:(UIImageView *)headerImage
{
    ChatCell *cell = (ChatCell *)headerImage.superview.superview;
    if ([cell.reuseIdentifier isEqualToString:@"ReceiveCell"]) {
        NSLog(@"chatCellClickHeaderImageView头像被点击!!!%@",self.friendName);
    }else if([cell.reuseIdentifier isEqualToString:@"SendCell"]){
        NSLog(@"chatCellClickHeaderImageView头像被点击!!!%@",@"获取当前登录的账户名称");
    }
}

- (void)chatCellShowImageWithMessage:(EMMessage *)msg {
    
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
    
    NSLog(@"要发送给谁的:%@",self.friendName);
    
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
    EMMessage *msgObj = [[EMMessage alloc] initWithReceiver:self.friendName bodies:@[body]];
    msgObj.messageType = eMessageTypeChat;
    
    id message = msgObj.messageBodies[0];
    if ([body isKindOfClass:[EMTextMessageBody class]]) {
        EMTextMessageBody *textBody = message;
        if (textBody.text.length == 0) {
            [MBProgressHUD showError:@"发送消息不能为空!!"];
            return ;
        }
    }
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
    if ([message.from isEqualToString:self.friendName]) {
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
    //    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    
    //设置源
    //    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //    imgPicker.delegate = self;
    //    [self presentViewController:imgPicker animated:YES completion:NULL];
    NSLog(@"添加更多功能按钮");
    [self addMoreFunctionView];
}
#pragma mark 表情键盘
- (IBAction)ButtonClickEmoj:(UIButton *)emotionBtn {
    if (emotionBtn.selected) {
        emotionBtn.selected = NO;
        [self.textView becomeFirstResponder];
        self.tableView.height = screenH - self.keyBoardH - self.inputToolBarConstraint.constant - 64;
    }else
    {
        [self.textView resignFirstResponder];
        emotionBtn.selected = YES;
        [UIView animateWithDuration:emotionTipTime animations:^{
            self.emoji.frame = emotionUpFrame;
            //            self.toolBarView.frame = CGRectMake(0, screenH - self.inputToolBarConstraint.constant - self.emoji.height, screenW, self.inputToolBarConstraint.constant);
            self.tableView.height = screenH - self.emoji.height - self.inputToolBarConstraint.constant - 64;
            if (self.tableView.contentSize.height > self.tableView.height) {
                [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.bounds.size.height + 3) animated:NO];
            }
        }];
    }
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
    [UIView animateWithDuration:.2 animations:^{
        self.emoji.frame = CGRectMake(0, screenH, screenW, 0);
        self.inputToolBarBottomConstraint.constant = 0;
        self.functionView.top = screenH;
        self.tableView.height = screenH - self.inputToolBarConstraint.constant - 64;
    }];
    [self.functionView removeFromSuperview];
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

- (void)emotionView_sBtnDidClick:(UIButton *)btn {
    
}

- (void)gifBtnClick:(UIButton *)btn {
    
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}

- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    return CGSizeZero;
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
    
}

- (void)setNeedsFocusUpdate {
    
}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
    return YES;
}

- (void)updateFocusIfNeeded {
    
}

@end
