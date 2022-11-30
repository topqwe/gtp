//
//  RichTextAdjustTableViewCell.m
//  TextTest
//
//  Created by ren on 15/10/21.
//  Copyright © 2015年 ren. All rights reserved.
//

#import "RichTextAdjustTableViewCell.h"

@implementation RichTextAdjustTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_lblTest setPreferredMaxLayoutWidth:[UIScreen mainScreen].bounds.size.width];
    // Initialization code
    //sel
    //iOS7需要注意preferredMaxLayoutWidth的设置，iOS8需要设置estimatedRowHeight、rowHeight = UITableViewAutomaticDimension。更加注意的是约束的准确！！！
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)presentItem
{
    NSMutableAttributedString *strNormal = [[NSMutableAttributedString alloc] initWithString:@"Using NSAttributed String To be or not to be ,That's a question!"];
    [strNormal addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,5)];
    [strNormal addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,12)];
    [strNormal addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
    [strNormal addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:30.0] range:NSMakeRange(0, 5)];
    [strNormal addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:38] range:NSMakeRange(6, 12)];
    [strNormal addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Courier-BoldOblique" size:30.0] range:NSMakeRange(19, 6)];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:strNormal];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
    
    textAttachment.image = [UIImage imageNamed:@"emo_03"];
    
    NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment] ;
    
    [string insertAttributedString:textAttachmentString atIndex:0];
    [string insertAttributedString:textAttachmentString atIndex:0];
    [string insertAttributedString:textAttachmentString atIndex:0];
    _lblTest.attributedText = string;
}
@end
