//
//  SubmitButtonLayer.m
//  SubmitButton
//
//  Created by JixinZhang on 8/25/16.
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
 *  动画的整个过程为82。
 */


/*
 *  图形分为五个过程：0-10， 0-5，5-20，20-22，22-52，52-82
 */
#define GRAPHIC_15_30 15.0
#define GRAPHIC_62_72 10.0
#define GRAPHIC_10 (10 / 82.0)
#define GRAPHIC_15 (15 / 82.0)
#define GRAPHIC_30 (30 / 82.0)
#define GRAPHIC_32 (32 / 82.0)
#define GRAPHIC_62 (62 / 82.0)
#define GRAPHIC_72 (72 / 82.0)

/*
 *  文字分为四部分:0-3，3-5，5-17，17-82
 */
#define STRING_10 (10 / 82.0)
#define STRING_13 (13 / 82.0)
#define STRING_15 (15 / 82.0)
#define STRING_27 (27 / 82.0)
#define STRING_77 (77 / 82.0)

/*
 *  loading
 */
#define LOADING_32_62 30.0
#define LOADING_32 (32 / 82.0)
#define LOADING_62 (62 / 82.0)
#define LOADING_72 (72 / 82.0)

/*
 *  对号
 */
#define CHECKMARK_62 (62 / 82.0)

@interface SubmitButtonLayer()

@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *circleBorderColor;
@property (nonatomic, strong) UIBezierPath *path;

@end

@implementation SubmitButtonLayer

