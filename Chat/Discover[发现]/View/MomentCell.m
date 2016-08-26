//
//  MomentCell.m
//  Chat
//
//  Created by LI on 16/8/26.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "MomentCell.h"
#import "Masonry.h"
#import "MomentModel.h"
#import "PhotoContainerView.h"
#import "CommentView.h"
#import "LiveMenu.h"
#import "UIView+SDAutoLayout.h"

const CGFloat contentLabelFontSize = 15;
CGFloat maxContentLabelHeight = 0; // 根据具体font而定
NSString *const kCellLikeButtonClickedNotification = @"CellLikeButtonClickedNotification";


@interface MomentCell ()

/// 头像
@property (weak, nonatomic)  UIButton *iconBtn;
/// 昵称
@property (weak, nonatomic)  UILabel *nickLabel;
/// 描述
@property (weak, nonatomic)  UILabel *descLabel;
/// 时间
@property (weak, nonatomic)  UILabel *timeLabel;
/// 全文按钮
@property (weak, nonatomic)  UIButton *moreBtn;
/// 评论
@property (weak, nonatomic)  UIButton *commentBtn;
/// 图片
@property (weak, nonatomic) PhotoContainerView *pictures;
/// 评论的 view
@property (weak, nonatomic) CommentView *commentView;
/// 更多操作
@property (weak, nonatomic)  LiveMenu *likeMenu;

@end

@implementation MomentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"moment";
    MomentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[MomentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //设置
        [self setup];
    }
    return self;
}

- (void)setup{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOperationButtonClickedNotification:) name:kCellLikeButtonClickedNotification object:nil];
    
    UIButton *icon = [[UIButton alloc] init];
    self.iconBtn = icon;
    [self.contentView addSubview:self.iconBtn];
    
    UILabel *nick = [[UILabel alloc] init];
    nick.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    nick.font = [UIFont systemFontOfSize:14];
    self.nickLabel = nick;
    [self.contentView addSubview:self.nickLabel];
    
    UILabel *desc = [[UILabel alloc] init];
    desc.font = [UIFont systemFontOfSize:contentLabelFontSize];
    desc.numberOfLines = 0;
    self.descLabel = desc;
    [self.contentView addSubview:self.descLabel];
    
    UILabel *time = [[UILabel alloc] init];
    time.font = [UIFont systemFontOfSize:13];
    self.timeLabel = time;
    [self.contentView addSubview:self.timeLabel];
    
    PhotoContainerView *picture = [[PhotoContainerView alloc] init];
    self.pictures = picture;
    [self.contentView addSubview:self.pictures];
    
    CommentView *commentView = [[CommentView alloc] init];
    self.commentView = commentView;
    [self.contentView addSubview:self.commentView];
    
    LiveMenu *like = [[LiveMenu alloc] init];
    self.likeMenu = like;
    [self.contentView addSubview:self.likeMenu];
    __weak typeof(self) weakSelf = self;
    [self.likeMenu setLikeButtonClickedOperation:^{
        if ([weakSelf.delegate respondsToSelector:@selector(didClickLikeButtonInCell:)]) {
            [weakSelf.delegate didClickLikeButtonInCell:weakSelf];
        }
    }];
    [self.likeMenu setCommentButtonClickedOperation:^{
        if ([weakSelf.delegate respondsToSelector:@selector(didClickcCommentButtonInCell:)]) {
            [weakSelf.delegate didClickcCommentButtonInCell:weakSelf];
        }
    }];
    
    UIButton *more = [[UIButton alloc] init];
    [more setTitle:@"全文" forState:UIControlStateNormal];
    [more setTitleColor:[UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0] forState:UIControlStateNormal];
    [more addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    more.titleLabel.font = [UIFont systemFontOfSize:14];
    self.moreBtn = more;
    [self.contentView addSubview:self.moreBtn];
    
    UIButton *comment = [[UIButton alloc] init];
    [comment setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
    [comment addTarget:self action:@selector(commentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    comment.titleLabel.font = [UIFont systemFontOfSize:14];
    self.commentBtn = comment;
    [self.contentView addSubview:self.commentBtn];
    
    CGFloat margin = 8;
    
    [self.iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(margin);
        make.width.height.equalTo(@40);
    }];
    
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconBtn);
        make.left.equalTo(self.iconBtn.mas_right).offset(margin);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconBtn.mas_bottom).offset(margin);
        make.left.equalTo(self.nickLabel.mas_left);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.descLabel.mas_left);
        make.top.equalTo(self.descLabel.mas_bottom).offset(margin);
    }];
    
    [self.pictures mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moreBtn.mas_left);
        make.top.equalTo(self.moreBtn.mas_bottom).offset(margin);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pictures.mas_left);
        make.top.equalTo(self.pictures.mas_bottom).offset(margin);
    }];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.pictures.mas_right);
        make.top.equalTo(self.pictures.mas_bottom).offset(margin);
    }];
    
    
}

- (void)moreButtonClicked{
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexPath);
    }
}

- (void)commentButtonClicked{
    [self postOperationButtonClickedNotification];
    self.likeMenu.show = !self.likeMenu.isShowing;
}
- (void)receiveOperationButtonClickedNotification:(NSNotification *)notification
{
    UIButton *btn = [notification object];
    
    if (btn != self.commentBtn && self.likeMenu.isShowing) {
        self.likeMenu.show = NO;
    }
}
- (void)setMoent:(MomentModel *)moment
{
    _moment = moment;
    
    [self.iconBtn setImage:[UIImage imageNamed:moment.iconName] forState:UIControlStateNormal];
    
    self.nickLabel.text = moment.name;
    self.descLabel.text = moment.msgContent;
    self.timeLabel.text = @"1分钟前";
    self.pictures.picPathStringsArray = moment.picNamesArray;
    self.pictures.backgroundColor = [UIColor redColor];
    
    if (moment.shouldShowMoreButton) {
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@20);
        }];
        self.moreBtn.hidden = NO;
        if (moment.isOpening) {
            [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(MAXFLOAT));
            }];
            [self.moreBtn setTitle:@"收起" forState:UIControlStateNormal];
        }else{
            [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(maxContentLabelHeight));
            }];
            [self.moreBtn setTitle:@"全文" forState:UIControlStateNormal];
        }
    }else{
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@0);
        }];
        self.moreBtn.hidden = YES;
    }
    
    CGFloat picContainerTopMargin = 0;
    if (moment.picNamesArray.count) {
        picContainerTopMargin = 10;
    }
    
    UIView *bottomView;
    
    if (!moment.commentArray.count && !moment.likeArray.count) {
        bottomView = self.timeLabel;
    } else {
        bottomView = self.commentView;
    }
    
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (self.likeMenu.isShowing) {
        self.likeMenu.show = NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self postOperationButtonClickedNotification];
    if (self.likeMenu.isShowing) {
        self.likeMenu.show = NO;
    }
}

- (void)postOperationButtonClickedNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kCellLikeButtonClickedNotification object:self.commentBtn];
}

@end
