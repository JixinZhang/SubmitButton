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
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define mainColor [UIColor colorWithRed:24/255.0 green:197/255.0 blue:138/255.0 alpha:1]

@interface ViewController ()

@property (nonatomic, strong) SubmitButtonView *submitBtnView;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) UIButton *resetButton;;
@end

@implementation ViewController

//- (SubmitButtonView *)submitBtnView {
//    if (!_submitBtnView) {
//        _submitBtnView = [[SubmitButtonView alloc] initWithFrame:CGRectMake((kScreenWidth - 200) / 2.0, (kScreenHeight - 50) / 3.0, 200, 50)];
//    }
//    return _submitBtnView;
//}

- (UIButton *)resetButton {
    if (!_resetButton) {
        _resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetButton.frame = CGRectMake((kScreenWidth - 200) / 2.0, kScreenHeight - 50, 200, 30);
        _resetButton.backgroundColor = mainColor;
        _resetButton.layer.cornerRadius = 15.0f;
        [_resetButton setTitle:@"Reset Button" forState:UIControlStateNormal];
        [_resetButton addTarget:self action:@selector(resetSubmitButtonView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.resetButton];
    
    [self setupSubmitButtonView];
    
    self.slider = [[UISlider alloc] init];
    self.slider.frame = CGRectMake(100, kScreenHeight - 100, 200, 30);
    self.slider.minimumValue = 0.0f;
    self.slider.maximumValue = 1.0f;
    [self.slider setValue:0 animated:YES];
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreenHeight - 100, 70, 30)];
    self.speedLabel.font = [UIFont systemFontOfSize:10.f];
    self.speedLabel.textAlignment = NSTextAlignmentCenter;
    self.speedLabel.text = @"进度：0";
    self.speedLabel.layer.cornerRadius = 5.0f;
    self.speedLabel.layer.borderColor = mainColor.CGColor;
    self.speedLabel.layer.borderWidth = 1.0f;
    self.speedLabel.layer.masksToBounds = YES;

}

- (void)setupSubmitButtonView {
    __weak typeof (self)weakSelf = self;
    _submitBtnView = [[SubmitButtonView alloc] initWithFrame:CGRectMake((kScreenWidth - 200) / 2.0, (kScreenHeight - 50) / 3.0, 200, 50)];
    _submitBtnView.block = ^(SubmitButtonStatus submitBtnStatus){
        switch (submitBtnStatus) {
            case SubmitButtonStatusStart:
                break;
                
            case SubmitButtonStatusLoading:
                [weakSelf.view addSubview:weakSelf.slider];
                [weakSelf.view addSubview:weakSelf.speedLabel];
                break;
                
            case SubmitButtonStatusEnd:
                [weakSelf.slider removeFromSuperview];
                [weakSelf.speedLabel removeFromSuperview];
                break;
                
            default:
                break;
        }
    };
    [self.view addSubview:self.submitBtnView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sliderValueChanged:(UISlider *)sender {
    UISlider *slider = sender;
    self.speedLabel.text = [NSString stringWithFormat:@"进度：%.1f",slider.value];
    [self.submitBtnView loadingProgressAnimationWithProgress:slider.value];
}

- (void)resetSubmitButtonView {
    [self.slider setValue:0 animated:YES];
    [self.slider removeFromSuperview];
    self.speedLabel.text = [NSString stringWithFormat:@"进度：0"];
    [self.speedLabel removeFromSuperview];

    [self.submitBtnView removeFromSuperview];
    [self setupSubmitButtonView];
}

@end