@dynamic succeeded;
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
    CGFloat halfWidth = self.width / 2.0;
    self.fillColor = [UIColor whiteColor];
    self.circleBorderColor = mainColor;
    //绘制跑道形->圆形->跑道形
    if (self.progress <= (GRAPHIC_10 * self.animationDuration)) {
        CGFloat changeRate = (self.progress / (GRAPHIC_10 * self.animationDuration));
        self.fillColor = [UIColor colorWithRed:(255 - (255 - 24) * changeRate) / 255.0
                                         green:(255 - (255 - 197) * changeRate) / 255.0
                                          blue:(255 - (255 - 138) * changeRate) / 255.0
                                         alpha:1];
    }else if (self.progress <= (GRAPHIC_15 * self.animationDuration)) {
        self.fillColor = [UIColor colorWithRed:24/255.0
                                         green:197/255.0
                                          blue:138/255.0
                                         alpha:1];
    }else if (self.progress <= (GRAPHIC_30 * self.animationDuration)){
        CGFloat changeRate = (self.progress - GRAPHIC_15_30) / GRAPHIC_15_30;
        halfWidth = self.width * (1 - changeRate) / 2.0;
        self.fillColor = [UIColor colorWithRed:(24 + (255 - 24) * changeRate) / 255.0
                                         green:(197 + (255 - 197) * changeRate) / 255.0
                                          blue:(138 + (255 - 138) * changeRate) / 255.0
                                         alpha:1];
        self.circleBorderColor = [UIColor colorWithRed:(24 + (180 - 24) * changeRate) / 255.0
                                                 green:(197 + (180 - 197) * changeRate) / 255.0
                                                  blue:(138 + (180 - 138) * changeRate) / 255.0
                                                 alpha:1];
    }else if (self.progress <= (GRAPHIC_32 * self.animationDuration)){
        halfWidth = 0;
        self.fillColor = [UIColor whiteColor];
        self.circleBorderColor = grayBorderColor;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SubmitButtonAnimationStop" object:nil];
    }else if (self.progress <= (GRAPHIC_62 * self.animationDuration)) {
        halfWidth = 0;
        self.fillColor = [UIColor whiteColor];
        self.circleBorderColor = grayBorderColor;
    }else if (self.progress > (GRAPHIC_62 * self.animationDuration) &&
              self.progress < (GRAPHIC_72 * self.animationDuration)){
        CGFloat changeRate = (self.progress - (GRAPHIC_62 * self.animationDuration)) / GRAPHIC_62_72;
        halfWidth = self.width * (1 - (self.animationDuration - 10 - self.progress) / GRAPHIC_62_72) / 2.0;
        self.fillColor = [UIColor colorWithRed:(255 - (255 - 24) * changeRate) / 255.0
                                         green:(255 - (255 - 197) * changeRate) / 255.0
                                          blue:(255 - (255 - 138) * changeRate) / 255.0
                                         alpha:1];
        self.circleBorderColor = [UIColor colorWithRed:(180 - (180 - 24) * changeRate) / 255.0
                                                 green:(180 - (180 - 197) * changeRate) / 255.0
                                                  blue:(180 - (180 - 138) * changeRate) / 255.0
                                                 alpha:1];
    }else {
        CGFloat changeRate = (self.progress - (GRAPHIC_72 * self.animationDuration)) / GRAPHIC_62_72;
        self.fillColor = [UIColor colorWithRed:(24 + (255 - 24) * changeRate) / 255.0
                                         green:(197 + (255 - 197) * changeRate) / 255.0
                                          blue:(138 + (255 - 138) * changeRate) / 255.0
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
    if (self.progress <= (STRING_10 * self.animationDuration)) {
        CGFloat changeRate = self.progress / (STRING_10 * self.animationDuration);
        UIColor *stringColor = [UIColor colorWithRed:(24 + (255 - 24) * changeRate) / 255.0
                                              green:(197 + (255 - 197) * changeRate) / 255.0
                                               blue:(138 + (255 - 138) * changeRate) / 255.0
                                              alpha:1];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                     NSForegroundColorAttributeName:stringColor};
        CGPoint textCenter = CGPointMake(self.center.x - [text sizeWithAttributes:attributes].width / 2.0, self.center.y - [text sizeWithAttributes:attributes].height / 2.0);
        UIGraphicsPushContext(ctx);
        [text drawAtPoint:textCenter withAttributes:attributes];
        UIGraphicsPopContext();
    }else if (self.progress <= (STRING_13 * self.animationDuration)) {
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14 - self.progress + 10],NSForegroundColorAttributeName:[UIColor whiteColor]};
        CGPoint textCenter = CGPointMake(self.center.x - [text sizeWithAttributes:attributes].width / 2.0, self.center.y - [text sizeWithAttributes:attributes].height / 2.0);
        UIGraphicsPushContext(ctx);
        [text drawAtPoint:textCenter withAttributes:attributes];
        UIGraphicsPopContext();
    }else if (self.progress <= (STRING_15 * self.animationDuration)) {
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10 + self.progress - 10],NSForegroundColorAttributeName:[UIColor whiteColor]};
        CGPoint textCenter = CGPointMake(self.center.x - [text sizeWithAttributes:attributes].width / 2.0, self.center.y - [text sizeWithAttributes:attributes].height / 2.0);
        UIGraphicsPushContext(ctx);
        [text drawAtPoint:textCenter withAttributes:attributes];
        UIGraphicsPopContext();
    }else if (self.progress < (STRING_27 * self.animationDuration)) {
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor whiteColor]};
        CGPoint textCenter = CGPointMake(self.center.x - [text sizeWithAttributes:attributes].width / 2.0, self.center.y - [text sizeWithAttributes:attributes].height / 2.0);
        UIGraphicsPushContext(ctx);
        [text drawAtPoint:textCenter withAttributes:attributes];
        UIGraphicsPopContext();
    }else if (self.progress > (STRING_77 * self.animationDuration)) {
        CGFloat changeRate = (self.progress - (STRING_77 * self.animationDuration)) / 5.0;
        UIColor *stringColor = [UIColor colorWithRed:(236 - (236 - 24) * changeRate) / 255.0
                                               green:(251 - (251 - 197) * changeRate) / 255.0
                                                blue:(246 - (246 - 138) * changeRate) / 255.0
                                               alpha:1];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                     NSForegroundColorAttributeName:stringColor};
        CGPoint textCenter = CGPointMake(self.center.x - [text sizeWithAttributes:attributes].width / 2.0, self.center.y - [text sizeWithAttributes:attributes].height / 2.0);
        UIGraphicsPushContext(ctx);
        [text drawAtPoint:textCenter withAttributes:attributes];
        UIGraphicsPopContext();
    }
    
    //绘制loadingAnimation
    if (self.progress > (LOADING_32 * self.animationDuration) &&
        self.progress < (LOADING_62 * self.animationDuration)) {
        //绘制百分比String
        NSString *progressStr = [NSString stringWithFormat:@"%.0f％",(self.progress - (LOADING_32 * self.animationDuration)) / LOADING_32_62 * 100];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10.0f],NSForegroundColorAttributeName:mainColor};
        CGPoint textCenter = CGPointMake(self.center.x - [progressStr sizeWithAttributes:attributes].width / 2.0, self.center.y - [progressStr sizeWithAttributes:attributes].height / 2.0);
        UIGraphicsPushContext(ctx);
        [progressStr drawAtPoint:textCenter withAttributes:attributes];
        UIGraphicsPopContext();

        
        UIBezierPath *circlePath = [UIBezierPath bezierPath];
        CGFloat originstart = -M_PI_2;
        CGFloat currentOrigin = originstart + 2 * M_PI * (self.progress - (LOADING_32 * self.animationDuration)) / LOADING_32_62;
        
        [circlePath addArcWithCenter:self.center radius:self.height / 2.0 startAngle:originstart endAngle:currentOrigin clockwise:YES];
        CGContextSaveGState(ctx);
        CGContextSetLineWidth(ctx, 3.0f);
        CGContextSetStrokeColorWithColor(ctx, mainColor.CGColor);
        CGContextAddPath(ctx, circlePath.CGPath);
        CGContextDrawPath(ctx, kCGPathStroke);
        CGContextRestoreGState(ctx);
    }
    
    if (self.progress > (LOADING_62 * self.animationDuration) &&
        self.progress < (LOADING_72 * self.animationDuration)) {
        if (self.succeeded) {
            //绘制对号√
            CGPoint checkMarkCenter = CGPointMake(self.center.x, self.center.y + 16);
            
            CGFloat baseLength = (self.progress - (LOADING_62 * self.animationDuration)) * 3;
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
            CGContextDrawPath(ctx, kCGPathStroke);
            CGContextRestoreGState(ctx);
        }else {
            //绘制❌
            CGPoint negitiveCenter = CGPointMake(self.center.x, self.center.y);
            CGFloat baseLength = (self.progress - (LOADING_62 * self.animationDuration)) * 2;
            
            CGPoint leftTopPoint = CGPointMake(negitiveCenter.x - baseLength * cosf(M_PI_4), negitiveCenter.y - baseLength * sinf(M_PI_4));
            CGPoint rightTopPoint = CGPointMake(negitiveCenter.x + baseLength * cosf(M_PI_4), negitiveCenter.y - baseLength * sinf(M_PI_4));
            CGPoint leftButtomPoint = CGPointMake(negitiveCenter.x - baseLength * cosf(M_PI_4), negitiveCenter.y + baseLength * sinf(M_PI_4));
            CGPoint rightBottomPoint = CGPointMake(negitiveCenter.x + baseLength * cosf(M_PI_4), negitiveCenter.y + baseLength * sinf(M_PI_4));
            CGPoint point[4] = {leftTopPoint,rightTopPoint,leftButtomPoint,rightBottomPoint};
            
            CGContextSaveGState(ctx);
            CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
            for (NSInteger i = 0; i < 4; i++) {
                CGContextAddArc(ctx, point[i].x, point[i].y, 2.0, 0, 2 * M_PI, 1);
                CGContextDrawPath(ctx, kCGPathFill);
            }
            CGContextRestoreGState(ctx);
            
            CGContextSaveGState(ctx);
            CGContextSetLineWidth(ctx, 4.0f);
            CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
            CGContextMoveToPoint(ctx, leftTopPoint.x, leftTopPoint.y);
            CGContextAddLineToPoint(ctx, rightBottomPoint.x, rightBottomPoint.y);
            CGContextMoveToPoint(ctx, leftButtomPoint.x, leftButtomPoint.y);
            CGContextAddLineToPoint(ctx, rightTopPoint.x, rightTopPoint.y);
            CGContextMoveToPoint(ctx, rightTopPoint.x, rightTopPoint.y);
            CGContextDrawPath(ctx, kCGPathStroke);
            CGContextRestoreGState(ctx);
            
        }
    }
}

@end

