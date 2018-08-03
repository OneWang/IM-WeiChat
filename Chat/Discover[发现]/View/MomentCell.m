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
#import "LikeMenu.h"
#import "UIView+SDAutoLayout.h"

const CGFloat contentLabelFontSize = 15;
CGFloat maxContentLabelHeight = 0; // 根据具体font而定
static NSString *const kCellLikeButtonClickedNotification = @"CellLikeButtonClickedNotification";

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
@property (weak, nonatomic) LikeMenu *likeMenu;

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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //设置
        [self setup];
    }
    return self;
}

- (void)setup{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOperationButtonClickedNotification:) name:kCellLikeButtonClickedNotification object:nil];
    
    UIButton *icon = [[UIButton alloc] init];
    [icon addTarget:self action:@selector(clickIcon) forControlEvents:UIControlEventTouchUpInside];
    self.iconBtn = icon;
//    [self.contentView addSubview:self.iconBtn];
    
    UILabel *nick = [[UILabel alloc] init];
    nick.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    nick.font = [UIFont systemFontOfSize:14];
    self.nickLabel = nick;
//    [self.contentView addSubview:self.nickLabel];
    
    UILabel *desc = [[UILabel alloc] init];
    desc.font = [UIFont systemFontOfSize:contentLabelFontSize];
    desc.numberOfLines = 0;
    desc.backgroundColor = [UIColor redColor];
    self.descLabel = desc;
//    [self.contentView addSubview:self.descLabel];
    
    if (maxContentLabelHeight == 0) {
        maxContentLabelHeight = self.descLabel.font.lineHeight * 3;
    }
    
    UILabel *time = [[UILabel alloc] init];
    time.font = [UIFont systemFontOfSize:13];
    self.timeLabel = time;
//    [self.contentView addSubview:self.timeLabel];
    
    PhotoContainerView *picture = [[PhotoContainerView alloc] init];
    self.pictures = picture;
    picture.backgroundColor = [UIColor yellowColor];
//    [self.contentView addSubview:self.pictures];
    
    CommentView *commentView = [[CommentView alloc] init];
    self.commentView = commentView;
//    [self.contentView addSubview:self.commentView];
    
    LikeMenu *like = [[LikeMenu alloc] init];
    self.likeMenu = like;
//    [self.contentView addSubview:self.likeMenu];
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
    more.backgroundColor = [UIColor purpleColor];
    self.moreBtn = more;
//    [self.contentView addSubview:self.moreBtn];
    
    UIButton *comment = [[UIButton alloc] init];
    [comment setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
    [comment addTarget:self action:@selector(commentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    comment.titleLabel.font = [UIFont systemFontOfSize:14];
    self.commentBtn = comment;
//    [self.contentView addSubview:self.commentBtn];
    
    NSArray *views = @[self.iconBtn,self.nickLabel,self.descLabel,self.pictures,self.moreBtn,self.commentBtn,self.likeMenu,self.commentView,self.timeLabel];
    
    [self.contentView sd_addSubviews:views];
    
    CGFloat margin = 8;
    self.iconBtn.sd_layout.leftSpaceToView(self.contentView,margin).topSpaceToView(self.contentView,margin + 8).widthIs(40).heightIs(40);
    
//    [self.iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.equalTo(self.contentView).offset(margin);
//        make.width.height.equalTo(@40);
//    }];
    
//    self.nickLabel.sd_layout.leftSpaceToView(self.iconBtn,margin).topEqualToView(self.iconBtn).heightIs(18);
//    [self.nickLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(margin + 8);
        make.left.equalTo(self.iconBtn.mas_right).offset(margin);
    }];
    
//    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 70;
//    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.nickLabel.mas_bottom).offset(margin);
//        make.left.equalTo(self.iconBtn.mas_right).offset(margin);
//        make.width.equalTo(@(contentW));
//    }];
    
    self.descLabel.sd_layout.leftEqualToView(self.nickLabel).topSpaceToView(self.nickLabel,margin).rightSpaceToView(self.contentView,margin).autoHeightRatio(0);
    
//    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.iconBtn.mas_right).offset(margin);
//        make.top.equalTo(self.descLabel.mas_bottom).offset(margin);
//    }];
    
    self.moreBtn.sd_layout.leftEqualToView(self.descLabel).topSpaceToView(self.descLabel,0).widthIs(30);
    
    self.pictures.sd_layout.leftEqualToView(self.descLabel);
    
//    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.pictures.mas_left);
//        make.top.equalTo(self.pictures.mas_bottom).offset(margin);
//    }];
    self.timeLabel.sd_layout.leftEqualToView(self.pictures).topSpaceToView(self.pictures,margin).heightIs(15);
    [self.timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
//    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.descLabel.mas_right);
//        make.top.equalTo(self.pictures.mas_bottom).offset(margin);
//    }];
    
 self.commentBtn.sd_layout.rightSpaceToView(self.contentView,margin).centerYEqualToView(self.timeLabel).heightIs(25).widthIs(25);
    
    self.commentView.sd_layout.leftEqualToView(self.descLabel).rightSpaceToView(self.contentView, margin).topSpaceToView(self.timeLabel, margin);
    
    self.likeMenu.sd_layout.rightSpaceToView(self.commentBtn, 0).heightIs(36).centerYEqualToView(self.commentBtn).widthIs(0);
}

- (void)moreButtonClicked{
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexPath);
    }
}

