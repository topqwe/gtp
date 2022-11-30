//
//  PHTagView.m
//  TagUtilViews
//
//  Created by WIQChen on 16/8/23.
//  Copyright © 2016年 WIQ. All rights reserved.
//

#import "PHRectTagView.h"

@implementation PHRectTagView
-(instancetype)initBtnWithFrame:(CGRect)frame isFixedBtnWidth:(BOOL)isFixed withTitleArray:(NSArray*)titleArray{
    if (self = [super initWithFrame:frame]) {
        _btns = [NSMutableArray array];
        
        CGFloat lRMargin = 7.f;
        CGFloat uDMargin = 18.f;
        CGFloat midMargin = 15.f;
        int itmesInLines = (IS_IPHONE4 || IS_IPHONE5)?3:4;
        CGFloat btnWith = (MAINSCREEN_WIDTH -2*lRMargin -(itmesInLines-1)*midMargin)/itmesInLines;
        
        CGFloat btnHeight = 30.f;
        
        int width = 0;
        int height = 0;
        int number = 0;
        int han = 0;
        if ([titleArray isKindOfClass:[NSArray class]]) {
            //创建button
            for (int i = 0; i < titleArray.count; i++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.tag =  i;
                
                if (isFixed) {
                    button.frame = CGRectMake((i%itmesInLines+1)==1?lRMargin+i%itmesInLines*btnWith:lRMargin+(i%itmesInLines)*midMargin+i%itmesInLines*btnWith, ((i/itmesInLines)+1)*uDMargin+(i/itmesInLines)*btnHeight, btnWith, btnHeight);
                }else{
                    CGSize titleSize = [titleArray[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
                    titleSize.width += 20;
                    //自动的折行
                    han = han +titleSize.width+10;
                    if (han > MAINSCREEN_WIDTH) {
                        han = 0;
                        han = han + titleSize.width;
                        height++;
                        width = 0;
                        width = width+titleSize.width;
                        number = 0;
                        button.frame = CGRectMake(10, 50*height, titleSize.width, 30);
                    } else {
                        button.frame = CGRectMake(width+10+(number*10), 50*height, titleSize.width, 30);
                        width = width+titleSize.width;
                    }
                    number++;
                }
                
                
                
                
                
                
                
                button.titleLabel.font = [UIFont systemFontOfSize:13];
                button.layer.masksToBounds = YES;
                button.layer.cornerRadius = 5;
                button.layer.borderWidth = 0.5;
                button.layer.borderColor = RGBCOLOR(225, 218, 216).CGColor;
                [button setTitle:titleArray[i] forState:UIControlStateNormal];
                [button setTitleColor:RGBCOLOR(168, 154, 150) forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                
                [button setBackgroundImage:[PHRectTagView imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
                [button setBackgroundImage:[PHRectTagView imageWithColor:[UIColor redColor]] forState:UIControlStateSelected];
                
                //button.backgroundColor = [UIColor clearColor];
                
                
                button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
                
                [self addSubview:button];
                [_btns addObject:button];
            }
            UIButton* tagBtn = (UIButton*)[self viewWithTag:titleArray.count-1];
            CGRect vframe = self.frame;
            vframe.size.height = tagBtn.frame.origin.y+tagBtn.frame.size.height;
            self.frame =  vframe;
        }

    }
    return self;
}
+(UIView *)creatBtnWithFrame:(CGRect)frame isFixedBtnWidth:(BOOL)isFixed withTitleArray:(NSArray*)titleArray{
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, frame.origin.y, frame.size.width, 0)];
    view.backgroundColor = [UIColor whiteColor];
    
    CGFloat lRMargin = 7.f;
    CGFloat uDMargin = 18.f;
    CGFloat midMargin = 15.f;
    int itmesInLines = (IS_IPHONE4 || IS_IPHONE5)?3:4;
    CGFloat btnWith = (MAINSCREEN_WIDTH -2*lRMargin -(itmesInLines-1)*midMargin)/itmesInLines;
    
    CGFloat btnHeight = 30.f;
    
    int width = 0;
    int height = 0;
    int number = 0;
    int han = 0;
    if ([titleArray isKindOfClass:[NSArray class]]) {
        //创建button
        for (int i = 0; i < titleArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag =  i;
            
            if (isFixed) {
                button.frame = CGRectMake((i%itmesInLines+1)==1?lRMargin+i%itmesInLines*btnWith:lRMargin+(i%itmesInLines)*midMargin+i%itmesInLines*btnWith, ((i/itmesInLines)+1)*uDMargin+(i/itmesInLines)*btnHeight, btnWith, btnHeight);
            }else{
                CGSize titleSize = [titleArray[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
                titleSize.width += 20;
                //自动的折行
                han = han +titleSize.width+10;
                if (han > MAINSCREEN_WIDTH) {
                    han = 0;
                    han = han + titleSize.width;
                    height++;
                    width = 0;
                    width = width+titleSize.width;
                    number = 0;
                    button.frame = CGRectMake(10, 50*height, titleSize.width, 30);
                } else {
                    button.frame = CGRectMake(width+10+(number*10), 50*height, titleSize.width, 30);
                    width = width+titleSize.width;
                }
                number++;
            }
            
            
            
            
            
            
            
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 5;
            button.layer.borderWidth = 0.5;
            button.layer.borderColor = RGBCOLOR(225, 218, 216).CGColor;
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:RGBCOLOR(168, 154, 150) forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            
            [button setBackgroundImage:[PHRectTagView imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [button setBackgroundImage:[PHRectTagView imageWithColor:[UIColor redColor]] forState:UIControlStateSelected];
            
            //button.backgroundColor = [UIColor clearColor];
            
            
            button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [button addTarget:self action:@selector(clickYammy:) forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:button];
        }
        UIButton* tagBtn = (UIButton*)[view viewWithTag:titleArray.count-1];
        CGRect vframe = view.frame;
        vframe.size.height = tagBtn.frame.origin.y+tagBtn.frame.size.height;
        view.frame =  vframe;
    }
    
    return view;
}
- (void)clickItem:(UIButton*)button{
    
    NSString* btnTit = @"";
    button.selected = !button.selected;
    if (button.selected) {
        for (UIButton *btn in self.btns) {
            btn.selected = NO;
        }
        UIButton *tagBtn = [self.btns objectAtIndex:button.tag];
        tagBtn.selected = YES;
        
        btnTit = button.titleLabel.text;
    } else {
        btnTit = @"";
    }

    if (self.clickSectionBlock) {
        self.clickSectionBlock(button.tag,btnTit);
        //.clickSectionBlock = ^(NSInteger *sec, NSString* btnTit){
    }
}
+ (void)clickYammy:(UIButton*)sender{
    NSLog(@"%ld",(long)sender.tag);
    [YKToastView showToastText:[NSString stringWithFormat:@"%ld, %@",(long)sender.tag,sender.titleLabel.text]];
}

+(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
