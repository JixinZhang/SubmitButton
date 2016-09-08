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

@property (nonatomic, assign) BOOL succeeded;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) SubmitButtonLayerBlock block;

@end