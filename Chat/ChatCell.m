//
//  ChatCell.m
//  Chat
//
//  Created by LI on 16/5/4.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "ChatCell.h"

#import "AudioPlayTool.h"
#import "UIImageView+WebCache.h"

#import "PhotoContainerView.h"
#import "Masonry.h"


@interface ChatCell ()

/** 聊天的图片控件 */
@property (strong, nonatomic) UIImageView *chatImgView;

/// 显示图片的 view
@property (strong, nonatomic) PhotoContainerView *photoView;

@end

@implementation ChatCell


#pragma mark 懒加载
- (UIImageView *)chatImgView
{
    if (!_chatImgView) {
        _chatImgView = [[UIImageView alloc] init];
    }
    return _chatImgView;
}

- (PhotoContainerView *)photoView
{
    if (!_photoView) {
        _photoView = [[PhotoContainerView alloc] init];
        _photoView.backgroundColor = [UIColor redColor];
    }
    return _photoView;
}

- (void)awakeFromNib
{
    //在此方法做些初始化的操作
    //给label添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(messageLabelTap:)];
    [self.messageLabel addGestureRecognizer:tap];
}

#pragma mark messageLabel点击事件
- (void)messageLabelTap:(UITapGestureRecognizer *)recognizer{
    
    NSLog(@"ChatCell======%s",__func__);
    //只有当前的类型为语音的时候才播放
    id body = self.message.messageBodies[0];
    if ([body isKindOfClass:[EMVoiceMessageBody class]]) {
        BOOL receiver = [self.reuseIdentifier isEqualToString:ReceiveCell];
        [AudioPlayTool playWithMessage:self.message messageLabel:self.messageLabel receiver:receiver];
    }
}

//计算cell的高度
- (CGFloat)cellHeight
{
    [self layoutIfNeeded];
    
    return 15 + self.messageLabel.bounds.size.height + 15;
}

- (void)setMessage:(EMMessage *)message
{
    
    //重用时把聊天图片控件移除
//    [self.chatImgView removeFromSuperview];
    [self.photoView removeFromSuperview];
    
    _message = message;
    
    //1.获取消息体
    id body = message.messageBodies[0];
    if ([body isKindOfClass:[EMTextMessageBody class]]) {
        EMTextMessageBody *textBody = body;
        self.messageLabel.text = textBody.text;
    }else if([body isKindOfClass:[EMVoiceMessageBody class]]){
        self.messageLabel.attributedText = [self voiceAttributed];
    }else if ([body isKindOfClass:[EMImageMessageBody class]]){
        [self showImage];
    }else{
        self.messageLabel.text = @"未知的类型消息";
    }
}
#pragma mark 显示图片
- (void)showImage{
    
    //获取图片消息体
    EMImageMessageBody *imgBody = self.message.messageBodies[0];
    CGRect thumbnailFrame = (CGRect){0,0,imgBody.thumbnailSize};
    
    NSTextAttachment *imgAttach = [[NSTextAttachment alloc] init];
    imgAttach.bounds = thumbnailFrame;
    NSAttributedString *imgAtt = [NSAttributedString attributedStringWithAttachment:imgAttach];
    self.messageLabel.attributedText = imgAtt;
    
    //在cell里面添加一个UIImageView
    [self.messageLabel addSubview:self.photoView];
//    [self.messageLabel addSubview:self.chatImgView];
    
    //设置图片控件为缩略图的
//    self.photoView.frame = thumbnailFrame;
//    self.chatImgView.frame = thumbnailFrame;
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.messageLabel);
        make.edges.equalTo(@0);
    }];
    
    //下载图片
    //如果本地的图片存在直接显示本地,如果本地图片不存在就加载网络服务器上的图片
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:imgBody.thumbnailLocalPath]) {
//        NSLog(@"图片本地路径%@",imgBody.thumbnailLocalPath);
        self.photoView.picPathStringsArray = @[imgBody.localPath];
//        [self.chatImgView sd_setImageWithURL:[NSURL fileURLWithPath:imgBody.thumbnailLocalPath] placeholderImage:[UIImage imageNamed:@"defult"]];
    }else{
//        NSLog(@"图片远程路径%@",imgBody.thumbnailRemotePath);
        self.photoView.picPathStringsArray = @[imgBody.remotePath];
//        [self.chatImgView sd_setImageWithURL:[NSURL URLWithString:imgBody.thumbnailRemotePath] placeholderImage:[UIImage imageNamed:@"defult"]];
    }

}


#pragma mark 返回语音的富文本
- (NSAttributedString *)voiceAttributed{
    //创建一个可变的富文本
    NSMutableAttributedString *voiceAttributeString = [[NSMutableAttributedString alloc] init];
    
    //接受方:富文本 = 图片 + 时间
    if ([self.reuseIdentifier isEqualToString:ReceiveCell]) {
        //接受方的语音图片
        UIImage *receiveImg = [UIImage imageNamed:@"chat_receiver_audio_playing_full"];
        //创建图片的附件
        NSTextAttachment *imageAttachment = [[NSTextAttachment alloc]init];
        imageAttachment.image = receiveImg;
        imageAttachment.bounds = CGRectMake(0, -10, 30, 30);
        //图片富文本
        NSAttributedString *imgAtt = [NSAttributedString attributedStringWithAttachment:imageAttachment];
        [voiceAttributeString appendAttributedString:imgAtt];
        
        //获取时间
        EMVoiceMessageBody *voiceBody = self.message.messageBodies[0];
        NSInteger duaration = voiceBody.duration;
        NSString *timeStr = [NSString stringWithFormat:@"%ld'",duaration];
        //创建时间的富文本
        NSAttributedString *timeAttribute = [[NSAttributedString alloc] initWithString:timeStr];
        [voiceAttributeString appendAttributedString:timeAttribute];
        
    }else{
    //发送方:富文本 = 时间 + 图片
        //获取时间
        EMVoiceMessageBody *voiceBody = self.message.messageBodies[0];
        NSInteger duaration = voiceBody.duration;
        NSString *timeStr = [NSString stringWithFormat:@"%ld'",duaration];
        //创建时间的富文本
        NSAttributedString *timeAttribute = [[NSAttributedString alloc] initWithString:timeStr];
        [voiceAttributeString appendAttributedString:timeAttribute];
        
        //接受方的语音图片
        UIImage *receiveImg = [UIImage imageNamed:@"chat_sender_audio_playing_full"];
        //创建图片的附件
        NSTextAttachment *imageAttachment = [[NSTextAttachment alloc]init];
        imageAttachment.image = receiveImg;
        imageAttachment.bounds = CGRectMake(0, -10, 30, 30);
        //图片富文本
        NSAttributedString *imgAtt = [NSAttributedString attributedStringWithAttachment:imageAttachment];
        [voiceAttributeString appendAttributedString:imgAtt];
    }
    return [voiceAttributeString copy];
}

@end
