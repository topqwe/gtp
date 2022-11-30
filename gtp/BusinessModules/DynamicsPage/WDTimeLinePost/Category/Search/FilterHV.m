
#import "FilterHV.h"
#import "TTTagView.h"
@interface FilterHV ()
@property (nonatomic,copy) NSArray *arr;

@property (nonatomic,strong)NSMutableArray *btns;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic,strong)UIView *bgView;

@end
@implementation FilterHV

- (id)initWithFrame:(CGRect)frame InSuperView:(UIView*)superView withTopMargin:(NSInteger)topMargin{
    if (self == [super initWithFrame:frame]) {
        
        self.bgView = [[UIView alloc]init];
        self.bgView.backgroundColor = kClearColor;
        self.bgView.userInteractionEnabled = YES;
        [superView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
            make.leading.equalTo(superView).offset(0);
            make.centerX.mas_equalTo(superView);
            make.top.mas_equalTo(topMargin);
//            make.bottom.mas_equalTo(superView);
            
            make.height.mas_equalTo(200);
        }];
        
        [self.bgView layoutIfNeeded];
        
        
    }
        
    
    return self;
}

-(void)richOnlyElementsInCellWithModel:(id)model didDefaultSelectFirst:(BOOL)didDefaultSelectFirst didAllowsInvertSelection:(BOOL)didAllowsInvertSelection{
    self.arr = model;
    if (self.arr.count==0) {
        return;
    }
    kWeakSelf(self);
    
    _btns = [NSMutableArray array];
    
    for (int i = 0; i < self.arr.count; i++) {
        TTTagView* tagView3 = [[TTTagView alloc] init];
//        tagView3.selected = NO;
        tagView3.tag = i+300;
        tagView3.numberOfLines = 1;
    //    self.tagView3.allowsSelection = NO;
    //    self.tagView3.selected = YES;
//        tagView3.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
        HomeItem* it = self.arr[0];
        NSArray* aaa = [self basedOnSC0Item:it didAdd0Data:NO];
        
        tagView3.defaultSelectTags = didDefaultSelectFirst?aaa.firstObject?@[aaa.firstObject]:@[]: @[];
        tagView3.tagSelectedBorderColor = [UIColor clearColor];
        tagView3.tagSelectedBackgroundColor = [UIColor clearColor];
        tagView3.tagBorderColor = [UIColor clearColor];
        tagView3.tagBackgroundColor = [UIColor clearColor];
        tagView3.tagSelectedTextColor = YBGeneralColor.themeColor;
        tagView3.tagTextColor = HEXCOLOR(0x000000);
        tagView3.tagFont = kFontSize(14);
        tagView3.tagSelectedFont = [UIFont systemFontOfSize:14];
        tagView3.allowsInvertSelection = didAllowsInvertSelection;
        
        tagView3.tagsArray = aaa;//在这之前设定字体颜色
        [self.bgView addSubview:tagView3];
        
        [_btns addObject:tagView3];
//        [tagView3 actionBlock:^(NSArray* data) {
//                    kStrongSelf(self);
//                    if (self.block) {
//                        self.block(data.firstObject);
//                    }
//        }];
    }
    
//    [_btns mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    TTTagView* tagView3 = _btns[0];
    [tagView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.mas_equalTo(50);
        make.centerX.equalTo(self.bgView);
    }];
    
    
    __block HomeItem* item3 = nil;
    
    [tagView3 actionBlock:^(NSArray* data) {
                kStrongSelf(self);
                if (self.block) {
                    if (data.count > 0) {
                        item3 = data.firstObject;
                        self.block(@[item3]);
                    }else{
                        item3 = nil;
                        self.block(@[]);
                    }
                    
                }
    }];
    
    [self layoutIfNeeded];
}

