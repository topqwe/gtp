//
//  UIViewController+STPresent.m
//  SportHome
//
//  Created by stoneobs on 16/11/25.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#import "UIViewController+STPresent.h"
static ST_IMAGE_PICKER_BLOCK         imgePickerBlock;
static UIImagePickerController      *imagePicker;
@implementation UIViewController (STPresent)
#pragma mark --Alert和Actionsheet
- (void)st_showAlertTitle:(NSString *)title
                  message:(NSString *)message
             andWithBlock:(ST_ALERT_BLOCK)finsh{
    
    UIAlertController * vc =[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [vc addAction:[UIAlertAction actionWithTitle:@"确认"
                                           style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * _Nonnull action) {
                                             if (finsh) {
                                                 finsh(@"确认");
                                             }
                                         }]];
    [self presentViewController:vc animated:YES completion:nil];
    
}
- (void)st_showAlertTitle:(NSString *)title
                  message:(NSString *)message
                leftTitle:(NSString *)leftTitle
               rightTitle:(NSString *)rightTitle
                    block:(ST_ALERT_BLOCK)finsh{
    
    
    UIAlertController * vc =[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (leftTitle.length) {
        [vc addAction:[UIAlertAction actionWithTitle:leftTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (finsh) {
                finsh(leftTitle);
            }
        }]];
    }
    
    if (rightTitle.length) {
        [vc addAction:[UIAlertAction actionWithTitle:rightTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (finsh) {
                finsh(rightTitle);
            }
        }]];
    }
    
    [self presentViewController:vc animated:YES completion:nil];
    
}
- (void)st_showTextFiledAlertWithTitle:(NSString *)title
                               message:(NSString *)message
                             leftTitle:(NSString *)leftTitle
                            rightTitle:(NSString *)rightTitle
                       preperTextfiled:(void (^)(UITextField *))preperTextfiled block:(void (^)(NSString *, NSString *))finsh{
    
    UIAlertController * vc =[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [vc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        if (preperTextfiled) {
            preperTextfiled(textField);
        }
    }];
    if (leftTitle.length) {
        [vc addAction:[UIAlertAction actionWithTitle:leftTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (finsh) {
                UITextField * textField = vc.textFields.firstObject;
                finsh(leftTitle,textField.text);
            }
        }]];
    }
    
    if (rightTitle.length) {
        [vc addAction:[UIAlertAction actionWithTitle:rightTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (finsh) {
                UITextField * textField = vc.textFields.firstObject;
                finsh(rightTitle,textField.text);
            }
        }]];
    }
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark --actionSheet
- (void)st_showActionSheet:(NSArray<NSString *> *)strArray andWithBlock:(ST_ACTION_BLOCK)test
{
    
    UIAlertController * sheet =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i< strArray.count; i++) {
        UIAlertAction * action =[UIAlertAction actionWithTitle:strArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (test) {
                test(i);
            }
            
            
        }];
        [sheet addAction:action];
    }
    
    [self presentViewController:sheet animated:YES completion:^{
        
    }];
}
#pragma mark ----默认image picker
- (void)st_showDefultImagePicker:(ST_IMAGE_PICKER_BLOCK)pickerBlock
{
    UIImagePickerController * vc = [[UIImagePickerController alloc] init];
    vc.allowsEditing = YES;
    vc.delegate = self;
    imagePicker = vc;
    UIAlertController * sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * camer = [UIAlertAction actionWithTitle:@"拍照"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       if (!TARGET_OS_SIMULATOR) {
                                                           imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                           [self presentViewController:imagePicker animated:YES completion:nil];
                                                       }
                                                       
                                                   }];
    [sheet addAction:camer];
    UIAlertAction * photo =[UIAlertAction actionWithTitle:@"从相册"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                      [self presentViewController:imagePicker animated:YES completion:nil];
                                                  }];
    [sheet addAction:photo];
    UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消"
                                                      style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        
                                                    }];
    [sheet addAction:cancle];
    
    [self presentViewController:sheet animated:YES completion:nil];
    if (pickerBlock) {
        imgePickerBlock = pickerBlock;
    }
    
}
- (void)st_showTakePhotoImagePicker:(ST_IMAGE_PICKER_BLOCK)pickerBlock{
    UIImagePickerController * vc = [[UIImagePickerController alloc] init];
    vc.allowsEditing = YES;
    vc.delegate = self;
    imagePicker = vc;
    if (pickerBlock) {
        imgePickerBlock = pickerBlock;
    }
    vc.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)st_showchosePhotoImagePicker:(ST_IMAGE_PICKER_BLOCK)pickerBlock{
    UIImagePickerController * vc = [[UIImagePickerController alloc] init];
    vc.allowsEditing = YES;
    vc.delegate = self;
    imagePicker = vc;
    if (pickerBlock) {
        imgePickerBlock = pickerBlock;
    }
    vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark --UINavigationControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (imagePicker.allowsEditing) {
            UIImage *   image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
            if (imgePickerBlock) {
                imgePickerBlock(image);
            }
        } else {
            UIImage *   image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            if (imgePickerBlock) {
                imgePickerBlock(image);
            }
        }
        
    }];
}
- (void)st_showAlertWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
                      message:(NSString *)message
                 messageColor:(UIColor *)messageColor
                    leftTitle:(NSString *)leftTitle
               leftTitleColor:(UIColor *)leftTitleColor
                   rightTitle:(NSString *)rightTitle
              rightTitleColor:(UIColor *)rightTitleColor
                       handle:(ST_ALERT_BLOCK)handle{
    
    UIAlertController * vc =[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (titleColor) {
        NSAttributedString * customTitle = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:titleColor,NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:18]}];
        [vc setValue:customTitle forKey:@"_attributedTitle"];
    }
    NSMutableParagraphStyle * style =  [NSMutableParagraphStyle new];
    style.alignment = NSTextAlignmentCenter;
    if (messageColor) {
        NSAttributedString * customMessage = [[NSAttributedString alloc] initWithString:message attributes:@{NSForegroundColorAttributeName:messageColor,NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:style}];
        [vc setValue:customMessage forKey:@"_attributedMessage"];
    }
    if (leftTitle.length) {
        UIAlertAction * actionOne = [UIAlertAction actionWithTitle:leftTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (handle) {
                handle(leftTitle);
            }
        }];
        if (leftTitleColor) {
            [actionOne setValue:leftTitleColor forKey:@"_titleTextColor"];
        }
        [vc addAction:actionOne];
    }
    if (rightTitle.length) {
        UIAlertAction * actionTwo  = [UIAlertAction actionWithTitle:rightTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (handle) {
                handle(rightTitle);
            }
        }];
        if (rightTitleColor) {
            [actionTwo setValue:rightTitleColor forKey:@"_titleTextColor"];
        }
        if (rightTitle.length > 0) {
            [vc addAction:actionTwo];
            
        }
        
    }
    [self presentViewController:vc animated:YES completion:nil];
    
}
@end


