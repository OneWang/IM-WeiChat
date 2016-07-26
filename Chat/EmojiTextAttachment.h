

#import <UIKit/UIKit.h>

@interface EmojiTextAttachment : NSTextAttachment

@property(strong, nonatomic) NSString *emojiTag;
/** 表情的大小 size */
@property(assign, nonatomic) CGSize emojiSize;  
@end
