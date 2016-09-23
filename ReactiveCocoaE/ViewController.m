//
//  ViewController.m
//  ReactiveCocoaE
//
//  Created by 李杰 on 16/9/8.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"
#import "Masonry.h"
#import "TwoViewController.h"
@interface ViewController ()
@property (nonatomic,strong)UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *myButton;
@property (nonatomic,strong)UITextField *myTextView;
@end

@implementation ViewController
- (IBAction)oneClick:(id)sender {
    TwoViewController *two = [self.storyboard instantiateViewControllerWithIdentifier:@"TwoViewController"];
    two.delegateSignal = [RACSubject subject];
    [two.delegateSignal subscribeNext:^(id x) {
        
    }];
    [self presentViewController:two animated:YES completion:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self inintView];
    //创建一个信号
    RACSignal *singal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSArray *array = @[@1,@2];
        //发送信号
        [subscriber sendNext:array];
        //如果不发送信号。最好发送信号完毕，内部销毁信号
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号被摧毁了");
        }];
    }];
    //订阅信号
    [singal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    //创建信号
    
    RACSubject *subject = [RACSubject subject];

    //订阅信号
    [subject subscribeNext:^(id x) {
        NSLog(@"订阅第一个信号");
    }];
    [subject subscribeNext:^(id x) {
        NSLog(@"订阅第二个信号");

    }];
    
    [subject sendNext:@1];
    [subject sendNext:@2];

    
    
    
    
    
    
}

- (void)inintView{
    self.nameLabel = [[UILabel alloc]init];
    self.myTextView = [[UITextField alloc]init];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.myTextView];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(100);
        make.trailing.equalTo(self.view.mas_trailing).offset(-20);
        make.height.mas_equalTo(40);
        make.leading.equalTo(self.view.mas_leading).offset(20);
    }];
    [self.myTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(20);
        make.trailing.equalTo(self.view.mas_trailing).offset(-20);
       
        make.height.mas_equalTo(self.nameLabel.mas_height);
        make.width.mas_equalTo(self.nameLabel.mas_width);
        
    }];
    self.nameLabel.backgroundColor = [UIColor redColor];
    self.myTextView.backgroundColor =[ UIColor yellowColor];
    
    
    RAC(self.nameLabel,text)= self.myTextView.rac_textSignal;
    RAC(self.myButton,enabled) =  [RACSignal combineLatest:@[self.myTextView.rac_textSignal] reduce:^(NSString *text){
        BOOL isEnabled = text.length>0?YES:NO;
        return @(isEnabled);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
