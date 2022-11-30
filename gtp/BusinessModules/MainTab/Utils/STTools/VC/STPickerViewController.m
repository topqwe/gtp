//
//  STPickerVIewController.m
//  SportClub
//
//  Created by stoneobs on 16/8/10.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#import "STPickerViewController.h"
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define SCREEN_FRAME  [UIScreen mainScreen].bounds
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define STRGB(v)     [UIColor colorWithRed:((float)((v & 0xFF0000) >> 16))/255.0 green:((float)((v & 0xFF00) >> 8))/255.0  blue:((float)(v & 0xFF))/255.0 alpha:1]
#define BACKROUND_COLOR  STRGB(0xF4F5F0)

@interface STPickerViewController()<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)UIView           *curentView;//当前视图
@property(nonatomic,strong)UIPickerView     *areaPicker;
@property(nonatomic,strong)UIDatePicker     *datePicker;

@property(nonatomic,strong)UIView           *pickerBack;//picker 的superView
@property(nonatomic,strong)UIButton         *clearBut;//背景button，点击dismiss
@property(nonatomic,strong)UIButton         *confirmofBottomButton;//完成按钮
@property(nonatomic,strong)UIButton         *cancelButton;//取消按钮

@property(nonatomic,strong)NSArray          *provinceAry;
@property(nonatomic,strong)NSMutableArray   *cityAry;
@property(nonatomic,strong)NSMutableArray   *areaAry;
@property(nonatomic,strong)NSMutableArray   *currentCityArray;//当前城市数组
@property(nonatomic,strong)NSMutableArray   *currentAreaArray;//当前区域数组
@property(nonatomic,strong)NSMutableString  *pro,*city,*area;
@property(nonatomic,strong)NSDictionary            *proDic,*cityDic,*areaDic;
@property(nonatomic,strong)NSString         *chosedTime;//选择的时间字符串
@property(nonatomic,strong)NSDate           *chosedDate;//选择的时间

//自定义picker 数据
@property(nonatomic,strong)NSArray<NSArray<NSString*>*>     *datasouce;
@property(nonatomic,assign)BOOL  isCustom;//是否自定义
@property(nonatomic,strong)UIPickerView     *customPicker;//自定义picker
@property(nonatomic,strong)NSString         *componentStr0;
@property(nonatomic,strong)NSString         *componentStr1;
@property(nonatomic,strong)NSString         *componentStr2;//暂时写了三个，一般是三个，如果需要扩展，此功能之后扩展

//各种回调
@property(nonatomic,copy)STPickerViewControllerAREPICKER        areaPickerBlock;
@property(nonatomic,copy)STPickerViewControllerDATEPICKER       datePickerBlock;
@property(nonatomic,copy)STPickerViewControllerCusPicker        cusPickerBlock;//自定义pickerBlock
@end
@implementation STPickerViewController

- (instancetype)initWithDefualtDatePickerWithHandle:(STPickerViewControllerDATEPICKER)handle
{
    
    if (self = [super init]) {
        [self initDefualt];
        self.curentView = self.datePicker;
        NSDateFormatter * fomat =[[NSDateFormatter alloc]init];
        [fomat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.chosedTime = [fomat stringFromDate:[NSDate date]];
        
        //将时间转换成本地时间
        NSDate *date = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: date];
        NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
        self.chosedDate = localeDate;
        
        if (handle) {
            self.datePickerBlock = handle;
        }
        
    }
    return self;
}

- (instancetype)initWithDefualtAreaPickerWithHandle:(STPickerViewControllerAREPICKER)handle;
{
    if (self = [super init]) {
        [self initDefualt];
        self.curentView = self.areaPicker;
        if (handle) {
            _areaPickerBlock = handle;
        }
    }
    
    return self;
    
}
- (instancetype)initWithPickerArray:(NSArray<NSArray<NSString*>*> *)dataSouce andWithHandle:(STPickerViewControllerCusPicker)handle
{
    
    if (self = [super init]) {
        [self initDefualt];
        self.datasouce = dataSouce;
        self.isCustom = YES;
        self.curentView = self.customPicker;
        if (handle) {
            self.cusPickerBlock = handle;
        }
    }
    return self;
}

