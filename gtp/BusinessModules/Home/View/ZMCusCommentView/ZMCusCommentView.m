//
//  ZMCusCommentView.m
//  ZM
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 Kennith. All rights reserved.
//

#import "ZMCusCommentView.h"
#import "ZMCusCommentListView.h"
#import "ZMCusCommentToolView.h"
#import "AppDelegate.h"
#import "WTBottomInputView.h"
#define TOOL_VIEW_HEIGHT 47

@interface ZMCusCommentView()<WTBottomInputViewDelegate>

@property (nonatomic, strong) WTBottomInputView * bottomView;

@property (nonatomic, strong) WTBottomInputView * rebottomView;
@property (nonatomic, strong) UIControl *maskView;
@property (nonatomic, strong) ZMCusCommentListView *commentListView;
@property (nonatomic, strong)ZMCusCommentListView
* replyListView;
@property (nonatomic, strong) HomeItem* item;
@property (nonatomic, strong) HomeItem* reitem;
@property (nonatomic, assign) NSInteger s;

@property (nonatomic, strong) UIControl *topMaskView;
@property (nonatomic, strong) NSString *historyText;
@property (nonatomic, assign) CGRect historyFrame;
@property (nonatomic, assign) BOOL isKeyBoardShow;
@property (nonatomic, strong) HomeVM *vm;
@property (nonatomic, copy) ActionBlock block;
@end

@implementation ZMCusCommentView
- (instancetype)initWithFrame:(CGRect)frame withData:(id)item{
    
    if ([super initWithFrame:frame]) {
        self.backgroundColor = RGBHexColor(0x000000, 0.5);
        //监听当键盘将要出现时
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        //监听当键将要退出时
         [[NSNotificationCenter defaultCenter] addObserver:self
                                                  selector:@selector(keyboardWillHide:)
                                                      name:UIKeyboardWillHideNotification
                                                    object:nil];
        self.item = item;
        [self layoutUI];
        
    }
    return self;
}
- (void)layoutUI{
    
    self.userInteractionEnabled = true;
    
    @weakify(self)
    _maskView = [[UIControl alloc] initWithFrame:self.frame];
    _maskView.backgroundColor = [UIColor clearColor];
    [_maskView addTarget:self action:@selector(maskViewClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
        
    }];

    _commentListView = [[ZMCusCommentListView alloc] initWithFrame:CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH, 0)];
    
    self.s = 0;
    [_commentListView richHeaderText:0 withData:self.item];
    [self addSubview:_commentListView];
    
    _commentListView.closeBtnBlock = ^{
        @strongify(self)
        [self hideView];
    };
    _commentListView.titleBtnBlock = ^{
        @strongify(self)
        [self hideView];
    };
    _commentListView.sendBtnBlock = ^(NSString *text){
        @strongify(self)
        NSLog(@"%@",text);
        [self endEdit];
    };
    
    _commentListView.replyBtnBlock = ^(NSDictionary* dic) {
        @strongify(self)
        NSLog(@"回复A某人");
        self.s = 1;
        HomeItem* data = dic.allValues[0];
        self.reitem = data;
        
        [self showReplyView];
        
        self.rebottomView = [[WTBottomInputView alloc]init];
        [self addSubview:self.rebottomView];
        self.rebottomView.delegate = self;
        
//        NSDictionary* dic =  @{itemData:s}
        
        NSString* str = dic.allKeys[0];
        if (str.length>0) {
            self.rebottomView.textView.placeholder = [NSString stringWithFormat:@"回复 %@",data.nickname];
            [self.rebottomView.textView becomeFirstResponder];
        }else{
            self.rebottomView.textView.placeholder = @"请输入要说的话";
        }
//        self.bottomView.textView.placeholder = [NSString stringWithFormat:@"@%@",data.nickname];
    };
    
    _commentListView.scrollBlock = ^{
        @strongify(self)
        [self.bottomView resignFirstResponder];
    };
    
    
    self.bottomView = [[WTBottomInputView alloc]init];
    [self addSubview:self.bottomView];
    self.bottomView.textView.placeholder = @"请输入要说的话";
//    [self.bottomView becomeFirstResponder];
//    [self.bottomView showView];
    self.bottomView.delegate = self;
//    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
//    [keyWindow addSubview:self.bottomView];
    
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    [swipeGestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [self addGestureRecognizer:swipeGestureRecognizer];


}

