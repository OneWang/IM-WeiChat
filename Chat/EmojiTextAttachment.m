

#import "EmojiTextAttachment.h"

@implementation EmojiTextAttachment

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
    
    return CGRectMake(0, -3, _emojiSize.width, _emojiSize.height);
}
@end
