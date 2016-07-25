//
//  AudioPlayTool.m
//  Chat
//
//  Created by LI on 16/5/4.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "AudioPlayTool.h"
#import "EMCDDeviceManager.h"


static UIImageView *animatingImageView;
@implementation AudioPlayTool

+ (void)playWithMessage:(EMMessage *)message messageLabel:(UILabel *)messageLabel receiver:(BOOL)receiver
{
    
    //把以前的动画移除
    [animatingImageView stopAnimating];
    [animatingImageView removeFromSuperview];
    
    //播放语音
    EMVoiceMessageBody *voiceBody = message.messageBodies[0];
    
    //本地的语音文件路径
    NSString *path = voiceBody.localPath;
    
    //如果本地语音路径不存在,使用服务器的语音
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        path = voiceBody.remotePath;
    }
    [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:path completion:^(NSError *error) {
        NSLog(@"语音播放完毕 %@",error);
        
        //移除动画
        [animatingImageView stopAnimating];
        [animatingImageView removeFromSuperview];
    }];
    
    //添加动画
    //创建一个UIImageView添加到Label上
    UIImageView *imageView = [[UIImageView alloc] init];
    
    [messageLabel addSubview:imageView];
    
    //添加动画的图片
    if (receiver) {
        imageView.animationImages = @[[UIImage imageNamed:@"chat_receiver_audio_playing000"],
                                      [UIImage imageNamed:@"chat_receiver_audio_playing001"],
                                      [UIImage imageNamed:@"chat_receiver_audio_playing002"],
                                      [UIImage imageNamed:@"chat_receiver_audio_playing003"]];
        imageView.frame = CGRectMake(0, 0, 30, 30);
    }else{
        imageView.animationImages = @[[UIImage imageNamed:@"chat_sender_audio_playing_000"],
                                      [UIImage imageNamed:@"chat_sender_audio_playing_001"],
                                      [UIImage imageNamed:@"chat_sender_audio_playing_002"],
                                      [UIImage imageNamed:@"chat_sender_audio_playing_003"]];
        imageView.frame = CGRectMake(messageLabel.bounds.size.width - 30, 0, 30, 30);
    }
    imageView.animationDuration = 1.0;
    [imageView startAnimating];
    animatingImageView = imageView;
}
//停止播放语音
+ (void)stop
{
    //停止播放语音
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    //移除动画
    [animatingImageView stopAnimating];
    [animatingImageView removeFromSuperview];
    
}

@end
