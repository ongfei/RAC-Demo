//
//  ViewController.m
//  RAC-Demo
//
//  Created by df on 2017/3/2.
//  Copyright © 2017年 df. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"
#import "LoginViewController.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableV;

@property (nonatomic, strong) NSArray *sourceArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"RAC学习";
    
//  RAC 属性生成signal
    [RACObserve(self, title) subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    self.title = @"RAC";
    
    self.sourceArr = @[@"登陆",@"网络请求"];
    
    self.tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64) style:(UITableViewStylePlain)];
    [self.view addSubview:self.tableV];
    
    self.tableV.delegate = self;
    self.tableV.dataSource = self;

    
    [self.tableV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableV.tableFooterView = [UIView new];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.sourceArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSelector:NSSelectorFromString([self.sourceArr objectAtIndex:indexPath.row])];
}

- (void)登陆 {
    
    [self presentViewController:[LoginViewController new] animated:YES completion:^{
        
    }];
}

- (void)网络请求 {
    
//    [[self racsignalWithUrlStr:@"http://www.orzer.club/test.json"] subscribeNext:^(id x) {
//        
//        NSLog(@"%@",x);
//    } error:^(NSError *error) {
//        
//        NSLog(@"%@",error);
//        
//    } completed:^{
//        
//    }];
    
    RACSignal *s1 = [self racsignalWithUrlStr:@"http://www.orzer.club/test.json"];
    RACSignal *s2 = [self racsignalWithUrlStr:@"http://www.orzer.club/test.json"];
    RACSignal *s3 = [self racsignalWithUrlStr:@"http://www.orzer.club/test.json"];
    
//
//    [[[s1 merge:s2] merge:s3] subscribeNext:^(id x) {
//       
//        NSLog(@"%@",x);
//        
//    }];
    
// 只关注最后一次执行的结果
//    [[[s1 then:^RACSignal *{
//        return s2;
//    }] then:^RACSignal *{
//        return s3;
//    }] subscribeNext:^(id x) {
//        
//        NSLog(@"--%@",x);
//    }];
//    和上一个的区别就是 结果每次都会返回
    [[[s1 concat:s2] concat:s3] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    
//
//    [[RACSignal combineLatest:@[s1,s2,s3]] subscribeNext:^(id x) {
//        NSLog(@"+++%@",x);
//    }];
}


- (RACSignal *)racsignalWithUrlStr:(NSString *)url {
    
    //创建一个signal
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
      
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (error) {
                //传输错误
                [subscriber sendError:error];
                
            }else {
                
                NSError *err;
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:&err];
                
                if (err) {
                    
                    [subscriber sendError:err];
                    
                }else {
                    //传输数据
                    [subscriber sendNext:dic];
                    [subscriber sendCompleted];
                }
            }
            
        }];
        
        [dataTask resume];
        
        
        return [RACDisposable disposableWithBlock:^{
            //释放创建的signal
            
        }];
    }];
    
//    [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        replayLast 订阅signal 里面的代码不会重复执行
//    }] replayLast];
}
@end
