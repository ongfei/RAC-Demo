//
//  CustomField.h
//  RAC-Demo
//
//  Created by df on 2017/3/10.
//  Copyright © 2017年 df. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface CustomField : UIView

@property (nonatomic, copy) NSString *placeText;

@property (nonatomic, assign) BOOL secureText;

@property (nonatomic, copy) RACSignal *signal;

@property (nonatomic, copy) NSString *text;

@end
