//
//  SubmitButtonLayer.m
//  SubmitButton
//
//  Created by ZhangBob on 8/25/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "SubmitButtonLayer.h"
#import <UIKit/UIKit.h>

#define screenWidth self.frame.size.width
#define screenHeight self.frame.size.height
#define mainColor [UIColor colorWithRed:24/255.0 green:197/255.0 blue:138/255.0 alpha:1]
#define grayBorderColor [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1]

@interface SubmitButtonLayer()

@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *circleBorderColor;
@property (nonatomic, strong) UIBezierPath *path;

@end

@implementation SubmitButtonLayer

@dynamic progress;
@dynamic center;
@dynamic width;
@dynamic height;

- (UIBezierPath *)path {
    if (!_path) {
        _path = [[UIBezierPath alloc] init];
        UIColor *fillColor = [UIColor redColor];
        [fillColor set];
    }
    return _path;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"progress"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx {
    
    if (floorf(self.progress) == 22.0f) {
    }
    
    [self.path removeAllPoints];
    CGFloat halfWidth;
    
    //绘制跑道形->圆形->跑道形
    if (self.progress <= 5) {
        halfWidth = self.width / 2.0;
        self.fillColor = [UIColor colorWithRed:24/255.0 green:197/255.0 blue:138/255.0 alpha:1];
        self.circleBorderColor = mainColor;
    }else if (self.progress <= 20){
        CGFloat changeRate = (self.progress - 5) / 15.0;
        halfWidth = self.width * (1 - changeRate) / 2.0;
        self.fillColor = [UIColor colorWithRed:(24 + (255 - 24) * changeRate) / 255.0
                                         green:(197 + (255 - 197) * changeRate) / 255.0
                                          blue:(138 + (255 - 138) * changeRate) / 255.0
                                         alpha:1];
        self.circleBorderColor = [UIColor colorWithRed:(24 + (180 - 24) * changeRate) / 255.0
                                                 green:(197 + (180 - 197) * changeRate) / 255.0
                                                  blue:(138 + (180 - 138) * changeRate) / 255.0
                                                 alpha:1];
    }else if (self.progress <= 22){
        halfWidth = 0;
        self.fillColor = [UIColor whiteColor];
        self.circleBorderColor = grayBorderColor;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SubmitButtonAnimationStop" object:nil];
        
    }else {
        CGFloat changeRate = (self.progress - 22) / 20.0;
        halfWidth = self.width * (1 - (42 - self.progress) / 20.0) / 2.0;
        self.fillColor = [UIColor colorWithRed:(255 - (255 - 24) * changeRate) / 255.0
                                         green:(255 - (255 - 197) * changeRate) / 255.0
                                          blue:(255 - (255 - 138) * changeRate) / 255.0
                                         alpha:1];
        self.circleBorderColor = [UIColor colorWithRed:(180 - (180 - 24) * changeRate) / 255.0
                                                 green:(180 - (180 - 197) * changeRate) / 255.0
                                                  blue:(180 - (180 - 138) * changeRate) / 255.0
                                                 alpha:1];
    }
    
    [self.path moveToPoint:CGPointMake(self.center.x, self.center.y - self.height / 2.0)];
    [self.path addLineToPoint:CGPointMake(self.center.x + halfWidth, self.center.y - self.height / 2.0)];
    
    [self.path addArcWithCenter:CGPointMake(self.center.x + halfWidth, self.center.y) radius:self.height / 2.0 startAngle:-M_PI_2 endAngle:M_PI_2 clockwise:YES];
    
    [self.path addLineToPoint:CGPointMake(self.center.x - halfWidth, self.center.y + self.height / 2.0)];
    
    [self.path addArcWithCenter:CGPointMake(self.center.x - halfWidth, self.center.y) radius:self.height / 2.0 startAngle:M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
    
    [self.path addLineToPoint:CGPointMake(self.center.x, self.center.y - self.height / 2.0)];
    [self.path moveToPoint:CGPointMake(self.center.x, self.center.y - self.height / 2.0)];
    [self.path closePath];
    
    CGContextSaveGState(ctx);
    CGContextSetFillColorWithColor(ctx, self.fillColor.CGColor);
    CGContextSetLineWidth(ctx, 3.0f);
    CGContextSetStrokeColorWithColor(ctx, self.circleBorderColor.CGColor);
    CGContextAddPath(ctx, self.path.CGPath);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    CGContextRestoreGState(ctx);
    
    
    //绘制文字
    NSString *text = @"Submit";
    if (self.progress <= 3) {
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14 - self.progress],NSForegroundColorAttributeName:[UIColor whiteColor]};
        CGPoint textCenter = CGPointMake(self.center.x - [text sizeWithAttributes:attributes].width / 2.0, self.center.y - [text sizeWithAttributes:attributes].height / 2.0);
        UIGraphicsPushContext(ctx);
        [text drawAtPoint:textCenter withAttributes:attributes];
        UIGraphicsPopContext();
    }else if (self.progress <=5) {
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10 + self.progress],NSForegroundColorAttributeName:[UIColor whiteColor]};
        CGPoint textCenter = CGPointMake(self.center.x - [text sizeWithAttributes:attributes].width / 2.0, self.center.y - [text sizeWithAttributes:attributes].height / 2.0);
        UIGraphicsPushContext(ctx);
        [text drawAtPoint:textCenter withAttributes:attributes];
        UIGraphicsPopContext();
    }else if (self.progress < 17) {
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor whiteColor]};
        CGPoint textCenter = CGPointMake(self.center.x - [text sizeWithAttributes:attributes].width / 2.0, self.center.y - [text sizeWithAttributes:attributes].height / 2.0);
        UIGraphicsPushContext(ctx);
        [text drawAtPoint:textCenter withAttributes:attributes];
        UIGraphicsPopContext();
    }
    
    if (self.progress > 22) {
        //绘制对号√
        CGPoint checkMarkCenter = CGPointMake(self.center.x, self.center.y + 16);
        
        CGFloat baseLength = (self.progress - 22) * 2;
        CGPoint leftPoint = CGPointMake(checkMarkCenter.x - baseLength / 3.0 * cosf(M_PI_4), checkMarkCenter.y - baseLength / 3.0 * sinf(M_PI_4));
        CGPoint rightPoint = CGPointMake(checkMarkCenter.x + baseLength * cosf(M_PI_4), checkMarkCenter.y - baseLength * sinf(M_PI_4));
        
        CGContextSaveGState(ctx);
        CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
        CGContextAddArc(ctx, leftPoint.x, leftPoint.y, 2.0, 0, 2 * M_PI, 1);
        CGContextDrawPath(ctx, kCGPathFill);
        CGContextAddArc(ctx, checkMarkCenter.x, checkMarkCenter.y, 2.0, 0, 2 * M_PI, 1);
        CGContextDrawPath(ctx, kCGPathFill);
        CGContextAddArc(ctx, rightPoint.x, rightPoint.y, 2.0, 0, 2 * M_PI, 1);
        CGContextDrawPath(ctx, kCGPathFill);
        CGContextRestoreGState(ctx);
        
        CGContextSaveGState(ctx);
        CGContextSetLineWidth(ctx, 4.0f);
        CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
        CGContextMoveToPoint(ctx, leftPoint.x, leftPoint.y);
        CGContextAddLineToPoint(ctx, checkMarkCenter.x, checkMarkCenter.y);
        CGContextMoveToPoint(ctx, checkMarkCenter.x, checkMarkCenter.y);
        CGContextAddLineToPoint(ctx, rightPoint.x, rightPoint.y);
        CGContextMoveToPoint(ctx, rightPoint.x, rightPoint.y);
        CGContextClosePath(ctx);
        CGContextDrawPath(ctx, kCGPathStroke);
        CGContextRestoreGState(ctx);
    }
}

@end

@implementation SubmitButtonLoadingLayer

@dynamic loadingProgress;
@dynamic center;
@dynamic radius;

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"loadingProgress"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx {
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    CGFloat originstart = -M_PI_2;
    CGFloat currentOrigin = originstart + 2 * M_PI *self.loadingProgress;

    [circlePath addArcWithCenter:self.center radius:self.radius startAngle:originstart endAngle:currentOrigin clockwise:YES];
    CGContextSaveGState(ctx);
    CGContextSetLineWidth(ctx, 3.0f);
    CGContextSetStrokeColorWithColor(ctx, mainColor.CGColor);
    CGContextAddPath(ctx, circlePath.CGPath);
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextRestoreGState(ctx);
    
    if (self.loadingProgress == 1.0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SubmitButtonLoadingCompleted" object:nil];
    }

}

@end
