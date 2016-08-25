//
//  ViewController.m
//  SubmitButton
//
//  Created by ZhangBob on 8/25/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "ViewController.h"
#import "SubmitButtonView.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenheight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic, strong) SubmitButtonView *submitBtnView;

@end

@implementation ViewController

- (SubmitButtonView *)submitBtnView {
    if (!_submitBtnView) {
        _submitBtnView = [[SubmitButtonView alloc] initWithFrame:CGRectMake((kScreenWidth - 200) / 2.0, (kScreenheight - 50) / 3.0, 200, 50)];
    }
    return _submitBtnView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.submitBtnView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
