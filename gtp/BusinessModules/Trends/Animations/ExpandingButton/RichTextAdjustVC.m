//
//  TestNavControllerVC.m
//  TextTest
//
//  Created by ren on 15/10/21.
//  Copyright © 2015年 ren. All rights reserved.
//

#import "RichTextAdjustVC.h"

@interface RichTextAdjustVC ()

@end

@implementation RichTextAdjustVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"RichTextAdjustVC";
    [_lblTest setPreferredMaxLayoutWidth:[UIScreen mainScreen].bounds.size.width];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"Using NSAttributed String To be or not to be ,That's a question!"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,5)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,12)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:30.0] range:NSMakeRange(0, 5)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:38] range:NSMakeRange(6, 12)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Courier-BoldOblique" size:30.0] range:NSMakeRange(19, 6)];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:str];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
    
    textAttachment.image = [UIImage imageNamed:@"emo_03"];
    
    NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment] ;
    
    [string insertAttributedString:textAttachmentString atIndex:0];
      [string insertAttributedString:textAttachmentString atIndex:0];
      [string insertAttributedString:textAttachmentString atIndex:0];
    _lblTest.attributedText = string;
    // Do any additional setup after loading the view from its nib.
}



@end
