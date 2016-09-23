//
//  TwoViewController.m
//  ReactiveCocoaE
//
//  Created by 李杰 on 16/9/8.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import "TwoViewController.h"
#import "ReactiveCocoa.h"

@interface TwoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *twoButton;
@end

@implementation TwoViewController
- (IBAction)btnClick:(id)sender {
    if (self.delegateSignal) {
        [self.delegateSignal subscribeNext:^(id x) {
            
        }];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(id x) {
        NSLog(@"x%@",x);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
