//
//  SubmitButtonView.h
//  SubmitButton
//
//  Created by ZhangBob on 8/25/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SubmitButtonStatus) {
    SubmitButtonStatusStart = 0,    //动画开始
    SubmitButtonStatusLoading = 1,  //动画加载loading部分，此时可发送网络请求，并调用- (void)loadingProgressAnimationWithProgress:(CGFloat)progress方法给动画的progress赋值。
    SubmitButtonStatusEnd = 2       //动画结束
};

typedef void (^SubmitButtonStatusBlock)(SubmitButtonStatus submitBtnStatus);

@interface SubmitButtonView : UIView

/**
 *  动画时长
 */
@property (nonatomic, assign) CGFloat duration;

/**
 *  SubmitButton被点击，将点击事件通过Block传递
 */
@property (nonatomic, copy) SubmitButtonStatusBlock block;

/**
 *  给loading过程赋值
 *
 *  @param progress 进度 取值范围0 - 1
 */
- (void)loadingProgressAnimationWithProgress:(CGFloat)progress;

@end
