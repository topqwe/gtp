//
//  InputPWPopUpView.m
//  HHL
//
//  Created by WIQ on 2018/12/30.
//  Copyright © 2018 GT. All rights reserved.
//

#import "BottomListPopUpView.h"
#import "WebViewController.h"
#define XHHTuanNumViewHight 347//347 //283+64
@interface BottomListPopUpViewCell : UITableViewCell
- (void)actionBlock:(DataBlock)block;
+ (CGFloat)cellHeightWithModel:(id)model;
+(instancetype)cellWith:(UITableView*)tabelView;
- (void)richElementsInCellWithModel:(id)model atIndexPath:(NSIndexPath *)indexPath;
@end

@interface BottomListPopUpViewCell ()

@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, strong) NSMutableArray *funcBtns;
@end

@implementation BottomListPopUpViewCell
- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _funcBtns = [NSMutableArray array];
        [self richEles];
    }
    return self;
}


- (void)richEles{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
//    _titleBtn = [[UIButton alloc] init];
//    [self.contentView addSubview:self.titleBtn];
////    _titleBtn.frame = CGRectMake(_nameBtn.frame.origin.x, [[self class]cellHeightWithModel]-6*10, _nameBtn.frame.size.width, 50);
//    [_titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView.mas_top).offset(0);
//        make.left.equalTo(self.contentView.mas_left).offset(13);
////        make.height.equalTo(@50);
//        make.centerX.equalTo(self.contentView);
////        make.bottom.equalTo(self.contentView.mas_bottom);
//    }];
////    _titleBtn.layer.masksToBounds = true;
////    _titleBtn.layer.cornerRadius = 8;
//    _titleBtn.userInteractionEnabled = NO;
//    _titleBtn.backgroundColor = [UIColor clearColor];
//    [_titleBtn setTitleColor:HEXCOLOR(0x8FAEB7) forState:0];
//    _titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    _titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    _titleBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    NSArray* subtitleArray =@[
    @{@"1":[UIImage imageNamed:@"operation"]},
    @{@"2":[UIImage imageNamed:@"operYes"]}
    ];
    for (int i = 0; i < subtitleArray.count; i++) {
//        NSDictionary* dic = subtitleArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  i+8000;
        button.userInteractionEnabled = NO;
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = kFontSize(15);
//        button.layer.masksToBounds = YES;
//        button.layer.cornerRadius = 8;
//        button.layer.borderWidth = 0;
        [button setTitleColor:HEXCOLOR(0x8FAEB7) forState:UIControlStateNormal];
        if (i== 0) {
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }else{
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        [button setTitle:dic.allKeys[0] forState:UIControlStateNormal];
//        [button setBackgroundImage:dic.allValues[0] forState:UIControlStateNormal];
//        button.backgroundColor = YBGeneralColor.themeColor;
//        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:20];
//        [button addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        [_funcBtns addObject:button];
    }
    
    [_funcBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:12 leadSpacing:18 tailSpacing:18];
    
    [_funcBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.height.equalTo(@60);
    }];
}

+(instancetype)cellWith:(UITableView*)tabelView{
    BottomListPopUpViewCell *cell = (BottomListPopUpViewCell *)[tabelView dequeueReusableCellWithIdentifier:@"BottomListPopUpViewCell"];
    if (!cell) {
        cell = [[BottomListPopUpViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BottomListPopUpViewCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel:(id)model{
    return 65;
}

- (void)richElementsInCellWithModel:(id)model atIndexPath:(NSIndexPath *)indexPath{
    if ([model isKindOfClass:[MinePayMethod class]]) {
        MinePayMethod* item = model;
        
        UIButton* btn0 = _funcBtns[0];
        [btn0 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"m_method%@",item.payMent]] forState:0];
        
        UIButton* btn1 = _funcBtns[1];
        [btn1 setTitle:[NSString stringWithFormat:@"使用%@好的",item.name] forState:0];
        
//        [btn1 layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
    }
    
}
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//}

@end

@interface BottomListPopUpView()<UIGestureRecognizerDelegate,UITextViewDelegate,UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sections;

@property (nonatomic,strong)NSArray * letter;
@property(nonatomic,strong)UIView *contentView;
@property (nonatomic, strong) UIImageView *line1;
@property (nonatomic, strong) NSMutableArray* leftLabs;

@property (nonatomic, strong) NSMutableArray* rightTfs;
@property (nonatomic, strong) UIButton *postAdsButton;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, assign) CGFloat contentViewHeigth;
@property (nonatomic, strong)NSIndexPath* selectedIndexPath;
@property (nonatomic, strong) id selectedItem;
@property (nonatomic, copy) NSString* sTit;
@property (nonatomic,copy)NSString * pickStr;
@end

@implementation BottomListPopUpView

- (id)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        [self setupContent];
    }
    
    return self;
}

