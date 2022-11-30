//
//  STTableViewDetailController.m
//  ZuoBiao
//
//  Created by stoneobs on 17/2/17.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "STTableViewDetailController.h"
#define UIScreenWidth [UIScreen mainScreen].bounds.size.width
#define STRGB(v)     [UIColor colorWithRed:((float)((v & 0xFF0000) >> 16))/255.0 green:((float)((v & 0xFF00) >> 8))/255.0  blue:((float)(v & 0xFF))/255.0 alpha:1]
@interface STTableViewDetailController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) NSString                      *placeholder;
@property(nonatomic,copy)  STTableViewDetailComplete        complete;
@property(nonatomic,strong)UILabel                       *numLabel;//数量label
@property(nonatomic,strong)UITableView                   *tableView;
@end

@implementation STTableViewDetailController

- (instancetype)initWithPlaceholder:(NSString *)placeholder
                              title:(NSString *)title
                               text:(NSString *)text
                           complete:(STTableViewDetailComplete)complete{
    if (self == [super init]) {
        self.textFiled.placeholder = placeholder;
        self.textFiled.text = text;
        self.textFiled.autocorrectionType = UITextAutocorrectionTypeNo;
        self.navigationItem.title = title;
        _complete = complete;
        self.maxTextNum = 2000;
        //导航
        [self setRightItemWithTitle:@"保存"
                         titleColor:UIColor.whiteColor];
    }
    return self;
}
- (UITextField *)textFiled
{
    if (_textFiled) {
        return _textFiled;
    }
    _textFiled = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, UIScreenWidth - 30, 40)];
    _textFiled.delegate = self;
    _textFiled.center = CGPointMake(_textFiled.center.x, 55/2);
    _textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textFiled.placeholder = _placeholder;
    _textFiled.returnKeyType = UIReturnKeySend;
    _textFiled.textColor = STRGB(0x333333);
    _textFiled.font = [UIFont systemFontOfSize:15];
    return _textFiled;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.backgroundColor = STRGB(0xf1f2f7);
    self.tableView.separatorColor = STRGB(0xE5E5E5);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 25)];
    footerView.backgroundColor = self.tableView.backgroundColor;
    self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(UIScreenWidth - 20 - 60, 5, 60, 15)];
    self.numLabel.text = [NSString stringWithFormat:@"%ld",self.maxTextNum];
    self.numLabel.textColor = STRGB(0x666666);
    self.numLabel.font = [UIFont systemFontOfSize:15];
    self.numLabel.textAlignment = NSTextAlignmentRight;
    [footerView addSubview:self.numLabel];
    self.numLabel.hidden = (_maxTextNum == 2000?YES:NO);
    self.tableView.tableFooterView = footerView;
    
    [self getTheNotifacation:@"UITextFieldTextDidChangeNotification"];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //textfiled 进入第一响应
    [self.textFiled becomeFirstResponder];
    self.numLabel.text = [NSString stringWithFormat:@"%ld",self.maxTextNum - self.textFiled.text.length];
}
- (void)setMaxTextNum:(NSInteger)maxTextNum{
    _maxTextNum = maxTextNum;
    self.numLabel.hidden = (maxTextNum == 2000?YES:NO);
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.textFiled resignFirstResponder];
}
- (void)setRightItemTitle:(NSString *)rightItemTitle{
    _rightItemTitle = rightItemTitle;
    [self setRightItemWithTitle:rightItemTitle titleColor:self.rightItemTitleColor];
}
- (void)setRightItemTitleColor:(UIColor *)rightItemTitleColor{
    _rightItemTitleColor = rightItemTitleColor;
    [self setRightItemWithTitle:_rightItemTitle titleColor:self.rightItemTitleColor];
}
- (void)setRightItemWithTitle:(NSString *)title titleColor:(UIColor*)color
{
    if (!color) {
        color = UIColor.whiteColor;
    }
    if (!title) {
        title = @"保存";
    }
    UIBarButtonItem * right =[[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightBarAction:)];
    [right setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, nil] forState:UIControlStateNormal];
        [right setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, nil] forState:UIControlStateHighlighted];
    right.tintColor = color;
    self.navigationItem.rightBarButtonItem = right;
}
- (void)rightBarAction:(id)sender
{

    //  NSString * text = [self.textFiled.text stringByReplacingOccurrencesOfString:@" " withString:@""];//去掉空格
    NSString * text = self.textFiled.text;
    if (!text.length) {
        text = @"";
    }
    if (_complete) {
        _complete(text,self);
    }
    
}
#pragma --mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * reuseIdentifier =  @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        
    }
    [cell addSubview:self.textFiled];
    return cell;
}
#pragma --mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark --UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        if (_complete) {
            _complete(self.textFiled.text,self);
        }
    }
    
    return YES;
}
#pragma mark --接受通知和处理
-(void)getTheNotifacation:(NSString*)notifacationName
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReciveNotifacationAction:) name:notifacationName object:nil];
    
}
-(void)didReciveNotifacationAction:(NSNotification*)object
{
    
    UITextField *textField = (UITextField *)object.object;
    if (textField == self.textFiled) {
//        if (self.textFiledDidChange ) {
//            self.textFiledDidChange(textField.text);
//        }
        NSString *toBeString = textField.text;
        NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage; // 键盘输入模式 // 键盘输入模式
        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，五笔，简体手写
            UITextRange *selectedRange = [textField markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                
                if (toBeString.length > self.maxTextNum) {
                    textField.text = [toBeString substringToIndex:self.maxTextNum];
                }
                NSInteger num = self.textFiled.text.length;
                self.numLabel.text = [NSString stringWithFormat:@"%ld",self.maxTextNum-num];
            }
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
            else{
                
            }
        }
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        else{
            
            if (toBeString.length > self.maxTextNum) {
                textField.text = [toBeString substringToIndex:self.maxTextNum];
            }
            NSInteger num = textField.text.length;
            self.numLabel.text = [NSString stringWithFormat:@"%ld",self.maxTextNum - num];
            
        }
        
    }
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

