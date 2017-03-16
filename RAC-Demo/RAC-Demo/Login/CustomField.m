//
//  CustomField.m
//  RAC-Demo
//
//  Created by df on 2017/3/10.
//  Copyright © 2017年 df. All rights reserved.
//

#import "CustomField.h"
#import "Masonry.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface CustomField ()

@property (nonatomic,strong) UITextField *textField;

@property (nonatomic,strong) UILabel *placeholderLabel;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) CALayer *lineLayer;

@end
@implementation CustomField

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]){
        
        [self prepareLayout];
        
    }
    return self;
}

- (void)prepareLayout {
    
    _textField = [[UITextField alloc]initWithFrame:CGRectZero];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.font = [UIFont systemFontOfSize:15.f];
    _textField.textColor = [UIColor whiteColor];
    _textField.tintColor = [UIColor whiteColor];
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ScreenWidth/6);
        make.right.equalTo(self).offset(-ScreenWidth/6);
        make.top.equalTo(@15);
        make.bottom.equalTo(self).offset(-1);
    }];
    
    [_textField.rac_textSignal subscribeNext:^(id x) {
        
        if ([x length] > 0) {
            
            [UIView animateWithDuration:0.15 animations:^{
                
                [_placeholderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(_textField);
                    make.bottom.equalTo(_textField.mas_top).offset(-1);
                    make.height.equalTo(@15);
                }];
                
                _placeholderLabel.alpha = 1;
                
                [self layoutIfNeeded];
                _lineLayer.bounds = CGRectMake(0, 0, _textField.frame.size.width, 1);
            }];
            
            
        }else {
            
            [UIView animateWithDuration:0.15 animations:^{
                
                [_placeholderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.centerY.equalTo(_textField);
                    make.left.equalTo(_textField).offset(5);
                    make.height.equalTo(@15);
                }];
                
                _placeholderLabel.alpha = 1;
                _lineLayer.bounds = CGRectMake(0, 0, 0, 1);
            }];
            
        }
        
    }];
    
    _placeholderLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _placeholderLabel.font = [UIFont systemFontOfSize:13.f];
    _placeholderLabel.textColor = [UIColor colorWithRed:0.866 green:0.876 blue:0.876 alpha:1.000];
    [self addSubview:_placeholderLabel];
    [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(_textField);
        make.height.equalTo(@15);
        make.left.equalTo(_textField).offset(5);
    }];
    
    _placeholderLabel.text = @"输入用户名";
    
    _lineView = [[UIView alloc]initWithFrame:CGRectZero];
    _lineView.backgroundColor = [UIColor colorWithRed:0.866 green:0.876 blue:0.876 alpha:1.000];
    [self addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_textField);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@1);
    }];
    
    _lineLayer = [CALayer layer];
    _lineLayer.frame = CGRectMake(0, 0, 0, 1);
    _lineLayer.anchorPoint = CGPointMake(0, 0.5);
    _lineLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [_lineView.layer addSublayer:_lineLayer];
    

}

- (void)setPlaceText:(NSString *)placeText {
    
    self.placeholderLabel.text = placeText;
}

- (void)setSecureText:(BOOL)secureText {
    
    _textField.secureTextEntry = secureText;
}

- (RACSignal *)signal {
    
    return self.textField.rac_textSignal;
}

- (NSString *)text {
    
    return self.textField.text;
}
@end
