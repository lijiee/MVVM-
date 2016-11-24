//
//  TwoViewController.m
//  ReactiveCocoaE
//
//  Created by 李杰 on 16/9/8.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import "TwoViewController.h"
#import "ReactiveCocoa.h"
#import "myTableViewCell.h"

@interface TwoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *twoButton;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *imgaebutton;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet UIButton *mybutt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputToolBarBottomConstraint;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic, assign) CGFloat previousTextViewContentHeight;
@property (nonatomic, assign) CGFloat contentOffsetY;


@end

@implementation TwoViewController
- (CGFloat)previousTextViewContentHeight {
    if (_previousTextViewContentHeight == 0) {
        _previousTextViewContentHeight = self.textview.frame.size.height;
    }
    return _previousTextViewContentHeight;
}


- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.监听键盘弹出，把inputToolBar（输入工具条）往上移
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillShowNotification object:nil];
    _textview.delegate = self;
    // 2.监听键盘退出，inputToolBar回复原位
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [_textview setBackgroundColor: [UIColor redColor]];
    [_mybutt addTarget:self action:@selector(Sender:) forControlEvents:UIControlEventTouchUpInside];
    // 添加动画
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];


}
- (void)Sender:(id)sender{
    [self.dataSource addObject:_textview.text];
    [self.tableview reloadData];
    // 清空textView的文字
    _textview.text = nil;
    self.height.constant = 50;
    _textview.contentSize = CGSizeMake(self.view.frame.size.width - 124, 50);
    [_textview setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
}

#pragma mark 键盘显示时会触发的方法
-(void)kbWillShow:(NSNotification *)noti {
    //1.获取键盘高度
    //1.1获取键盘结束时候的位置
    CGRect kbEndFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbHeight = kbEndFrame.size.height;
    
    CGRect beginRect = [[noti.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    CGRect endRect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    NSLog(@"%f", kbHeight);
    // 第三方键盘回调三次问题，监听仅执行最后一次
    
    if(!(beginRect.size.height > 0 && ( fabs(beginRect.origin.y - endRect.origin.y) > 0))) return;
    
    CGFloat animationDuration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    // 2.更改inputToolBar 底部约束
    self.inputToolBarBottomConstraint.constant = kbHeight;
   
        [UIView animateWithDuration:animationDuration animations:^{
            [self.view layoutIfNeeded];
        }];
    // 4.把消息现在在顶部
}

#pragma mark 键盘退出时会触发的方法
-(void)kbWillHide:(NSNotification *)noti{
    //inputToolbar恢复原位
    self.inputToolBarBottomConstraint.constant = 0;
    self.height.constant = 50;
    _textview.contentSize = CGSizeMake(self.view.frame.size.width - 124, 50);
    // 添加动画
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

//pragma mark - UITextView代理
-(void)textViewDidChange:(UITextView *)textView {
    // 1.计算textView的高度
    CGFloat textViewH = 0;
    CGFloat minHeight = 33 + 3; // textView最小的高度
    CGFloat maxHeight = 1000 + 3 +10; // textView最大的高度
    
    // 获取contentSize 的高度
    CGFloat contentHeight = textView.contentSize.height;
    
    if (contentHeight < minHeight) {
        textViewH = minHeight;
        [textView setContentInset:UIEdgeInsetsZero];
    } else if (contentHeight > maxHeight) {
        textViewH = maxHeight + 4.5;
        [textView setContentInset:UIEdgeInsetsMake(-5, 0, -3.5, 0)];
    } else {
        if (contentHeight ==  minHeight) {
            [textView setContentInset:UIEdgeInsetsZero];
            textViewH = minHeight;
        } else {
            textViewH = contentHeight - 8;
            [textView setContentInset:UIEdgeInsetsMake(-4.5, 0, -4.5, 0)];
        }
    }
    
   
    // 3.调整整个InputToolBar 的高度
    self.height.constant = 6 + 7 + textViewH;
    CGFloat changeH = textViewH - self.previousTextViewContentHeight;
    if (changeH != 0) {
        
        // 加个动画
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
            if (textView.text.length) {
            }
            // 4.记光标回到原位
#warning 技巧
            // 下面这几行代码需要写在[self.view layoutIfNeeded]后面，不然系统会自动调整为位置
            if (contentHeight < maxHeight) {
                [textView setContentOffset:CGPointZero animated:YES];
                [textView scrollRangeToVisible:textView.selectedRange];
            }
        }];
        self.previousTextViewContentHeight = textViewH;
    }
    
    if (contentHeight > maxHeight) {
        [UIView animateWithDuration:0.2 animations:^{
            if (self.contentOffsetY) {
                if (textView.selectedRange.location != textView.text.length && textView.contentOffset.y != self.contentOffsetY) return;
            }
            [textView setContentOffset:CGPointMake(0.0, textView.contentSize.height - textView.frame.size.height - 3.5)];
            self.contentOffsetY = textView.contentOffset.y;
        }];
        [textView scrollRangeToVisible:textView.selectedRange];
    }
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    myTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myTableViewCell" forIndexPath:indexPath];
    [cell.mytableview setText:self.dataSource[indexPath.row]];
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > 300) {
        [self.textview resignFirstResponder];

    }
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