- (void)setupContent {
    _leftLabs = [NSMutableArray array];
    _rightTfs = [NSMutableArray array];
    
    self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    _contentViewHeigth = XHHTuanNumViewHight+[YBFrameTool tabBarHeight];
    if (_contentView == nil) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, MAINSCREEN_HEIGHT - _contentViewHeigth, MAINSCREEN_WIDTH, _contentViewHeigth)];
        _contentView.userInteractionEnabled = YES;
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _contentView.bounds;
        maskLayer.path = maskPath.CGPath;
        _contentView.layer.mask = maskLayer;
        
        // 左上角关闭按钮
        UIButton *saftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saftBtn.frame = CGRectMake(0, 0, _contentView.width, 47);
        saftBtn.titleLabel.font = kFontSize(14);
        [saftBtn setTitleColor:HEXCOLOR(0x8FAEB7) forState:UIControlStateNormal];
        [saftBtn setTitle:@"" forState:UIControlStateNormal];
        saftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        saftBtn.tag = 9;
        [_contentView addSubview:saftBtn];
//        saftBtn.hidden = YES;
        
        // 右上角关闭按钮
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(_contentView.width -  90, 0, 90, 47);
        closeBtn.titleLabel.font = kFontSize(17);
        [closeBtn setTitleColor:YBGeneralColor.themeColor forState:UIControlStateNormal];
//        [closeBtn setTitle:@"X" forState:UIControlStateNormal];//取消
        [closeBtn setImage:kIMG(@"M_X") forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(disMissView) forControlEvents:UIControlEventTouchUpInside];
//        [closeBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postAdsAndRuleButtonClickItem:)]];
        [_contentView addSubview:closeBtn];
        _line1 = [[UIImageView alloc]init];
        [self.contentView addSubview:_line1];
        _line1.backgroundColor = HEXCOLOR(0xe8e9ed);
        _line1.hidden =true;

        [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
            make.top.offset(47);
            make.height.equalTo(@.5);
        }];
        
        [self layoutAccountPublic];
        
        
    }
    
}

-(void)layoutAccountPublic{
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-60);
        make.top.equalTo(self.contentView).offset(50);
        make.left.equalTo(self.contentView).offset(0);
        make.center.equalTo(self.contentView);
    }];
    
}
#pragma mark - <UITableViewDataSource, UITableViewDelegate>
#pragma mark - Sectons
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sections.count;
}
#pragma mark - Rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(_sections[section]) count];
}
#pragma mark - SectonHeader
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 75.0f;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];

    view.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, 75);
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] init];
    
    btn.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    NSArray *titles = @[self.sTit];
    [btn setAttributedTitle:[NSString attributedStringWithString:[NSString stringWithFormat:@"%@",titles[section]] stringColor:HEXCOLOR(0x000000) stringFont:[UIFont boldSystemFontOfSize:40] subString:[NSString stringWithFormat:@"%@  元",@""] subStringColor:HEXCOLOR(0x000000) subStringFont:kFontSize(15) paragraphStyle:NSTextAlignmentCenter] forState:UIControlStateNormal];

    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [view addSubview:btn];
    
    
    UIButton* zBtn = [[UIButton alloc]init];
    [btn addSubview:zBtn];
    zBtn.userInteractionEnabled = NO;
    [zBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(btn.mas_left).offset(15);
        make.top.equalTo(btn);
//        make.centerY.mas_equalTo(btn);
        make.height.mas_equalTo(btn);
        make.width.equalTo(@70);
    }];
    [zBtn setTitle:@"好的：" forState:0];
    zBtn.titleLabel.font = kFontSize(20);
    zBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    zBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [zBtn setTitleColor:kBlackColor forState:0];;
    
    return view;
}
#pragma mark - SectonFooter
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 85.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];

    view.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, 85);
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] init];
    
    btn.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    NSArray *titles = @[@"如有疑问，请联系 "];
    [btn setAttributedTitle:[NSString attributedStringWithString:[NSString stringWithFormat:@"%@",titles[section]] stringColor:HEXCOLOR(0x8FAEB7) stringFont:[UIFont boldSystemFontOfSize:14] subString:[NSString stringWithFormat:@"%@在线好了",@""] subStringColor:YBGeneralColor.themeColor subStringFont:kFontSize(14) paragraphStyle:NSTextAlignmentCenter] forState:UIControlStateNormal];

    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [btn addTarget:self action:@selector(pushService) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    return view;
}
- (void)pushService{
    ConfigModel *configModel = [ConfigModel mj_objectWithKeyValues:GetUserDefaultWithKey(@"ConfigModel")];
    if ([configModel getKFUrl].length>0) {
        id object = [self nextResponder];
        while (![object isKindOfClass:[UIViewController class]] && object != nil) {
            object = [object nextResponder];
        }
        UIViewController *superController = (UIViewController*)object;
//        [superController.navigationController  showViewController:vc sender:nil];
        
        [WebViewController pushFromVC:superController requestUrl:[configModel getKFUrl]  withProgressStyle:DKProgressStyle_Gradual success:^(id data) {
                        
        }];
    }
}
#pragma mark - cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BottomListPopUpViewCell *cell = [BottomListPopUpViewCell cellWith:tableView];
    [cell richElementsInCellWithModel:(_sections[indexPath.section])[indexPath.row] atIndexPath:indexPath];
    cell.tag = indexPath.row;
    UIButton* btn1 = [cell.contentView viewWithTag:8001];
    
    if (_selectedIndexPath) {
        if (_selectedIndexPath == indexPath) {
            [btn1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"editRecordSelected"]] forState:0];
        }else{
            [btn1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"editRecordDeselected"]] forState:0];
        }
    }else{
        if (cell.tag == 0) {
            [btn1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"editRecordSelected"]] forState:0];
            
        }else{
            [btn1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"editRecordDeselected"]] forState:0];
        }
    }
    [btn1 layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
    
    [cell actionBlock:^(id data) {
        NSLog(@"%@.....",data);
//        if (self.block) {
//            self.block(data);
//        }
//        [self disMissView];
    }];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id object = (_sections[indexPath.section])[indexPath.row];
    
    if (_selectedIndexPath) {
        
        BottomListPopUpViewCell* cell = [tableView cellForRowAtIndexPath:_selectedIndexPath];
        
        UIButton* btn1 = [cell.contentView viewWithTag:8001];
        [btn1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"editRecordDeselected"]] forState:0];
    }
    
    BottomListPopUpViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton* btn1 = [cell.contentView viewWithTag:8001];
    [btn1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"editRecordSelected"]] forState:0];
    
    
    if (indexPath.row !=0) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        BottomListPopUpViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        
        UIButton* btn1 = [cell.contentView viewWithTag:8001];
        [btn1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"editRecordDeselected"]] forState:0];
    }
    [btn1 layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
    
    _selectedIndexPath = indexPath;
    _selectedItem = object;
//    if (self.block) {
//        self.block(object);
//    }
}
#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BottomListPopUpViewCell cellHeightWithModel:(_sections[indexPath.section])[indexPath.row]];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView YBGeneral_configuration];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)sections {
    if (!_sections) {
        _sections = [NSMutableArray array];
    }
    return _sections;
}

- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}

- (void)funAdsButtonClickItem:(UIButton*)btn{
    if (btn.tag -100 == 0) {
        [self disMissView];
    }else{
        
    }
    if (self.block) {
        self.block(@(btn.tag-100));
    }
    
//    [self disMissView];
}

- (void)richElementsInViewWithModel:(NSArray*)model withTitle:(NSString*)tit withSectionHeaderTitle:(NSString*)sTit{
    if (model == nil||model.count == 0) {
        return;
    }
//    self.model = model;
    self.sTit = sTit;
    [self.sections addObjectsFromArray:model];
    [self.tableView reloadData];
    
    UIButton* titBtn = [_contentView viewWithTag:9];
    [titBtn setTitle:tit forState:UIControlStateNormal];
    [self.contentView bottomSingleButtonInSuperView:self.contentView WithButtionTitles:@"确定" withBottomMargin:YBFrameTool.iphoneBottomHeight isHidenLine:YES leftButtonEvent:^(id data) {
        if (self.block) {
            self.block(self.selectedItem!=nil?self.selectedItem:model.firstObject[0]);
        }
    }];
}


- (void)postAdsAndRuleButtonClickItem:(UITapGestureRecognizer*)sender{
    
//    if (self.block) {
//        self.block(@(sender.view.tag));
//    }
    
    NSInteger i = 0;
    
    
    
    if (self.block) {
        self.block(@(i));
    }
    [self disMissView];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

- (void)showInView:(UIView *)view {
    if (!view) {
        return;
    }
    
    [view addSubview:self];
    [view addSubview:_contentView];
    
    [_contentView setFrame:CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH, _contentViewHeigth)];
    WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.alpha = 1.0;
        
        [weakSelf.contentView setFrame:CGRectMake(0, (MAINSCREEN_HEIGHT - weakSelf.contentViewHeigth),MAINSCREEN_WIDTH,weakSelf.contentViewHeigth)];
        
    } completion:nil];
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView {
    WS(weakSelf);
    [_contentView setFrame:CGRectMake(0, MAINSCREEN_HEIGHT - _contentViewHeigth, MAINSCREEN_WIDTH, _contentViewHeigth)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         weakSelf.alpha = 0.0;
                         [weakSelf.contentView setFrame:CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH, weakSelf.contentViewHeigth)];
                     }
                     completion:^(BOOL finished){
                         [weakSelf removeFromSuperview];
                         [weakSelf.contentView removeFromSuperview];
                     }];
    
}

@end

