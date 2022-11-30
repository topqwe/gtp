//
//  PHRoundTagView.m
//  TagUtilViews
//
//  Created by WIQChen on 16/8/23.
//  Copyright © 2016年 WIQ. All rights reserved.
//

#import "PHRoundTagView.h"

@implementation PHRoundTagView
-(instancetype)initWithFrame:(CGRect)frame withRoundWidthHeight:(CGFloat)roundWH withContentLabelHeight:(CGFloat)contentLabelHeight withRoundHorizonRangeToContent:(CGFloat)horizonRange withContenLabelSpace:(CGFloat)contentLabelSpace withTitleArray:(NSArray*)titleArray  isHidePerforativeLineView:(BOOL)isHidenLine{
    if (self = [super initWithFrame:frame]) {
        for (int i=0; i<titleArray.count; i++) {
            
            NSString* title = titleArray[i];
            CGFloat  contentHeight =
            [NSString getContentHeightWithParagraphStyleLineSpacing:3 fontWithString:title fontOfSize:15 boundingRectWithWidth:MAINSCREEN_WIDTH-(frame.origin.x+roundWH+horizonRange)-2*frame.origin.x];
            
            UIButton* contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            contentBtn.tag = LABEL_ADD_TAG+i;
            
            contentBtn.titleLabel.font = kFontSize(15);
            [contentBtn setTitle:titleArray[i] forState:UIControlStateNormal];
            [contentBtn setTitleColor:RGBCOLOR(100, 83, 79) forState:UIControlStateNormal];
            contentBtn.backgroundColor = [UIColor clearColor];
            contentBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            contentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            //        UILabel* contentBtn = [[UILabel alloc]init];
            //        contentBtn.font = [UIFont systemFontOfSize:15];
            //        contentBtn.text = titleArray[i];
            //        contentBtn.textColor = RGBCOLOR(100, 83, 79);
            //        contentBtn.textAlignment=NSTextAlignmentLeft;
            //        contentBtn.numberOfLines=0;
            
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineSpacing = 3;
            NSDictionary *attributes = @{
                                         NSFontAttributeName:contentBtn.titleLabel.font,
                                         NSParagraphStyleAttributeName:paragraphStyle,
                                         NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],
                                         NSFontAttributeName:kFontSize(15),
                                         NSUnderlineColorAttributeName:[UIColor redColor]
                                         ,NSForegroundColorAttributeName:[UIColor greenColor]};
            contentBtn.titleLabel.attributedText = [[NSAttributedString alloc]initWithString:title attributes:attributes];
            contentBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
            
            contentBtn.frame = CGRectMake(frame.origin.x+roundWH+horizonRange, (i+1)*contentLabelSpace+i*contentHeight , MAINSCREEN_WIDTH-(frame.origin.x+roundWH+horizonRange)-2*frame.origin.x, contentHeight);
            
            
            
            
            
            [self addSubview:contentBtn];
            if (contentBtn.tag>LABEL_ADD_TAG+0) {
                UILabel* preLab = (UILabel*)[self viewWithTag:contentBtn.tag-1];
                contentBtn.frame =CGRectMake(contentBtn.frame.origin.x, CGRectGetMaxY(preLab.frame) + contentLabelSpace, contentBtn.frame.size.width, contentBtn.frame.size.height) ;
                [contentBtn addTarget:self action:@selector(runTimeClick:) forControlEvents:UIControlEventTouchUpInside];
                contentBtn.custom_acceptEventInterval = 1;
            }else{
                [contentBtn addTarget:self action:@selector(beginClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            
            CGFloat content_round_vactial = (contentHeight- roundWH)/2;
            
            UIImageView* roundImage = [[UIImageView alloc]init];
            roundImage.frame = CGRectMake(frame.origin.x, contentBtn.frame.origin.y + (contentBtn.frame.size.height - roundWH)/2,roundWH,roundWH);
            roundImage.tag = ROUND_ADD_TAG+i;
            roundImage.layer.cornerRadius = roundImage.frame.size.width/2;
            roundImage.layer.borderColor = [UIColor clearColor].CGColor;
            roundImage.layer.borderWidth = 0.0f;
            roundImage.layer.masksToBounds = YES;
            roundImage.backgroundColor = RGBCOLOR(100, 83, 79);
            [self addSubview:roundImage];
            
            UIImageView* perforativeLineView = [[UIImageView alloc]initWithFrame:CGRectMake(roundImage.frame.origin.x+(roundImage.frame.size.width-1)/2, roundImage.frame.origin.y+roundImage.frame.size.height, 1, (content_round_vactial+contentLabelSpace)+content_round_vactial)];
            perforativeLineView.backgroundColor = RGBSAMECOLOR(242);
            perforativeLineView.tag = i+LINE_ADD_TAG;
            perforativeLineView.hidden = isHidenLine;
            [self addSubview:perforativeLineView];
            
            
        }
        UIImageView* lastPerforativeLineView = (UIImageView *)[self viewWithTag:(titleArray.count-1)+LINE_ADD_TAG];
        lastPerforativeLineView.hidden = YES;
        
        UILabel* lastContentLab = (UILabel*)[self viewWithTag:(titleArray.count-1)+LABEL_ADD_TAG];
        
        self.frame =  CGRectMake(self.frame.origin.x, self.frame.origin.y, MAINSCREEN_WIDTH, lastContentLab.frame.size.height + lastContentLab.frame.origin.y);
    }
    return self;
}
- (void)runTimeClick:(UIButton*)sender{
    [YKToastView showToastText:[NSString stringWithFormat:@"runtime%ld, %@",(long)sender.tag,sender.titleLabel.text]];
    NSLog(@"........runtime%ld",(long)sender.tag);
}

- (void)beginClick:(UIButton*)btn{
    if (_aLockList) {
        _aLockList.lock = YES;
    }
    PHLockClick *thisLock = [PHLockClick new];
    thisLock.lock = NO;
    thisLock.senderTag = btn.tag;
    thisLock.lastLock = _aLockList;
    _aLockList = thisLock;
    [self performSelector:@selector(executeMethod:) withObject:thisLock afterDelay:1.0f];
    
}

- (void)executeMethod:(PHLockClick *)thisLock
{
    if (!thisLock.lock) {
        while (_aLockList.lastLock) {
            
            PHLockClick *thisList = _aLockList.lastLock;
            _aLockList.lastLock = nil;
            _aLockList = thisList;
        }
        [YKToastView showToastText:[NSString stringWithFormat:@"while%ld",(long)thisLock.senderTag]];
        NSLog(@"........while%ld",thisLock.senderTag);
    }
}

+(UIView *)creatRoundTagViewWithFrame:(CGRect)frame withRoundWidthHeight:(CGFloat)roundWH withContentLabelHeight:(CGFloat)contentLabelHeight withRoundHorizonRangeToContent:(CGFloat)horizonRange withContenLabelSpace:(CGFloat)contentLabelSpace withTitleArray:(NSArray*)titleArray  isHidePerforativeLineView:(BOOL)isHidenLine{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0)];
    for (int i=0; i<titleArray.count; i++) {
        
        NSString* title = titleArray[i];
        CGFloat  contentHeight =
        [NSString getContentHeightWithParagraphStyleLineSpacing:3 fontWithString:title fontOfSize:15 boundingRectWithWidth:MAINSCREEN_WIDTH-(frame.origin.x+roundWH+horizonRange)-2*frame.origin.x];

        
        UIButton* contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        contentBtn.tag = LABEL_ADD_TAG+i;
        
        contentBtn.titleLabel.font = kFontSize(15);
        [contentBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        [contentBtn setTitleColor:RGBCOLOR(100, 83, 79) forState:UIControlStateNormal];
        contentBtn.backgroundColor = [UIColor clearColor];
        contentBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        contentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
//        UILabel* contentBtn = [[UILabel alloc]init];
//        contentBtn.font = [UIFont systemFontOfSize:15];
//        contentBtn.text = titleArray[i];
//        contentBtn.textColor = RGBCOLOR(100, 83, 79);
//        contentBtn.textAlignment=NSTextAlignmentLeft;
//        contentBtn.numberOfLines=0;
        
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = 3;
        NSDictionary *attributes = @{
                                     NSFontAttributeName:contentBtn.titleLabel.font,
                                      NSParagraphStyleAttributeName:paragraphStyle,
                                     NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],
                                     NSFontAttributeName:kFontSize(15),
                                     NSUnderlineColorAttributeName:[UIColor lightGrayColor]
                                     ,NSForegroundColorAttributeName:[UIColor lightGrayColor]};
        contentBtn.titleLabel.attributedText = [[NSAttributedString alloc]initWithString:title attributes:attributes];
        contentBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        
        contentBtn.frame = CGRectMake(frame.origin.x+roundWH+horizonRange, (i+1)*contentLabelSpace+i*contentHeight , MAINSCREEN_WIDTH-(frame.origin.x+roundWH+horizonRange)-2*frame.origin.x, contentHeight);
         [contentBtn addTarget:self action:@selector(clickYammy:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:contentBtn];
        if (contentBtn.tag>LABEL_ADD_TAG+0) {
            UILabel* preLab = (UILabel*)[view viewWithTag:contentBtn.tag-1];
            contentBtn.frame =CGRectMake(contentBtn.frame.origin.x, CGRectGetMaxY(preLab.frame) + contentLabelSpace, contentBtn.frame.size.width, contentBtn.frame.size.height) ;
        }
        
        
        CGFloat content_round_vactial = (contentHeight- roundWH)/2;
        
        UIImageView* roundImage = [[UIImageView alloc]init];
        roundImage.frame = CGRectMake(frame.origin.x, contentBtn.frame.origin.y + (contentBtn.frame.size.height - roundWH)/2,roundWH,roundWH);
        roundImage.tag = ROUND_ADD_TAG+i;
        roundImage.layer.cornerRadius = roundImage.frame.size.width/2;
        roundImage.layer.borderColor = [UIColor clearColor].CGColor;
        roundImage.layer.borderWidth = 0.0f;
        roundImage.layer.masksToBounds = YES;
        roundImage.backgroundColor = RGBCOLOR(100, 83, 79);
        [view addSubview:roundImage];
        
        UIImageView* perforativeLineView = [[UIImageView alloc]initWithFrame:CGRectMake(roundImage.frame.origin.x+(roundImage.frame.size.width-1)/2, roundImage.frame.origin.y+roundImage.frame.size.height, 1, (content_round_vactial+contentLabelSpace)+content_round_vactial)];
        perforativeLineView.backgroundColor = RGBSAMECOLOR(242);
        perforativeLineView.tag = i+LINE_ADD_TAG;
        perforativeLineView.hidden = isHidenLine;
        [view addSubview:perforativeLineView];

        
    }
    UIImageView* lastPerforativeLineView = (UIImageView *)[view viewWithTag:(titleArray.count-1)+LINE_ADD_TAG];
    lastPerforativeLineView.hidden = YES;
    
    UILabel* lastContentLab = (UILabel*)[view viewWithTag:(titleArray.count-1)+LABEL_ADD_TAG];
    
    CGRect vframe = view.frame;
    vframe.size.height = lastContentLab.frame.size.height + lastContentLab.frame.origin.y;
    view.frame =  vframe;
    
    return view;
}

+ (void)clickYammy:(UIButton*)sender{
    [YKToastView showToastText:[NSString stringWithFormat:@"%ld, %@",(long)sender.tag,sender.titleLabel.text]];
    NSLog(@".......+%ld",(long)sender.tag);
}
@end
