//
//  Firework.m
//  Animation
//
//  Created by 9158 on 16/4/23.
//  Copyright © 2016年 9158. All rights reserved.
//

#import "Firework.h"

@interface Firework ()


@end

@implementation Firework {
    int step;
    CALayer *sublayer;
    CALayer *sublayer2;
    UIView *backgroundView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        step = 0;
    }
    return self;
}

- (void)startAnimationAtView: (UIView *)currentView {
    backgroundView = currentView;
    // 烟花开始从发射点发射到结束点的动画
    sublayer =[CALayer layer];
    
    sublayer.backgroundColor =[UIColor orangeColor].CGColor;
    sublayer.shadowOffset = CGSizeMake(0, 3);
    sublayer.shadowRadius =5.0;
    sublayer.shadowColor =[UIColor blackColor].CGColor;
    sublayer.shadowOpacity = 1;
    
    sublayer.borderColor =[UIColor blackColor].CGColor;
    sublayer.borderWidth =2.0;
    sublayer.cornerRadius =10.0;
    sublayer.anchorPoint = CGPointMake(0.5, 0.5);
    [backgroundView.layer addSublayer:sublayer];
    
    CGImageRef img = [UIImage imageNamed:@"QQ20160423-1.png"].CGImage;
    sublayer.contents = (__bridge id)img;
    sublayer.frame = CGRectMake(0, 0, CGImageGetWidth(img), CGImageGetWidth(img));
    sublayer.position = _startPosition;
    
//    sublayer.contentsScale = 0.1;
    [sublayer setRasterizationScale:0.1];
    
    CGPoint fromPoint = sublayer.frame.origin;
    
    //路径曲线
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:fromPoint];
    CGPoint toPoint = _endPostion;
    [movePath addQuadCurveToPoint:toPoint
                     controlPoint:CGPointMake(300,0)];
//    sublayer.position = CGPointMake(100, 100);
    
    //关键帧
    CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnim.path = movePath.CGPath;
    moveAnim.removedOnCompletion = YES;
    moveAnim.duration = 1;
    moveAnim.delegate = self;
    
    [sublayer addAnimation:moveAnim forKey:nil];
    sublayer.position = _endPostion;
    
}

- (void) animationDidStart:(CAAnimation *)anim
{
    NSLog(@"animation start");
}

// 烟花的发射到固定点后 再调用爆炸的动画
- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"animation stop");
    if (step == 0){
        [sublayer removeFromSuperlayer];
        
        sublayer2 =[CALayer layer];
        sublayer2.backgroundColor =[UIColor orangeColor].CGColor;
        sublayer2.shadowOffset = CGSizeMake(0, 3);
        sublayer2.shadowRadius =5.0;
        sublayer2.shadowColor =[UIColor blackColor].CGColor;
        sublayer2.shadowOpacity = 1;
        
        sublayer2.borderColor =[UIColor blackColor].CGColor;
        sublayer2.borderWidth =2.0;
        sublayer2.cornerRadius =10.0;
        sublayer2.anchorPoint = CGPointMake(0.5, 0.5);
        [backgroundView.layer addSublayer:sublayer2];
        
        CGImageRef img = [UIImage imageNamed:@"QQ20160423-0.png"].CGImage;
        sublayer2.contents = (__bridge id)img;
        sublayer2.frame = CGRectMake(0, 0, CGImageGetWidth(img), CGImageGetWidth(img));
        sublayer2.position = _endPostion;
        
        //旋转变化
        CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnim.fromValue = [NSNumber numberWithFloat:0.1];
        //x，y轴缩小到0.1,Z 轴不变
        scaleAnim.toValue = [NSNumber numberWithFloat:1.0];
        scaleAnim.duration = 0.5;
        scaleAnim.delegate = self;
        [sublayer2 addAnimation:scaleAnim forKey:nil];
    }else if(step == 1){
        [sublayer2 removeFromSuperlayer];
        NSLog(@"_sublayer2 remove");
    }
    step++;
    
    
    
}
@end