-(void)richElementsInCellWithModel:(id)model WithDummy0Datas:(NSArray*)dummy0Datas{
    self.arr = model;
    if (self.arr.count==0) {
        return;
    }
    kWeakSelf(self);
    
    _btns = [NSMutableArray array];
    
    for (int i = 0; i < self.arr.count; i++) {
        TTTagView* tagView3 = [[TTTagView alloc] init];
//        tagView3.selected = NO;
        tagView3.tag = i+300;
        tagView3.numberOfLines = 1;
    //    self.tagView3.allowsSelection = NO;
    //    self.tagView3.selected = YES;
//        tagView3.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
        
        NSArray* aaa = self.arr[i];
        if (i<self.arr.count-1) {
            tagView3.defaultSelectTags = @[aaa.firstObject];
            tagView3.tagSelectedBorderColor = [UIColor clearColor];
            tagView3.tagSelectedBackgroundColor = [UIColor clearColor];
            tagView3.tagBorderColor = [UIColor clearColor];
            tagView3.tagBackgroundColor = [UIColor clearColor];
            tagView3.tagSelectedTextColor = YBGeneralColor.themeColor;
            tagView3.tagTextColor = HEXCOLOR(0x000000);
            tagView3.tagFont = kFontSize(18);
            tagView3.tagSelectedFont = [UIFont systemFontOfSize:18];
        }else{
            tagView3.defaultSelectTags = @[];
            tagView3.tagSelectedBorderColor = [UIColor clearColor];
            tagView3.tagSelectedBackgroundColor = HEXCOLOR(0xECECEC);
            tagView3.tagBorderColor = [UIColor clearColor];
            tagView3.tagBackgroundColor = HEXCOLOR(0xECECEC);
            tagView3.tagSelectedTextColor = YBGeneralColor.themeColor;
            tagView3.tagTextColor = HEXCOLOR(0x000000);
            tagView3.tagFont = kFontSize(14);
            tagView3.tagSelectedFont = [UIFont systemFontOfSize:14];
            tagView3.lineSpacing = 0;
            tagView3.itemSpacing = 35;
//            tagView3.allowsInvertSelection = YES;
        }
        tagView3.tagsArray = aaa;//在这之前设定字体颜色
        [self.bgView addSubview:tagView3];
        
        [_btns addObject:tagView3];
//        [tagView3 actionBlock:^(NSArray* data) {
//                    kStrongSelf(self);
//                    if (self.block) {
//                        self.block(data.firstObject);
//                    }
//        }];
    }
    
    [_btns mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    
    [_btns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.mas_equalTo(50);

    }];
    
    TTTagView* tagView0 = _btns[0];
    __block HomeItem* item0 = tagView0.tagsArray.firstObject;
    
    TTTagView* tagView1 = _btns[1];
    __block HomeItem* item1 = tagView1.tagsArray.firstObject;
    
    TTTagView* tagView2 = _btns[2];
    __block HomeItem* item2 = tagView2.tagsArray.firstObject;
    
    TTTagView* tagView3 = _btns[3];
    __block HomeItem* item3 = nil;
        [tagView3 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(-20);
            make.centerX.equalTo(self.bgView);
        //        make.trailing.equalTo(@-50);
        //        make.height.mas_equalTo(60);

        }];
    
    [tagView0 actionBlock:^(NSArray* data) {
                kStrongSelf(self);
                if (self.block) {
                    item0 = data.firstObject;
                    
                    item1 = [self changeSC1DataWith0Item:item0 WithDummy0Datas:dummy0Datas didAdd0Data:YES];
                    
                    if (item3) {
                        self.block(@[item0,item1,item2,item3]);
                    }else{
                        self.block(@[item0,item1,item2]);
                    }
                    
                }
    }];
    [tagView1 actionBlock:^(NSArray* data) {
                kStrongSelf(self);
                if (self.block) {
                    item1 = data.firstObject;
                    if (item3) {
                        self.block(@[item0,item1,item2,item3]);
                    }else{
                        self.block(@[item0,item1,item2]);
                    }
                }
    }];
    [tagView2 actionBlock:^(NSArray* data) {
                kStrongSelf(self);
                if (self.block) {
                    item2 = data.firstObject;
                    if (item3) {
                        self.block(@[item0,item1,item2,item3]);
                    }else{
                        self.block(@[item0,item1,item2]);
                    }
                }
    }];
    [tagView3 actionBlock:^(NSArray* data) {
                kStrongSelf(self);
                if (self.block) {
                    if (data.count > 0) {
                        item3 = data.firstObject;
                        self.block(@[item0,item1,item2,item3]);
                    }else{
                        item3 = nil;
                        self.block(@[item0,item1,item2]);
                    }
                    
                }
    }];
    
//
//    for (int i = 0; i < _btns.count; i++) {
//        TTTagView* tagView3 = _btns[i];
//        tagView3.tagsArray = @[@{@"name":@"林俊杰",@"id":@(9)},@"张学友",@"刘德华",@"陶喆",@"王力宏",@"王菲",@"Taylor swift",@"周杰伦",@"owl city",@"汪苏泷",@"许嵩",@"李代沫",@"那英",@"羽泉",@"刀郎",@"田馥甄",@"庄心妍",@"林宥嘉",@"薛之谦",@"萧敬腾",@"王若琳"];
//        tagView3.defaultSelectTags = @[tagView3.tagsArray.firstObject];
//    }
    [self layoutIfNeeded];
}
- (HomeItem*)changeSC1DataWith0Item:(HomeItem*)data0 WithDummy0Datas:(NSArray*)dummy0Datas didAdd0Data:(BOOL)didAdd0Data{
    TTTagView* tagView1 = _btns[1];
    for (HomeItem* meti in tagView1.tagsArray) {
        [tagView1 removeTag:meti];
    }
    tagView1.tagsArray = data0.ID == -1?dummy0Datas:[self basedOnSC0Item:data0 didAdd0Data:didAdd0Data];
    tagView1.defaultSelectTags = @[tagView1.tagsArray.firstObject];
    HomeItem* item1 = tagView1.tagsArray.firstObject;
    return item1;
    
}
- (NSArray*)basedOnSC0Item:(HomeItem*)data0 didAdd0Data:(BOOL)didAdd0Data{
    NSMutableArray* items1= [NSMutableArray array];
    if (didAdd0Data) {
        HomeItem* data2 = [HomeItem new];
        data2.ID = -1;
        data2.name = @"全部";
        [items1 addObject:data2];
    }
      
    if (data0.childs !=nil && data0.childs.count>0 ) {
        
        [items1 addObjectsFromArray:[HomeItem mj_objectArrayWithKeyValuesArray:data0.childs]];
    
    }
    return [items1 copy];
}

- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
@end
