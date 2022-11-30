
#import "MyInputCell.h"
@interface MyInputCell()<UITextFieldDelegate>

@property (nonatomic, copy)TwoDataBlock block;
@property (nonatomic, assign)NSInteger sum;
@end
@implementation MyInputCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.titleLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, MAINSCREEN_WIDTH - 40, 24)];
        self.titleLb.font = [UIFont systemFontOfSize:17];
        [self addSubview:self.titleLb];
        
        self.inputTF = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.titleLb.frame) + 7, MAINSCREEN_WIDTH - 40, 23)];
        self.inputTF.keyboardType =  UIKeyboardTypeDefault;
//        self.inputTF.borderStyle = UITextBorderStyleNone;
        self.inputTF.font = [UIFont systemFontOfSize:15];
        self.inputTF.delegate = self;
        [self addSubview:_inputTF];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.inputTF.frame) + 10, MAINSCREEN_WIDTH, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:232.0/256 green:233.0/256 blue:237.0/256 alpha:1];
        [self addSubview:lineView];
        
    }
    return self;
}

+(CGFloat)cellHeightWithModel{
    return 85;
}
+(instancetype)cellWith:(UITableView*)tabelView{
    MyInputCell *cell = (MyInputCell *)[tabelView dequeueReusableCellWithIdentifier:@"MyInputCell"];
    if (!cell) {
        cell = [[MyInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyInputCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)richElementsInCellWithModel:(NSDictionary*)model WithIndexRow:(NSInteger)row{
    self.titleLb.text = model.allKeys[0];
    self.inputTF.placeholder = model.allValues[0];
    self.inputTF.tag = row;
    self.inputTF.secureTextEntry = YES;
}

- (void)richElementsInNotYetVertifyCellWithModel:(NSDictionary*)model WithIndexRow:(NSInteger)row{
    self.titleLb.text = model.allKeys[0];
    self.inputTF.placeholder = model.allValues[0];
    self.inputTF.tag = row;
}

- (void)richElementsInAddAccountCellWithModel:(NSDictionary*)model WithIndexRow:(NSInteger)row WithAllSourceSum:(NSInteger)sum{
    self.titleLb.text = model.allKeys[0];
    self.inputTF.placeholder = model.allValues[0];
    self.inputTF.tag = row;
    self.sum = sum;
    if(row  == sum-1)self.inputTF.secureTextEntry = YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.block) {
        self.block(textField,![NSString isEmpty:textField.text]?textField.text:@"");
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

//}
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
    if (self.sum>0&& textField.tag == self.sum-2) {
        //如果是删除减少字数，都返回允许修改
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if (range.location>= 15)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return YES;
}

- (void)actionBlock:(TwoDataBlock)block
{
    self.block = block;
}
@end
