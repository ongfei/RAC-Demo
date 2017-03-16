//
//  LoginViewController.m
//  RAC-Demo
//
//  Created by df on 2017/3/8.
//  Copyright © 2017年 df. All rights reserved.
//

#import "LoginViewController.h"
#import "Masonry.h"
#import "CustomField.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LoginViewController ()

@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) CustomField *userName;

@property (nonatomic, strong) CustomField *passWord;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backgrandImg = [[UIImageView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview:backgrandImg];
    
    backgrandImg.image = [UIImage imageNamed:@"timg.jpeg"];
    
    UIButton *dismiss = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
    [self.view addSubview:dismiss];
    
    [dismiss mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(40);
        make.width.height.equalTo(@40);
    }];
    
    [dismiss setTitle:@"关闭" forState:(UIControlStateNormal)];
    
    [dismiss addTarget:self action:@selector(goBack) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    CustomField *userField = [CustomField new];
    
    self.userName = userField;
    
    [self.view addSubview:userField];
    
    userField.placeText = @"请输入用户名";
    
    [userField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    
    CustomField *passwField = [CustomField new];
    
    self.passWord = passwField;
    
    [self.view addSubview:passwField];
    
    passwField.placeText = @"请输入密码";
    
    passwField.secureText = YES;
    
    [passwField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(userField);
        make.top.equalTo(userField.mas_bottom).offset(10);
    }];
    
    
    UIButton *login = [UIButton buttonWithType:(UIButtonTypeSystem)];
    
    self.loginBtn = login;
    
    [self.view addSubview:login];
    
    [login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(userField.mas_width).multipliedBy(0.5);
        make.top.equalTo(passwField.mas_bottom).offset(40);
        make.height.equalTo(@35);
    }];
    
    [login setTitle:@"Login" forState:(UIControlStateNormal)];
    
    [login setTitleColor:[UIColor colorWithRed:0.866 green:0.876 blue:0.876 alpha:1.000] forState:(UIControlStateNormal)];
    
    login.userInteractionEnabled = NO;
    
    login.layer.cornerRadius = 6;
    
    login.layer.borderWidth = 2;
    
    login.layer.borderColor = [[UIColor colorWithRed:0.866 green:0.876 blue:0.876 alpha:1.000] CGColor];
    
    [login addTarget:self action:@selector(loginBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    

    [[[RACSignal combineLatest:@[userField.signal,passwField.signal]] map:^id(id value) {
        
        return @([value[0] length] > 0 && [value[1] length] > 5);
        
    }] subscribeNext:^(id x) {
        
        if ([x integerValue] == 1) {
            
            login.userInteractionEnabled = YES;
            [login setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            login.layer.borderColor = [[UIColor whiteColor] CGColor];
            
        }else {
            
            login.userInteractionEnabled = NO;
            [login setTitleColor:[UIColor colorWithRed:0.866 green:0.876 blue:0.876 alpha:1.000] forState:(UIControlStateNormal)];
            login.layer.borderColor = [[UIColor colorWithRed:0.866 green:0.876 blue:0.876 alpha:1.000] CGColor];
        }
        
    }];
    

    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (void)loginBtnClick {
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.duration = 0.2;
    basicAnimation.toValue = (__bridge id _Nullable)([self drawBezierPath:self.loginBtn.frame.size.width/2].CGPath);
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *basicAnimation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    basicAnimation1.beginTime = 0.10;
    basicAnimation1.duration = 0.2;
    basicAnimation1.toValue = @0;
    basicAnimation1.removedOnCompletion = NO;
    basicAnimation1.fillMode = kCAFillModeForwards;
    
    animationGroup.animations = @[basicAnimation,basicAnimation1];
    animationGroup.duration = basicAnimation1.beginTime+basicAnimation1.duration;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.loginBtn.bounds;
    shapeLayer.path = [self drawBezierPath:_loginBtn.frame.size.height/2].CGPath;
    shapeLayer.fillColor = [UIColor orangeColor].CGColor;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    
    [shapeLayer addAnimation:animationGroup forKey:@""];
    
    [self.loginBtn.layer addSublayer:shapeLayer];
    
    
    CAShapeLayer *loadingLayer = [CAShapeLayer layer];
    loadingLayer.position = CGPointMake(self.loginBtn.bounds.size.width/2, self.loginBtn.bounds.size.height/2);
    loadingLayer.fillColor = [UIColor clearColor].CGColor;
    loadingLayer.strokeColor = [UIColor whiteColor].CGColor;
    loadingLayer.lineWidth = 2;
    loadingLayer.path = [self drawLoadingBezierPath].CGPath;
    [self.loginBtn.layer addSublayer:loadingLayer];
    
    CABasicAnimation *loadingAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    loadingAnimation.fromValue = @(0);
    loadingAnimation.toValue = @(M_PI*2);
    loadingAnimation.duration = 0.5;
    loadingAnimation.repeatCount = LONG_MAX;
    
//    [self.loginBtn removeFromSuperview];

    [loadingLayer addAnimation:loadingAnimation forKey:@"loadingAnimation"];

    self.userName.userInteractionEnabled = NO;
    self.passWord.userInteractionEnabled = NO;
    self.loginBtn.userInteractionEnabled = NO;
}

-(UIBezierPath *)drawLoadingBezierPath{
    CGFloat radius = self.loginBtn.bounds.size.height/2 - 3;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:CGPointMake(0,0) radius:radius startAngle:M_PI/2 endAngle:M_PI/2+M_PI/2 clockwise:YES];
    return bezierPath;
}

-(UIBezierPath *)drawBezierPath:(CGFloat)x{
    CGFloat radius = self.loginBtn.bounds.size.height/2 - 3;
    CGFloat right = self.loginBtn.bounds.size.width-x;
    CGFloat left = x;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    bezierPath.lineCapStyle = kCGLineCapRound;
    //右边圆弧
    [bezierPath addArcWithCenter:CGPointMake(right, self.loginBtn.bounds.size.height/2) radius:radius startAngle:-M_PI/2 endAngle:M_PI/2 clockwise:YES];
    //左边圆弧
    [bezierPath addArcWithCenter:CGPointMake(left, self.loginBtn.bounds.size.height/2) radius:radius startAngle:M_PI/2 endAngle:-M_PI/2 clockwise:YES];
    //闭合弧线
    [bezierPath closePath];
    
    return bezierPath;
}


- (void)goBack {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
