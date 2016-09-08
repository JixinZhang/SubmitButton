//
//  SubmitButtonView.m
//  SubmitButton
//
//  Created by ZhangBob on 8/25/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "SubmitButtonView.h"
#import "SubmitButtonLayer.h"

#define viewWidth self.frame.size.width
#define viewHeight self.frame.size.height

@interface SubmitButtonView()

@property (nonatomic, strong) SubmitButtonLayer *submitBtnLayer;
/**
 *  动画时长
 */
@property (nonatomic, assign) CGFloat duration;

@end

@implementation SubmitButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animationPause) name:@"SubmitButtonAnimationStop" object:nil];
        self.duration = 8.2f;
    }
    return self;
}

- (SubmitButtonLayer *)submitBtnLayer {
    if (!_submitBtnLayer) {
        _submitBtnLayer = [SubmitButtonLayer layer];
        _submitBtnLayer.contentsScale = [UIScreen mainScreen].scale;
        _submitBtnLayer.bounds = CGRectMake(0, 0, viewWidth, viewHeight);
        _submitBtnLayer.position = CGPointMake(viewWidth / 2.0, viewHeight / 2.0);
        _submitBtnLayer.animationDuration = self.duration * 10;
        _submitBtnLayer.center = CGPointMake(viewWidth / 2.0, viewHeight / 2.0);
        _submitBtnLayer.width = viewWidth - viewHeight - 8;
        _submitBtnLayer.height = viewHeight - 8;
        _submitBtnLayer.speed = 0;
        _submitBtnLayer.succeeded = YES;
    }
    return  _submitBtnLayer;
}

- (void)drawRect:(CGRect)rect {
    [self setupsubmitBtnLayer];
}

- (void)setupsubmitBtnLayer {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
    animation.duration = self.duration;
    animation.fromValue = @0.0;
    animation.toValue = [NSNumber numberWithFloat:self.duration * 10];
    animation.repeatCount = 1;
    [self.submitBtnLayer addAnimation:animation forKey:@"SubmitButtonAnimaiton"];
    
    [self.layer addSublayer:self.submitBtnLayer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //判断是否已经常见过动画，如果已经创建则不再创建动画
    CAAnimation *animation= [_submitBtnLayer animationForKey:@"SubmitButtonAnimaiton"];
    if(animation){
        if (_submitBtnLayer.speed == 0 &&
            _submitBtnLayer.timeOffset == 0) {
            [self animationResume];
        }
    }
}

-(void)animationResume {
    //获得暂停的时间
    CFTimeInterval beginTime= CACurrentMediaTime()- _submitBtnLayer.timeOffset;
    //设置偏移量
    _submitBtnLayer.timeOffset=0;
    //设置开始时间
    _submitBtnLayer.beginTime=beginTime;
    //设置动画速度，开始运动
    _submitBtnLayer.speed=1.0;
}

-(void)animationPause{
    //取得指定图层动画的媒体时间，后面参数用于指定子图层，这里不需要
    CFTimeInterval interval=[_submitBtnLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    //设置时间偏移量，保证暂停时停留在旋转的位置
    [_submitBtnLayer setTimeOffset:interval];
    //速度设置为0，暂停动画
    _submitBtnLayer.speed=0;
    if (self.block) {
        self.block(SubmitButtonStatusLoading);
    }
}

- (void)loadingProgressAnimationWithProgress:(CGFloat)progress {
    CFTimeInterval interval = progress * 3 + (32 / 82.0) * self.duration;;
    [_submitBtnLayer setTimeOffset:interval];
    _submitBtnLayer.speed = 0;
}

- (void)setFinalResultWith:(BOOL)result {
    _submitBtnLayer.succeeded = result;
    [self animationResume];
    if (self.block) {
        self.block(SubmitButtonStatusEnd);
    }
}

@end