- (void)initDefualt
{
    self.isShowConfirm = YES;
    self.isSpringAnimation = NO;
    self.bottomHeight = 260;
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    
}
#pragma mark --Geter and Setter
- (void)setMaximumDate:(NSDate *)maximumDate
{
    if (maximumDate) {
        if (_datePicker) {
            _datePicker.maximumDate = maximumDate;
        }
    }
    _maximumDate = maximumDate;
}
- (void)setMinimumDate:(NSDate *)minimumDate
{
    if (minimumDate) {
        if (_datePicker) {
            _datePicker.minimumDate = minimumDate;
        }
    }
    _minimumDate = minimumDate;
}

-(void)setDisplayDate:(NSDate *)displayDate
{
    if (displayDate) {
        if (_datePicker) {
            _datePicker.date = displayDate;
        }
    }
}
- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode
{
    if (datePickerMode) {
        if (_datePicker) {
            _datePicker.datePickerMode = datePickerMode;
        }
        
    }
    _datePickerMode = datePickerMode;
}

-(void)setIsNoTimeZone:(BOOL)isNoTimeZone
{
    if (isNoTimeZone) {
        if (_datePicker) {
            //将时间转换成本地时间
            NSDate *date = [NSDate date];
            self.chosedDate = date;
        }
        
    } else {
        if (_datePicker) {
            NSDate *date = [NSDate date];
            NSTimeZone *zone = [NSTimeZone systemTimeZone];
            NSInteger interval = [zone secondsFromGMTForDate: date];
            NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
            self.chosedDate = localeDate;
        }
    }
    isNoTimeZone = isNoTimeZone;
}
- (UIDatePicker*)datePicker
{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        NSDateFormatter * formate = [[NSDateFormatter alloc]init];
        [formate setDateFormat:@"yyyy-MM-dd HH:mm"];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        
        _datePicker.minimumDate = [formate dateFromString:@"1916-01-01 00:00"];
        _datePicker.maximumDate = [NSDate date];
        //        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [_datePicker addTarget:self action:@selector(datepickerAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
    
    
}
-(UIPickerView*)areaPicker
{
    if (!_areaPicker) {
        _areaPicker = [[UIPickerView alloc] init];
        _areaPicker.delegate = self;
        _areaPicker.dataSource = self;
        
        NSString * profileUrl = [[NSBundle mainBundle] pathForResource:@"STTools.bundle/STFiles/province5.4" ofType:@"json"];
        NSData  *prodata = [NSData dataWithContentsOfFile:profileUrl];
        _provinceAry  = [NSJSONSerialization JSONObjectWithData:prodata options:NSJSONReadingAllowFragments error:nil];
        
        NSString * cityfileUrl = [[NSBundle mainBundle] pathForResource:@"STTools.bundle/STFiles/city5.4" ofType:@"json"];
        NSData  *citydata = [NSData dataWithContentsOfFile:cityfileUrl];
        _cityAry  = [NSJSONSerialization JSONObjectWithData:citydata options:NSJSONReadingAllowFragments error:nil];
        
//        NSString * areafileUrl = [[NSBundle mainBundle] pathForResource:@"STTools.bundle/STFiles/area1" ofType:@"json"];
//        NSData  *areadata = [NSData dataWithContentsOfFile:areafileUrl];
//        _areaAry  = [NSJSONSerialization JSONObjectWithData:areadata options:NSJSONReadingAllowFragments error:nil];
        
        self.currentCityArray = [NSMutableArray new];
       // self.currentAreaArray = [NSMutableArray new];
        
        [self pickerView:_areaPicker didSelectRow:0 inComponent:0];
        
    }
    return _areaPicker;
}
-(UIPickerView *)customPicker
{
    if (!_customPicker) {
        _customPicker = [[UIPickerView alloc]init];
        _customPicker.delegate = self;
        _customPicker.dataSource = self;
        [self pickerView:_customPicker didSelectRow:0 inComponent:0];
        
    }
    return _customPicker;
}
#pragma mark --vc生命周期
-(void)viewDidLoad
{
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.curentView == _datePicker) {
        [self bottomViewWillAppear:self.datePicker];
        return;
    }
    if (self.curentView == _areaPicker) {
        [self bottomViewWillAppear:_areaPicker];
        return;
    }
    if (self.curentView == _customPicker) {
        [self bottomViewWillAppear:self.customPicker];
        return;
    }
    if (!self.curentView) {
        return;
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
#pragma mark --UIDatePicker Action
-(void)datepickerAction:(UIDatePicker*)sender
{
    if (!self.isNoTimeZone) {
        //将时间转换成本地时间
        UIDatePicker *picker = sender;
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: picker.date];
        NSDate *localeDate = [picker.date  dateByAddingTimeInterval: interval];
        self.chosedDate = localeDate;
    } else {
        //将时间转换成本地时间
        UIDatePicker *picker = sender;
        NSDate *date = [picker date];
        self.chosedDate = date;
    }
}