//展示Reply界面
- (void)showReplyView{
    ZMCusCommentListView
    * replyListView = [[ZMCusCommentListView alloc] initWithFrame:CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH, 0)];
    
    [replyListView richHeaderText:self.s withData:self.reitem];
    self.replyListView = replyListView;
    [self addSubview:replyListView];
    [UIView animateWithDuration:0.2 animations:^{
//        self.commentListView.backgroundColor = kClearColor;
        replyListView.frame = CGRectMake(0, ZMCusCommentViewTopMargin, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT -ZMCusCommentViewTopMargin);;
        
    } completion:^(BOOL finished) {
        
    }];
    replyListView.replyBtnBlock = ^(NSDictionary* dic) {
//        self.replyListView.item = self.item;
        NSLog(@"回复某人");
        self.rebottomView.delegate = self;
        
        HomeItem* data = dic.allValues[0];
        NSString* str = dic.allKeys[0];
        if (str.length>0) {
            
            self.rebottomView.textView.placeholder = [NSString stringWithFormat:@"回复 %@",data.nickname];
            [self.rebottomView.textView becomeFirstResponder];
        }
    };
    replyListView.closeBtnBlock = ^{
        [self hideReplyView];
    };
    replyListView.titleBtnBlock = ^{
        [self hideReplyView];
    };
}
//关闭Reply界面
- (void)hideReplyView{

    self.s = 0;
    [self.commentListView richHeaderText:self.s withData:self.item];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.replyListView.frame = CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        [self.rebottomView removeFromSuperview];
//        [[NSNotificationCenter defaultCenter] removeObserver:self];
//        [self removeFromSuperview];
    }];

}

- (void)WTBottomInputViewSendTextMessage:(NSString *)message
{
    NSLog(@"=======>>%@",message);
    
    NSMutableDictionary * paramDic = [NSMutableDictionary dictionary];
    paramDic[@"content"] = message;
    paramDic[@"subContent"] = @"王加水_RollingPin";
    
//    [_dataSource insertObject:paramDic atIndex:0];
//    [_tableView reloadData];
//    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.vm network_postCRWithRequestParams:[NSString stringWithFormat:@"%@",message] WithHomeItem:self.s == 0?self.item :self.reitem WithSource:self.s success:^(id data) {
        if (self.s == 0) {
            [self.commentListView richHeaderText:self.s withData:self.item];
        }else{
            [self.replyListView richHeaderText:self.s withData:self.reitem];
        }
        if (self.block) {
            self.block(@"1");
        }
    
    } failed:^(id data) {
        
    }];
    
    self.bottomView.textView.text = @"";
    self.rebottomView.textView.text = @"";
    [self endEdit];
}
#pragma mark - action
- (void)endEdit{
    [self endEditing:YES];

    self.commentListView.toolView.textView.placeholder = @"你也来聊两句吧";
    [UIView animateWithDuration:0.3 animations:^{
        self.commentListView.toolView.frameHeight = ZMCusComentBottomViewHeight+YBFrameTool.iphoneBottomHeight;
        self.commentListView.toolView.frameY = MAINSCREEN_HEIGHT-ZMCusComentBottomViewHeight-YBFrameTool.iphoneBottomHeight-YBFrameTool.safeAdjustNavigationBarHeight;
    } completion:^(BOOL finished) {

    }];
}
//关闭整个视图
- (void)maskViewClick{
    [self endEdit];
    [self hideView];
}

//关闭界面
- (void)hideView{

    [UIView animateWithDuration:0.2 animations:^{
        self.commentListView.frame = CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self removeFromSuperview];
    }];

}
//展示界面
- (void)showView{
    
    [UIView animateWithDuration:0.2 animations:^{
//        self.commentListView.backgroundColor = kClearColor;
        self.commentListView.frame = CGRectMake(0, ZMCusCommentViewTopMargin, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT -ZMCusCommentViewTopMargin);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"swipe down");
        [self hideView];
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"swipe up");
        
    }

}
//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    self.topMaskView.hidden = NO;
    CGFloat y = MAINSCREEN_HEIGHT-keyboardRect.size.height-ZMCusCommentEditToolViewHeight-YBFrameTool.safeAdjustNavigationBarHeight;
    self.commentListView.toolView.keyboardHeight = keyboardRect.size.height;
    self.commentListView.toolView.defaultY = y;
    self.commentListView.toolView.defaultHeight = ZMCusCommentEditToolViewHeight;
    [UIView animateWithDuration:0.3 animations:^{
        self.commentListView.toolView.frameHeight = ZMCusCommentEditToolViewHeight;
        self.commentListView.toolView.frameY = y;
    }];
}
//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    self.topMaskView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.commentListView.toolView.frameHeight = ZMCusComentBottomViewHeight+YBFrameTool.iphoneBottomHeight;
        self.commentListView.toolView.frameY = MAINSCREEN_HEIGHT-ZMCusComentBottomViewHeight-YBFrameTool.iphoneBottomHeight-YBFrameTool.safeAdjustNavigationBarHeight;
    }];
    
    
}
- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
- (HomeVM *)vm {
    if (!_vm) {
        _vm = [HomeVM new];
    }
    return _vm;
}
@end
@interface ZMCusCommentManager()
@property (nonatomic, copy) DataBlock block;
@end
@implementation ZMCusCommentManager
+(instancetype)shareManager{
    static ZMCusCommentManager *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[ZMCusCommentManager alloc] init];
    });
    return instance;
}
- (void)showCommentWithSourceId:(id)sourceId success:(DataBlock)block{
    
    ZMCusCommentView *view = [[ZMCusCommentView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT) withData:sourceId];
    view.item = sourceId;
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:view];
    [view showView];
    self.block = block;
    [view actionBlock:^(id data) {
//          self.block(id data)
        if (self.block) {
            self.block(data);
        }
    }];
    
}
@end
