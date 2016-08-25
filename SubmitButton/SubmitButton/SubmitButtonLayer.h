//
//  SubmitButtonLayer.h
//  SubmitButton
//
//  Created by ZhangBob on 8/25/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef void (^SubmitButtonLayerBlock)();

@interface SubmitButtonLayer : CALayer

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) SubmitButtonLayerBlock block;

@end

@interface SubmitButtonLoadingLayer : CALayer

@property (nonatomic, assign) CGFloat loadingProgress;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat radius;

@end