- (void)clickIcon{
    if (self.clickIconBtnBlock) {
        self.clickIconBtnBlock(self.indexPath);
    }
}

- (void)commentButtonClicked{
    [self postOperationButtonClickedNotification];
    self.likeMenu.show = !self.likeMenu.isShowing;
}

- (void)receiveOperationButtonClickedNotification:(NSNotification *)notification{
    UIButton *btn = [notification object];
    if (btn != self.commentBtn && self.likeMenu.isShowing) {
        self.likeMenu.show = NO;
    }
}

- (void)setMoment:(MomentModel *)moment{
    _moment = moment;
    
    [self.iconBtn setImage:[UIImage imageNamed:moment.iconName] forState:UIControlStateNormal];
    
    self.nickLabel.text = moment.name;
    self.descLabel.text = moment.msgContent;
    self.timeLabel.text = @"1分钟前";
    self.pictures.picPathStringsArray = moment.picNamesArray;
    
    [self.commentView setupWithLikeItemsArray:moment.likeArray commentItemsArray:moment.commentArray];
    
    if (moment.shouldShowMoreButton) {// 如果文字高度超过60
        self.moreBtn.sd_layout.heightIs(20);
//        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(@40);
//            make.height.equalTo(@25);
//        }];
        self.moreBtn.hidden = NO;
        if (moment.isOpening) {// 如果需要展开
//            CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 70;
//            CGRect textRect = [self.descLabel.text boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:contentLabelFontSize]} context:nil];
//            [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.height.equalTo(@(textRect.size.height));
//            }];
            self.descLabel.sd_layout.maxHeightIs(MAXFLOAT);
            [self.moreBtn setTitle:@"收起" forState:UIControlStateNormal];
        }else{
//            [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.height.equalTo(@(maxContentLabelHeight));
//            }];
            self.descLabel.sd_layout.maxHeightIs(maxContentLabelHeight);
            [self.moreBtn setTitle:@"全文" forState:UIControlStateNormal];
        }
    }else{
//        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.height.equalTo(@0);
//        }];
        self.moreBtn.sd_layout.heightIs(0);
        self.moreBtn.hidden = YES;
    }
    
    CGFloat picContainerTopMargin = 0;
    if (moment.picNamesArray.count) {
        picContainerTopMargin = 18;
    }
    self.pictures.sd_layout.topSpaceToView(self.moreBtn, picContainerTopMargin);
    
    UIView *bottomView;
    if (!moment.commentArray.count && !moment.likeArray.count) {
        bottomView = self.timeLabel;
    } else {
        bottomView = self.commentView;
    }
    
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    if (self.likeMenu.isShowing) {
        self.likeMenu.show = NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self postOperationButtonClickedNotification];
    if (self.likeMenu.isShowing) {
        self.likeMenu.show = NO;
    }
}

- (void)postOperationButtonClickedNotification{
    [[NSNotificationCenter defaultCenter] postNotificationName:kCellLikeButtonClickedNotification object:self.commentBtn];
}

@end