#pragma mark --弹出一个pickerview，picker都从底部弹出
-(void)bottomViewWillAppear:(UIView*)pickerView
{
    
    if (!self.clearBut) {
        self.clearBut = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-self.bottomHeight)];
        self.clearBut.backgroundColor  = [UIColor blackColor];
        self.clearBut.alpha = 0.4;
        [self.clearBut addTarget:self action:@selector(clearAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view.window addSubview:self.clearBut];
    }
    else{
        self.clearBut.hidden = NO;
    }
    self.pickerBack = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.bottomHeight)];
    self.pickerBack.backgroundColor = [UIColor whiteColor];
    
    //完成取消按钮的背景
    if (self.isShowConfirm) {
        
        UIView * backview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
        //backview.backgroundColor = BACKROUND_COLOR;
        backview.backgroundColor = [UIColor whiteColor];
        self.confirmofBottomButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 20, 60, 18)];
        [self.confirmofBottomButton setTitle:@"完成" forState:UIControlStateNormal];
        self.confirmofBottomButton.backgroundColor = [UIColor clearColor];
        self.confirmofBottomButton.layer.cornerRadius = 0;
        self.confirmofBottomButton.clipsToBounds = YES;
        self.confirmofBottomButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.confirmofBottomButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.confirmofBottomButton setTitleColor:STRGB(0x7a8fdf) forState:UIControlStateNormal];
        [self.confirmofBottomButton addTarget:self action:@selector(confimAction) forControlEvents:UIControlEventTouchUpInside];
        [backview addSubview:self.confirmofBottomButton];
        
        if (self.confimTitleColor) {
             [self.confirmofBottomButton setTitleColor:self.confimTitleColor forState:UIControlStateNormal];
        }
        self.cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 60, 18)];
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        self.cancelButton.backgroundColor = [UIColor clearColor];
        self.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.cancelButton.layer.cornerRadius = 0;
        self.cancelButton.clipsToBounds = YES;
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.cancelButton setTitleColor:STRGB(0x333) forState:UIControlStateNormal];
        
        [self.cancelButton addTarget:self action:@selector(bottomViewWillDisapper) forControlEvents:UIControlEventTouchUpInside];
        
        UIView  *line = [[UIView alloc] initWithFrame:CGRectMake(0, backview.st_height - 0.5, UIScreenWidth, 0.5)];
        line.backgroundColor = STRGB(0xd9d9d9);
        [backview addSubview:line];
        [backview addSubview:self.cancelButton];
        
        [self.pickerBack addSubview:backview];
        
    }
    
    //加载picker
    pickerView.frame = CGRectMake(0, 55, SCREEN_WIDTH, self.bottomHeight-55);
    [self.pickerBack addSubview:pickerView];
    [self.view addSubview:self.pickerBack];
    
    //坐标需求，修改UI
    [self.cancelButton setTitleColor:STRGB(0x333333) forState:UIControlStateNormal];
    
    //是否展示弹性动画
    if (self.isSpringAnimation) {
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.7 options:UIViewAnimationOptionTransitionNone animations:^{
            self.pickerBack.frame = CGRectMake(0, SCREEN_HEIGHT-self.bottomHeight, SCREEN_HEIGHT, self.bottomHeight);
            [[NSNotificationCenter defaultCenter] postNotificationName:STPickerViewFrameDidChange object:self.pickerBack];
        } completion:^(BOOL finished) {
            //默认选中第一条
            [[NSNotificationCenter defaultCenter] postNotificationName:STPickerViewFrameDidEndChange object:self.pickerBack];
            if (_areaPicker) {
                [self pickerView:_areaPicker didSelectRow:0 inComponent:0];
            }
            if (_customPicker) {
                [self pickerView:self.customPicker didSelectRow:0 inComponent:0];
            }
            
        }];
    }
    else{
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.pickerBack.frame = CGRectMake(0, SCREEN_HEIGHT-self.bottomHeight, SCREEN_HEIGHT, self.bottomHeight);
            [[NSNotificationCenter defaultCenter] postNotificationName:STPickerViewFrameDidChange object:self.pickerBack];
        } completion:^(BOOL finished) {
            //默认选中第一条
            [[NSNotificationCenter defaultCenter] postNotificationName:STPickerViewFrameDidEndChange object:self.pickerBack];
            if (_areaPicker) {
                [self pickerView:_areaPicker didSelectRow:0 inComponent:0];
            }
            if (_customPicker) {
                [self pickerView:self.customPicker didSelectRow:0 inComponent:0];
            }
        }];
    }
    
    
}
#pragma mark --Action Method
- (void)clearAction:(id)sender
{
    [self.view endEditing:YES];
    if (!self.clearBut.hidden) {
        self.clearBut.hidden=YES;
    }
    
    [self bottomViewWillDisapper];
}
//取消事件
- (void)bottomViewWillDisapper
{
    [UIView animateWithDuration:0.4 animations:^{
        self.pickerBack.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_HEIGHT, self.bottomHeight);
        [[NSNotificationCenter defaultCenter] postNotificationName:STPickerViewFrameDidChange object:self.pickerBack];
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:STPickerViewFrameDidEndChange object:self.pickerBack];
        [self dismissViewControllerAnimated:NO completion:nil];
        
    }];
    //    self.confirmofBottomButton.frame = CGRectMake(SCREEN_WIDTH-70, 0, 60, 40);
    //    self.cancelButton.frame = CGRectMake(10, 0, 60, 40);
    
    if (!self.clearBut.hidden) {
        self.clearBut.hidden=YES;
    }
    
}
//确定事件
- (void)confimAction
{
    //展示退出动画
    [UIView animateWithDuration:0.4 animations:^{
        self.pickerBack.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_HEIGHT, self.bottomHeight);
        [[NSNotificationCenter defaultCenter] postNotificationName:STPickerViewFrameDidChange object:self.pickerBack];
        
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:STPickerViewFrameDidEndChange object:self.pickerBack];
        [self dismissViewControllerAnimated:NO completion:nil];
        
    }];
    
    if (!self.clearBut.hidden) {
        self.clearBut.hidden = YES;
    }
    
    //地区回调
    if (_areaPickerBlock&&_areaPicker) {
        if (!_area) {
            _area = [NSMutableString stringWithString:@""];
        }
        _pro = _proDic[@"name"];
        _city = _cityDic[@"name"];
        _area = _areaDic[@"name"];
        NSMutableString * finsh = [NSMutableString stringWithFormat:@"%@%@%@",_pro,_city,_area];
        if (_pro) {
            _areaPickerBlock(finsh,_area,_city,_pro);
        }
        
    }
    //时间回调
    if (_datePickerBlock&&_datePicker) {
        
        _datePickerBlock(self.chosedDate);
    }
    //自定义回调
    if (self.cusPickerBlock) {
        NSArray * array;
        array = @[self.componentStr0];
        if (self.datasouce.count == 2) {
            array = @[self.componentStr0,self.componentStr1];
        }
        if (self.datasouce.count == 3) {
            array = @[self.componentStr0,self.componentStr1,self.componentStr2];
        }
        
        self.cusPickerBlock(array);
    }
    
    
}
#pragma mark ----UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.isCustom) {
        return self.datasouce.count;
    }
    if (_areaPicker) {
        return 2;
        
    }
    return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView ==_areaPicker) {
        if (component == 0) {
            return _provinceAry.count;
        }
        if (component == 1) {
            return self.currentCityArray.count;
        }
        if (component == 2) {
            return self.currentAreaArray.count;
        }
        
    }
    if (pickerView == _customPicker) {
        return self.datasouce[component].count;
    }
    
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 26;
}

