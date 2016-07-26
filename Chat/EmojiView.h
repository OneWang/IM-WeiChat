

#import <UIKit/UIKit.h>
#import "EmojiTextAttachment.h"
#import "NSAttributedString+EmojiExtension.h"
#import "EmotionCodeTable.h"

@protocol EmotionViewdelegate <NSObject>

- (void)emotionView_sBtnDidClick:(UIButton *)btn;

- (void)gifBtnClick:(UIButton *)btn;

@end

@interface EmojiView : UIImageView <UIScrollViewDelegate>

@property(nonatomic,strong)UITextView *IputView;

@property(assign,nonatomic)CGFloat EMOJI_MAX_SIZE;

@property (copy, nonatomic) NSString *text;

@property (nonatomic , weak) UIPageControl *pageControl;

@property (strong, nonatomic)UIImageView *emotonViewPageOne;

@property (strong, nonatomic)UIImageView *emotonViewPageTwo;

@property (strong, nonatomic)UIImageView *emotonViewPageThree;

@property (strong, nonatomic)UIImageView *emotonViewPageFour;

@property (strong, nonatomic)UIImageView *emotonViewPageFive;

@property (strong, nonatomic)UIImageView *emotonViewPageSix;

@property (strong, nonatomic)UIImageView *emotonViewPageSeven;

@property (strong, nonatomic)UIImageView *emotonViewPageEight;

@property(strong,nonatomic)UIScrollView *pageView;

@property(strong,nonatomic)UIFont *font;

@property(strong,nonatomic)UIButton *sendBtn;

@property(assign,nonatomic)CGFloat gap;

@property(strong,nonatomic)UIScrollView *scrollBtnsView;

@property(strong,nonatomic)UIButton *btnsBar;

@property(strong,nonatomic)UIButton *emotionBtn;

@property(strong,nonatomic)UIButton *emojiBtn;

@property(strong,nonatomic)UIButton *springBtn;


@property(assign,nonatomic) id <EmotionViewdelegate> delegate;


@end
