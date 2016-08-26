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

/*
 *  动画改编的属性有：图形(包含了颜色)，文字，loading和对号。对这几个属性截取了时间节点。
 *  动画的整个过程为72。
 */


/*
 *  图形分为五个过程：0-5，5-20，20-22，22-52，52-72
 */
#define GRAPHIC_5_20 15.0
#define GRAPHIC_52_72 20.0

#define GRAPHIC_5 (5 / 72.0)
#define GRAPHIC_20 (20 / 72.0)
#define GRAPHIC_22 (22 / 72.0)
#define GRAPHIC_52 (52 / 72.0)

/*
 *  文字分为四部分:0-3，3-5，5-17，17-72
 */
#define STRING_3 (3 / 72.0)
#define STRING_5 (5 / 72.0)
#define STRING_17 (17 / 72.0)

/*
 *  loading
 */
#define LOADING_22_52 30.0
#define LOADING_22 (22 / 72.0)
#define LOADING_52 (52 / 72.0)

/*
 *  对号
 */
#define CHECKMARK52 (52 / 72.0)

@interface SubmitButtonLayer()

@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *circleBorderColor;
@property (nonatomic, strong) UIBezierPath *path;

@end

@implementation SubmitButtonLayer

@dynamic animationDuration;
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
    
    [self.path removeAllPoints];
    CGFloat halfWidth;
    
    //绘制跑道形->圆形->跑道形
    if (self.progress <= (GRAPHIC_5 * self.animationDuration)) {
        halfWidth = self.width / 2.0;
        self.fillColor = [UIColor colorWithRed:24/255.0
                                         green:197/255.0
                                          blue:138/255.0
                                         alpha:1];
        self.circleBorderColor = mainColor;
    }else if (self.progress <= (GRAPHIC_20 * self.animationDuration)){
        CGFloat changeRate = (self.progress - 5) / GRAPHIC_5_20;
        halfWidth = self.width * (1 - changeRate) / 2.0;
        self.fillColor = [UIColor colorWithRed:(24 + (255 - 24) * changeRate) / 255.0
                                         green:(197 + (255 - 197) * changeRate) / 255.0
                                          blue:(138 + (255 - 138) * changeRate) / 255.0
                                         alpha:1];
        self.circleBorderColor = [UIColor colorWithRed:(24 + (180 - 24) * changeRate) / 255.0
                                                 green:(197 + (180 - 197) * changeRate) / 255.0
                                                  blue:(138 + (180 - 138) * changeRate) / 255.0
                                                 alpha:1];
    }else if (self.progress <= (GRAPHIC_22 * self.animationDuration)){
        halfWidth = 0;
        self.fillColor = [UIColor whiteColor];
        self.circleBorderColor = grayBorderColor;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SubmitButtonAnimationStop" object:nil];
    }else if (self.progress < (GRAPHIC_52 * self.animationDuration)) {
        halfWidth = 0;
        self.fillColor = [UIColor whiteColor];
        self.circleBorderColor = grayBorderColor;
    }else {
        CGFloat changeRate = (self.progress - (GRAPHIC_52 * self.animationDuration)) / GRAPHIC_52_72;
        halfWidth = self.width * (1 - (self.animationDuration - self.progress) / GRAPHIC_52_72) / 2.0;
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
    [self.path addArcWithCenter:CGPointMake(self.center.x + halfWidth, self.center.y)
                         radius:self.height / 2.0
                     startAngle:-M_PI_2
                       endAngle:M_PI_2
                      clockwise:YES];
    [self.path addLineToPoint:CGPointMake(self.center.x - halfWidth, self.center.y + self.height / 2.0)];
    [self.path addArcWithCenter:CGPointMake(self.center.x - halfWidth, self.center.y)
                         radius:self.height / 2.0
                     startAngle:M_PI_2
                       endAngle:M_PI_2 * 3
                      clockwise:YES];
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
    if (self.progress <= (STRING_3 * self.animationDuration)) {
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14 - self.progress],NSForegroundColorAttributeName:[UIColor whiteColor]};
        CGPoint textCenter = CGPointMake(self.center.x - [text sizeWithAttributes:attributes].width / 2.0, self.center.y - [text sizeWithAttributes:attributes].height / 2.0);
        UIGraphicsPushContext(ctx);
        [text drawAtPoint:textCenter withAttributes:attributes];
        UIGraphicsPopContext();
    }else if (self.progress <= (STRING_5 * self.animationDuration)) {
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10 + self.progress],NSForegroundColorAttributeName:[UIColor whiteColor]};
        CGPoint textCenter = CGPointMake(self.center.x - [text sizeWithAttributes:attributes].width / 2.0, self.center.y - [text sizeWithAttributes:attributes].height / 2.0);
        UIGraphicsPushContext(ctx);
        [text drawAtPoint:textCenter withAttributes:attributes];
        UIGraphicsPopContext();
    }else if (self.progress < (STRING_17 * self.animationDuration)) {
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor whiteColor]};
        CGPoint textCenter = CGPointMake(self.center.x - [text sizeWithAttributes:attributes].width / 2.0, self.center.y - [text sizeWithAttributes:attributes].height / 2.0);
        UIGraphicsPushContext(ctx);
        [text drawAtPoint:textCenter withAttributes:attributes];
        UIGraphicsPopContext();
    }
    
    //绘制loadingAnimation
    if (self.progress > (LOADING_22 * self.animationDuration) &&
        self.progress < (LOADING_52 * self.animationDuration)) {
        //绘制百分比String
        NSString *progressStr = [NSString stringWithFormat:@"%.0f％",(self.progress - (LOADING_22 * self.animationDuration)) / LOADING_22_52 * 100];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10.0f],NSForegroundColorAttributeName:mainColor};
        CGPoint textCenter = CGPointMake(self.center.x - [progressStr sizeWithAttributes:attributes].width / 2.0, self.center.y - [progressStr sizeWithAttributes:attributes].height / 2.0);
        UIGraphicsPushContext(ctx);
        [progressStr drawAtPoint:textCenter withAttributes:attributes];
        UIGraphicsPopContext();

        
        UIBezierPath *circlePath = [UIBezierPath bezierPath];
        CGFloat originstart = -M_PI_2;
        CGFloat currentOrigin = originstart + 2 * M_PI * (self.progress - (LOADING_22 * self.animationDuration)) / LOADING_22_52;
        
        [circlePath addArcWithCenter:self.center radius:self.height / 2.0 startAngle:originstart endAngle:currentOrigin clockwise:YES];
        CGContextSaveGState(ctx);
        CGContextSetLineWidth(ctx, 3.0f);
        CGContextSetStrokeColorWithColor(ctx, mainColor.CGColor);
        CGContextAddPath(ctx, circlePath.CGPath);
        CGContextDrawPath(ctx, kCGPathStroke);
        CGContextRestoreGState(ctx);
    }
    
    if (self.progress > (LOADING_52 * self.animationDuration)) {
        //绘制对号√
        CGPoint checkMarkCenter = CGPointMake(self.center.x, self.center.y + 16);
        
        CGFloat baseLength = (self.progress - (LOADING_52 * self.animationDuration)) * 2;
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