- (NSAttributedString*)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * title = [self pickerView:pickerView titleForRow:row forComponent:component];
    NSAttributedString * string = [[NSAttributedString alloc] initWithString:title
                                                                  attributes:@{NSForegroundColorAttributeName:STRGB(0x333333),
                                                                               NSFontAttributeName:[UIFont systemFontOfSize:16]}
                                   ];
    return string;
    
}
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView ==_areaPicker) {
        if (component == 0) {
            NSMutableString * provence = [_provinceAry[row] valueForKey:@"name"];
            return provence;
        }
        if (component == 1) {
            
            if (self.currentCityArray.count == 0) {
                return @"";
            }
            NSString * city = [self.currentCityArray[row] valueForKey:@"name"];
            return city;
            
        }
        if (component == 2) {
            if (self.currentAreaArray.count == 0) {
                return @"";
            }
            NSString * area = [self.currentAreaArray[row] valueForKey:@"name"];
            return area;
        }
        
    }
    if (self.customPicker == pickerView) {
        return self.datasouce[component][row];
    }
    
    return @"";
}
#pragma mark --UIPickerViewDelegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView ==_areaPicker) {
        if (component == 0) {
            NSString * provienceCode = [self.provinceAry[row] valueForKey:@"code"];
            self.currentCityArray = [self findCitysWithProvinceCode:provienceCode];
            [_areaPicker selectRow:0 inComponent:1 animated:NO];
            [_areaPicker reloadAllComponents];
            
            self.proDic = nil;
            self.cityDic = nil;
            self.areaDic = nil;
            self.proDic = self.provinceAry[row];
            
            
        }
        if (component == 1) {
            if (self.currentCityArray.count == 0) {
                return;
            }
            NSString * cityCode = [self.cityAry[row] valueForKey:@"code"];
            self.currentAreaArray = [self findAreasWithCityCode:cityCode];
            self.cityDic = self.currentCityArray[row];
            
        }
        if (component == 2) {
            if (self.currentCityArray.count == 0) {
                return;
            }
            self.areaDic = self.currentAreaArray[row];
        }
        
        if (_areaPickerBlock) {
            if (self.currentCityArray.count == 0) {
                return;
            }
            if (!self.cityDic) {
                self.cityDic = [self.currentCityArray firstObject];
            }
            if (!self.areaDic) {
                self.areaDic = [self.currentAreaArray firstObject];
            }
            
        }
        
    }
    //自定义点击事件
    if (self.customPicker == pickerView) {
        if (self.datasouce.count == 1) {
            NSInteger com0 = [self.customPicker selectedRowInComponent:0];
            self.componentStr0 = self.datasouce[0][com0];
        }
        if (self.datasouce.count == 2) {
            [self.customPicker reloadComponent:0];
            [self.customPicker reloadComponent:1];
            NSInteger com0 = [self.customPicker selectedRowInComponent:0];
            self.componentStr0 = self.datasouce[0][com0];
            NSInteger com1 = [self.customPicker selectedRowInComponent:1];
            self.componentStr1 = self.datasouce[1][com1];
        }
        if (self.datasouce.count == 3) {
            [self.customPicker reloadComponent:0];
            [self.customPicker reloadComponent:1];
            [self.customPicker reloadComponent:2];
            
            NSInteger com0 = [self.customPicker selectedRowInComponent:0];
            self.componentStr0 = self.datasouce[0][com0];
            NSInteger com1 = [self.customPicker selectedRowInComponent:1];
            self.componentStr1 = self.datasouce[1][com1];
            NSInteger com2 = [self.customPicker selectedRowInComponent:2];
            self.componentStr2 = self.datasouce[2][com2];
            
        }
        
        
        
    }
    
}

#pragma mark --Private Method
//获取当前城市数组
- (NSMutableArray *)findCitysWithProvinceCode:(NSString*)provinceCode{
    
    NSMutableArray * currentCityArray = [NSMutableArray new];
    for (NSDictionary * dic in self.cityAry) {
        NSString * code = [dic valueForKey:@"parent_code"];
        if ([code isEqualToString:provinceCode]) {
            [currentCityArray addObject:dic];
        }
    }
    return currentCityArray;
}
//获取当前area数组
- (NSMutableArray *)findAreasWithCityCode:(NSString*)cityCode{
    
    NSMutableArray * currentAreaArray = [NSMutableArray new];
    for (NSDictionary * dic in self.areaAry) {
        NSString * code = [dic valueForKey:@"code"];
        if ([code isEqualToString:cityCode]) {
            [currentAreaArray addObject:dic];
        }
    }
    return currentAreaArray;
}
@end

