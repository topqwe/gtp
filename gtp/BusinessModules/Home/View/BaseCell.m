//
//  BaseCell.m
//  

#import "BaseCell.h"

@interface BaseCell ()

@property (nonatomic, weak) UIView *separator;

@end

@implementation BaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self richEles];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self richEles];
    }
    return self;
}

+(instancetype)cellWith:(UITableView*)tabelView{
    BaseCell *cell = (BaseCell *)[tabelView dequeueReusableCellWithIdentifier:@"BaseCell"];
    if (!cell) {
        cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BaseCell"];
    }
    return cell;
}
// 设置 自定义分割线
- (void)richEles
{
    UIView *separator = [[UIView alloc] init];
    [self.contentView addSubview:separator];
    self.separator = separator;
    
    separator.height = 0.5;
    separator.backgroundColor = RGBSAMECOLOR(238);
    
    _arrowIv = [[UIImageView alloc]init];
    [self.contentView addSubview:_arrowIv];
    
}

- (void)setSeparatorLineColor:(UIColor *)separatorLineColor
{
    _separatorLineColor = separatorLineColor;
    self.separator.backgroundColor = separatorLineColor;
}

- (void)setHideSeparatorLine:(BOOL)hideSeparatorLine
{
    _hideSeparatorLine = hideSeparatorLine;
    
    self.separator.hidden = hideSeparatorLine;
    self.arrowIv.hidden = self.separator.hidden;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.separator.y = self.height - self.separator.height;
    self.separator.width = self.width;
    
    UIImage* arrImg = kIMG(@"search_histrory-right");
    _arrowIv.image = arrImg;
    _arrowIv.frame = CGRectMake(self.width - 15 - arrImg.size.width, (self.height - arrImg.size.height)/2, arrImg.size.width, arrImg.size.height);
}

@end
